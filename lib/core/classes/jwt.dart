import 'dart:convert';

import 'package:loterias/core/classes/utils.dart';
import 'package:crypto/crypto.dart';

class JWT{
  var mapPayload = new Map<String, dynamic>();
  var mapHeader = new Map<String, dynamic>();
  JWT(){
    this.mapPayload["id"] = 15;
    this.mapPayload["username"] = "jeanflutter";

    this.mapHeader["alg"] = "HS256";
    this.mapHeader["typ"] = "JWT";
  }

  createToken(){
    String encodedHeader = Utils.toBase64(Utils.toUtf8(json.encode(this.mapHeader)));
    String encodedData = Utils.toBase64(Utils.toUtf8(json.encode(this.mapPayload)));

    String token = encodedHeader + "." + encodedData;

  }
}