import 'package:flutter/services.dart';

class ShareChannel{
  static const _methodChannel = MethodChannel("flutter.loterias");
  Future<String> _shareHtmlImageToWhatsapp({String html, String codigoQr}) async {
    String result = "";
    try{
      result = await _methodChannel.invokeMethod('share', {"html":html, "codigoQr" : codigoQr, "sms_o_whatsapp" : false});
    } on PlatformException catch (e) {
      result = "Failed to get battery level: '${e.message}'.";
    }

    return result;
  }

  Future<String> _shareHtmlImageToSms({String html, String codigoQr}) async {
    String result = "";
    try{
      result = await _methodChannel.invokeMethod('share', {"html":html, "codigoQr" : codigoQr, "sms_o_whatsapp" : true});
    } on PlatformException catch (e) {
      result = "Failed to get battery level: '${e.message}'.";
    }

    return result;
  }
}