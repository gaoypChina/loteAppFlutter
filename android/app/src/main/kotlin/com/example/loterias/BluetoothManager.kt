package com.example.loterias

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.Main
import kotlinx.coroutines.launch
import java.io.IOException
import java.io.OutputStream
import java.util.*


class BluetoothManager : Activity {
    private val context: Context;
    private val activity: Activity;
    private val sink: EventChannel.EventSink;
    private val bluetoothAdapter: BluetoothAdapter?;
    private val REQUEST_ENABLE_BT = 1
    private val applicationUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")


    constructor(context: Context, sink: EventChannel.EventSink) {
        this.context = context
        this.activity = context as Activity;
        this.sink = sink;
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
    }

    fun startScan() {
        Log.d("startCan", "startScan");
        if (bluetoothAdapter == null) {
            sink.error("UNAVAILABLE", "Device doesn't support bluetooth", null);
        } else {
            if (bluetoothAdapter?.isEnabled == false) {
                turnOnBluetooth();
            } else {
                val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
                this.activity.registerReceiver(receiver, filter);
                try {
//                    bluetoothAdapter.cancelDiscovery()
                    returnBondedDevice()
//                    bluetoothAdapter.startDiscovery();
//                    val timer = object: CountDownTimer(20000, 1000) {
//                        override fun onTick(millisUntilFinished: Long) {...}
//
//                        override fun onFinish() {...}
//                    }
//                    timer.start()
                } catch (e: Exception) {
                    e.printStackTrace()
                    Log.e("bluetoothManager", "Error: " + e.message);
                }
            }
        }
    }

     private fun turnOnBluetooth() {
        if (bluetoothAdapter?.isEnabled == false) {
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            this.activity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
        }
    }

    companion object{
        fun turnOnBluetoothFromFlutter(context: Context, result: MethodChannel.Result) {

            val activity = context as Activity;
            val REQUEST_ENABLE_BT = 1
            val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (bluetoothAdapter?.isEnabled == false) {
                val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                activity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
                result.success(false)
            }else{
                result.success(true)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if (requestCode == REQUEST_ENABLE_BT) {
            if (resultCode == Activity.RESULT_OK) {
                startScan()
            } else {
                sink.error("UNAVAILABLE", "Debe activar bluetooth para usar la impresora", null);
            }
        }
    }

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action: String = intent.action!!
            when (action) {
                BluetoothDevice.ACTION_FOUND -> {
                    val device: BluetoothDevice = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    returnDevice(device, true)// MAC address
                }
            }
        }
    }

    private fun returnDevice(device: BluetoothDevice, escaneadoOemparejado: Boolean) {
        val ret: MutableMap<String, Any> = HashMap()

        if(device.address != null)
            ret["address"] = device.address
        else
            ret["address"] = "no"

        if(device.name != null)
            ret["name"] = device.name
        else
            ret["name"] = "no"
        ret["escaneado"] = escaneadoOemparejado
//        ret["type"] = device.type

        this.sink.success(ret);
    }

    private fun returnBondedDevice() {
        val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter?.bondedDevices
        pairedDevices?.forEach { device ->
            returnDevice(device, false)
        }
    }

    fun stopScan() {
        try {
            this.activity.unregisterReceiver(receiver);
        } catch (e: Exception) {
        }
    }

    private lateinit var connectThread: ConnectThread
    private lateinit var mBluetoothSocket: BluetoothSocket
    fun connect(address: String?) {
        if (address == null) {
            sink.error("UNAVAILABLE", "Cannot connect cause device address is null", null);
            return;
        }
        val device: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice(address);
        Utils.killAppServiceByPackageName(context, null)
        connectThread = ConnectThread(device);
        connectThread.start();
    }

    fun disconnect() {
        connectThread.cancel();
    }

    private inner class ConnectThread(device: BluetoothDevice) : Thread() {
        var fueCanceladoDesdeApp: Boolean = false;
        private val mmSocket: BluetoothSocket? by lazy(LazyThreadSafetyMode.NONE) {
            device.createRfcommSocketToServiceRecord(applicationUUID)
        }

        public override fun run() {
            // Cancel discovery because it otherwise slows down the connection.
            bluetoothAdapter?.cancelDiscovery()

            try {
                var prueba = mmSocket?.let { socket ->
                    // Connect to the remote device through the socket. This call blocks
                    // until it succeeds or throws an exception.
                    socket.connect()
                    mBluetoothSocket = socket

                    CoroutineScope(Main).launch {
                        sink.success(true)
                    }

                    try {
                        socket.inputStream.read()
                    } catch (e: Exception) {
                        if (!fueCanceladoDesdeApp) {
                            CoroutineScope(Main).launch {
                                sink.error("UNAVAILABLE", "Se perdio conexion con la impresora", null);
                            }
                        }
                        Log.d("ErrorSocketLet", "Error: ${e.toString()}")
                    }

//                    CoroutineScope(Dispatchers.IO).launch{
//                        var join = async {socket.inputStream.read() }.await()
//                        Log.e("connectThread", "SOcket red: ${join}")
//                    }

                    // The connection attempt succeeded. Perform work associated with
                    // the connection in a separate thread.
                    //manageMyConnectedSocket(socket)

                }


            } catch (e: Exception) {
                CoroutineScope(Main).launch {
                    sink.error("UNAVAILABLE", "Cannot connect to device: ${e.toString()}", null);
                }
            }
        }

        // Closes the client socket and causes the thread to finish.
        fun cancel() {
            try {
                fueCanceladoDesdeApp = true;
                mmSocket?.close()
            } catch (e: IOException) {
                Log.e("BluetoothManager", "Could not close the client socket", e)
            }
        }
    }


    fun POS_S_TextOut(pszString: String, nOrgx: Int, nWidthTimes: Int, nHeightTimes: Int, nFontType: Int, nFontStyle: Int) : Boolean {
        try {
            if (nOrgx > 65535 || nOrgx < 0 || nWidthTimes > 7 || nWidthTimes < 0 || nHeightTimes > 7 || nHeightTimes < 0 || nFontType < 0 || nFontType > 4 || pszString.length == 0) {
                throw java.lang.Exception("invalid args")
            }
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()
            val Cmd: ESCCMD = ESCCMD();
            Cmd.ESC_dollors_nL_nH[2] = (nOrgx % 256).toByte()
            Cmd.ESC_dollors_nL_nH[3] = (nOrgx / 256).toByte()
            val intToWidth = byteArrayOf(0, 16, 32, 48, 64, 80, 96, 112)
            val intToHeight = byteArrayOf(0, 1, 2, 3, 4, 5, 6, 7)
            Cmd.GS_exclamationmark_n[2] = (intToWidth[nWidthTimes] + intToHeight[nHeightTimes]).toByte()
            var tmp_ESC_M_n: ByteArray = Cmd.ESC_M_n
            if (nFontType != 0 && nFontType != 1) {
                tmp_ESC_M_n = ByteArray(0)
            } else {
                tmp_ESC_M_n[2] = nFontType.toByte()
            }
            Cmd.GS_E_n[2] = (nFontStyle shr 3 and 1).toByte()
            Cmd.ESC_line_n[2] = (nFontStyle shr 7 and 3).toByte()
            Cmd.FS_line_n[2] = (nFontStyle shr 7 and 3).toByte()
            Cmd.ESC_lbracket_n[2] = (nFontStyle shr 9 and 1).toByte()
            Cmd.GS_B_n[2] = (nFontStyle shr 10 and 1).toByte()
            Cmd.ESC_V_n[2] = (nFontStyle shr 12 and 1).toByte()
            Cmd.ESC_9_n[2] = 1
            val pbString = pszString.toByteArray()
            val data: ByteArray = byteArraysToBytes(arrayOf(Cmd.ESC_dollors_nL_nH, Cmd.GS_exclamationmark_n, tmp_ESC_M_n, Cmd.GS_E_n, Cmd.ESC_line_n, Cmd.FS_line_n, Cmd.ESC_lbracket_n, Cmd.GS_B_n, Cmd.ESC_V_n, Cmd.FS_AND, Cmd.ESC_9_n, pbString))!!
            os.write(data, 0, data.size)
            os.flush()

            return true;

//            InputStream largeDataInputStream = mBluetoothSocket.getInputStream();
//            int length;
//            while ((length = largeDataInputStream.read(data)) != -1) {
//                Log.d("largeDataInputStream", "index:" + length);
//            }
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun prueba(pszString: String) : Boolean {
        try {
//            if (nOrgx > 65535 || nOrgx < 0 || nWidthTimes > 7 || nWidthTimes < 0 || nHeightTimes > 7 || nHeightTimes < 0 || nFontType < 0 || nFontType > 4 || pszString.length == 0) {
//                throw java.lang.Exception("invalid args")
//            }
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()
            val textSizeNormal = byteArrayOf(0x1b, 0x21, 0x00)
            val textSizeLarge = byteArrayOf(0x1b, 0x21, 0x30)
            val textSizeDoubleHeight = byteArrayOf(0x1b, 0x21, 0x10)
            val qr = byteArrayOf(0x1c, 0x7d, 0x25)
            val textAlignCenter = byteArrayOf(0x1b, 0x61, 0x01)
            val data = pszString.toByteArray()

            os.write(textAlignCenter)

            os.write(textSizeNormal)
            os.write(data, 0, data.size)

            os.write(textSizeLarge)
            os.write(data, 0, data.size)

            os.write(textSizeDoubleHeight)
            os.write(data, 0, data.size)

//            os.write(qr)
            os.write(qrCode(pszString))
            os.write("\n\n\n".toByteArray())

//            os.write("hola".toByteArray(), 0, "hola".toByteArray().size)
            os.flush()

            return true;

//            InputStream largeDataInputStream = mBluetoothSocket.getInputStream();
//            int length;
//            while ((length = largeDataInputStream.read(data)) != -1) {
//                Log.d("largeDataInputStream", "index:" + length);
//            }
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun h1(text: String) : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.textSizeLarge)
            os.write(text.toByteArray(), 0, text.toByteArray().size)
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun h2(text: String) : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.textSizeDoubleHeight)
            os.write(text.toByteArray(), 0, text.toByteArray().size)
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }
    fun p(text: String) : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.textSizeNormal)
            os.write(text.toByteArray(), 0, text.toByteArray().size)
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun left() : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.textAlignLeft)
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun center() : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.textAlignCenter)
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun right() : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.textAlignRight)
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    fun qr(text: String) : Boolean {
        try {
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            os.write(CMD.qr(text))
            os.flush()

            return true;
        } catch (var15: java.lang.Exception) {
            Log.i("Pos", var15.toString())
            return false;
        }
    }

    /**
     * Encode and print QR code
     *
     * @param str
     *          String to be encoded in QR.
     * @param errCorrection
     *          The degree of error correction. (48 <= n <= 51)
     *          48 = level L / 7% recovery capacity.
     *          49 = level M / 15% recovery capacity.
     *          50 = level Q / 25% recovery capacity.
     *          51 = level H / 30% recovery capacity.
     *
     *  @param moduleSize
     *  		The size of the QR module (pixel) in dots.
     *  		The QR code will not print if it is too big.
     *  		Try setting this low and experiment in making it larger.
     */
    open fun qrCode(content: String): ByteArray? {
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

    fun POS_S_Align(align: Int) {
        try {
            if (align < 0 || align > 2) {
                throw java.lang.Exception("invalid args")
            }
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()

            val Cmd: ESCCMD = ESCCMD();
            val data: ByteArray = Cmd.ESC_a_n
            data[2] = align.toByte()
            os.write(data, 0, data.size)
        } catch (var6: java.lang.Exception) {
            Log.i("Pos", var6.toString())
        }
    }

    fun POS_S_SetQRcode(strCodedata: String, nWidthX: Int, nVersion: Int, nErrorCorrectionLevel: Int) {
        try {
            if (nWidthX < 1 || nWidthX > 16 || nErrorCorrectionLevel < 1 || nErrorCorrectionLevel > 4 || nVersion < 0 || nVersion > 16) {
                throw java.lang.Exception("invalid args")
            }
            val os: OutputStream = mBluetoothSocket
                    .getOutputStream()
            val bCodeData = strCodedata.toByteArray()
            val Cmd : ESCCMD = ESCCMD();

            Cmd.GS_w_n[2] = nWidthX.toByte()
            Cmd.GS_k_m_v_r_nL_nH[3] = nVersion.toByte()
            Cmd.GS_k_m_v_r_nL_nH[4] = nErrorCorrectionLevel.toByte()
            Cmd.GS_k_m_v_r_nL_nH[5] = (bCodeData.size and 255).toByte()
            Cmd.GS_k_m_v_r_nL_nH[6] = (bCodeData.size and '\uff00'.toInt() shr 8).toByte()
            val data: ByteArray = byteArraysToBytes(arrayOf(Cmd.GS_w_n, Cmd.GS_k_m_v_r_nL_nH, bCodeData))!!
            os.write(data, 0, data.size)
        } catch (var10: java.lang.Exception) {
            Log.i("Pos", var10.toString())
        }
    }

    private fun byteArraysToBytes(data: Array<ByteArray>): ByteArray? {
        var length = 0
        for (i in data.indices) {
            length += data[i].size
        }
        val send = ByteArray(length)
        var k = 0
        for (i in data.indices) {
            for (j in 0 until data[i].size) {
                send[k++] = data[i][j]
            }
        }
        return send
    }

}