package com.example.loterias

class CMD{
    companion object{
        val textSizeNormal = byteArrayOf(0x1b, 0x21, 0x00)
        val textSizeLarge = byteArrayOf(0x1b, 0x21, 0x30)
        val textSizeDoubleHeight = byteArrayOf(0x1b, 0x21, 0x10)
        val textAlignLeft = byteArrayOf(0x1b, 0x61, 0x00)
        val textAlignCenter = byteArrayOf(0x1b, 0x61, 0x01)
        val textAlignRight = byteArrayOf(0x1b, 0x61, 0x02)

        open fun qr(content: String): ByteArray? {
            val commands = HashMap<Any, Any>()
            val commandSequence = arrayOf("model", "size", "error", "store", "content", "print")
            val contentLen = content.length
            var resultLen = 0
            var command: ByteArray

            // QR Code: Select the model
            //              Hex     1D      28      6B      04      00      31      41      n1(x32)     n2(x00) - size of model
            // set n1 [49 x31, model 1] [50 x32, model 2] [51 x33, micro qr code]
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=140
            command = byteArrayOf(0x1d.toByte(), 0x28.toByte(), 0x6b.toByte(), 0x04.toByte(), 0x00.toByte(), 0x31.toByte(), 0x41.toByte(), 0x32.toByte(), 0x00.toByte())
            commands["model"] = command
            resultLen += command.size

            // QR Code: Set the size of module
            // Hex      1D      28      6B      03      00      31      43      n
            // n depends on the printer
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=141
            command = byteArrayOf(0x1d.toByte(), 0x28.toByte(), 0x6b.toByte(), 0x03.toByte(), 0x00.toByte(), 0x31.toByte(), 0x43.toByte(), 0x06.toByte())
            commands["size"] = command
            resultLen += command.size

            //          Hex     1D      28      6B      03      00      31      45      n
            // Set n for error correction [48 x30 -> 7%] [49 x31-> 15%] [50 x32 -> 25%] [51 x33 -> 30%]
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=142
            command = byteArrayOf(0x1d.toByte(), 0x28.toByte(), 0x6b.toByte(), 0x03.toByte(), 0x00.toByte(), 0x31.toByte(), 0x45.toByte(), 0x33.toByte())
            commands["error"] = command
            resultLen += command.size

            // QR Code: Store the data in the symbol storage area
            // Hex      1D      28      6B      pL      pH      31      50      30      d1...dk
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=143
            //                        1D          28          6B         pL          pH  cn(49->x31) fn(80->x50) m(48->x30) d1…dk
            val storeLen = contentLen + 3
            val store_pL = (storeLen % 256).toByte()
            val store_pH = (storeLen / 256).toByte()
            command = byteArrayOf(0x1d.toByte(), 0x28.toByte(), 0x6b.toByte(), store_pL, store_pH, 0x31.toByte(), 0x50.toByte(), 0x30.toByte())
            commands["store"] = command
            resultLen += command.size

            // QR Code content
            command = content.toByteArray()
            commands["content"] = command
            resultLen += command.size

            // QR Code: Print the symbol data in the symbol storage area
            // Hex      1D      28      6B      03      00      31      51      m
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=144
            command = byteArrayOf(0x1d.toByte(), 0x28.toByte(), 0x6b.toByte(), 0x03.toByte(), 0x00.toByte(), 0x31.toByte(), 0x51.toByte(), 0x30.toByte())
            commands["print"] = command
            resultLen += command.size
            var cnt = 0
            var commandLen = 0
            val result = ByteArray(resultLen)
            for (currCommand in commandSequence) {
                command = commands[currCommand] as ByteArray
                commandLen = command.size
                System.arraycopy(command, 0, result, cnt, commandLen)
                cnt += commandLen
            }
            return result
        }
    }
}