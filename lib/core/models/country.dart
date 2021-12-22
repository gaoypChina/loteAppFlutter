

import 'package:emojis/emojis.dart';
import 'package:loterias/core/classes/utils.dart';

class Country{
  String name;
  String countryCode;
  String isoCode;
  String emoji;

  Country(this.name, this.countryCode, this.isoCode, this.emoji);

  Country.fromMap(Map snapshot) :
        name = snapshot['name'] ?? '',
        countryCode = snapshot['countryCode'] ?? '',
        isoCode = snapshot['isoCode'] ?? '',
        emoji = snapshot['emoji'] != null ? Utils.toInt(snapshot['emoji']) : 0
  ;

  toJson() {
    return {
      "name": name,
      "countryCode": countryCode,
      "isoCode": isoCode,
      "emoji": emoji,
    };
  }

  toJsonFull() {
    return {
      "name": name,
      "countryCode": countryCode,
      "isoCode": isoCode,
      "emoji": emoji,
    };
  }

  static List drawsToJson(List<Country> lista, [var toJsonFull = false]) {
    List jsonList = [];
    lista.map((u)=>
        jsonList.add(toJsonFull ? u.toJsonFull() : u.toJson())
    ).toList();
    return jsonList;
  }
  
  static List<Country> get(){
    return [
      Country("Argentina", "+54", "AR", Emojis.flagArgentina),
      Country("Bolivia", "+591", "BO", Emojis.flagBolivia),
      Country("Chile", "+56", "CL", Emojis.flagChile),
      Country("Colombia", "+57", "CO", Emojis.flagColombia),
      Country("Costa Rica", "+506", "CR", Emojis.flagCostaRica),
      Country("Cuba", "+53", "CU", Emojis.flagCuba),
      Country("República Dominicana", "+1", "DO", Emojis.flagDominicanRepublic),
      Country("Ecuador", "+593", "EC", Emojis.flagEcuador),
      Country("El Salvador", "+503", "SV", Emojis.flagElSalvador),
      Country("Guinea Ecuatorial", "+240", "GQ", Emojis.flagEquatorialGuinea),
      Country("Guatemala", "+502", "GT", Emojis.flagGuatemala),
      Country("Honduras", "+504", "HN", Emojis.flagHonduras),
      Country("México", "+52", "MX", Emojis.flagMexico),
      Country("Nicaragua", "+505", "NI", Emojis.flagNicaragua),
      Country("Panamá", "+507", "PA", Emojis.flagPanama),
      Country("Perú", "+51", "PE", Emojis.flagPeru),
      Country("España", "+34", "ES", Emojis.flagSpain),
      Country("Venezuela", "+58", "VE", Emojis.flagVenezuela),
    ];
  }

}

// flutter packages pub run build_runner build