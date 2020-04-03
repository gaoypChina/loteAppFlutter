import 'package:flutter/services.dart';

class ShareChannel{
  static const _methodChannel = MethodChannel("flutter.loterias");
  static Future<String> shareHtmlImageToSmsWhatsapp({String html, String codigoQr, bool sms_o_whatsapp}) async {
    String result = "";
    try{
      result = await _methodChannel.invokeMethod('share', {"html":html, "codigoQr" : codigoQr, "sms_o_whatsapp" : sms_o_whatsapp});
    } on PlatformException catch (e) {
      result = "Failed to get battery level: '${e.message}'.";
    }

    return result;
  }
}