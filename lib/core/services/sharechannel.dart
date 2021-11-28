import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:path_provider/path_provider.dart';

class ShareChannel{
  static const _methodChannel = MethodChannel("flutter.loterias");
  static Future<String> shareHtmlImageToSmsWhatsapp({Uint8List base64image, String codigoQr, bool sms_o_whatsapp}) async {
    String result = "";
    try{
      // ByteData byteData = await rootBundle.load("assets/images/loterias_dominicanas_sin_letras.png");
      // base64image = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      // final dateTimeName = "${Utils.dateTimeToMilisenconds(DateTime.now())}.jpg";
      // final tempDir = await getTemporaryDirectory();
      // final file = await new File('${tempDir.path}/$dateTimeName').create();
      // await file.writeAsBytes(base64image);
      
      // result = await _methodChannel.invokeMethod('share', {"image": base64Encode(Utils.uint8ListToListIn(base64image)), "codigoQr" : codigoQr, "sms_o_whatsapp" : sms_o_whatsapp});
      result = await _methodChannel.invokeMethod('share', {"image": base64image, "codigoQr" : codigoQr, "sms_o_whatsapp" : sms_o_whatsapp});
    } on PlatformException catch (e) {
      result = "Failed to get battery level: '${e.message}'.";
    }

    return result;
  }
}