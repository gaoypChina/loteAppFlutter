import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/utils.dart';

import '../../main.dart';

class MyDate {

  const MyDate._(this.index);

  /// The encoded integer value of this font weight.
  final int index;
  
  static const MyDate hoy = MyDate._(0);
  static const MyDate ayer = MyDate._(1);
  static const MyDate estaSemana = MyDate._(2);
  static const MyDate laSemanaPasada = MyDate._(3);
  static const MyDate ultimos2Dias = MyDate._(4);
  static const MyDate esteMes = MyDate._(5);
  static const MyDate anteayer = MyDate._(6);
  static const MyDate ultimos30Dias = MyDate._(7);

  /// A list of all the date names.
  static const List<MyDate> values = <MyDate>[
    hoy, ayer, estaSemana, laSemanaPasada, ultimos2Dias, esteMes, anteayer, ultimos30Dias
  ];

  static List<dynamic> listaFecha = [[hoy, "Hoy"], [ayer, "Ayer"], [anteayer, "Anteayer"], [ultimos2Dias, "Ultimos 2 días"], [estaSemana, "Esta semana"], [laSemanaPasada, "La semana pasada"]];
  static List<dynamic> listaFechaLarga = [[hoy, "Hoy"], [ayer, "Ayer"], [anteayer, "Anteayer"], [ultimos2Dias, "Ultimos 2 días"], [estaSemana, "Esta semana"], [laSemanaPasada, "La Semana pasada"], [esteMes, "Este mes"], [ultimos30Dias, "Ultimos 30 días"],];
  static List<dynamic> listaFechaCorta = [[hoy, "Hoy"], [ayer, "Ayer"], [anteayer, "Anteayer"],];

  static List<DateTime> getHoy(){
    var fechaActual = DateTime.now();
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getAyer(){
    var fechaActual = DateTime.now().subtract(Duration(days: 1));
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getAnteAyer(){
    var fechaActual = DateTime.now().subtract(Duration(days: 2));
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getEstaSemana(){
    var fechaActual = DateTime.now();
    int diasARestar = fechaActual.weekday - 1;
    var lunesDeEstaSemana = fechaActual.subtract(Duration(days: diasARestar));
    var fechaInicial = DateTime.parse("${lunesDeEstaSemana.year}-${Utils.toDosDigitos(lunesDeEstaSemana.month.toString())}-${Utils.toDosDigitos(lunesDeEstaSemana.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getSemanaPasada(){
    var fechaActual = DateTime.now();
    int diasARestar = fechaActual.weekday;
    var domingoDeLaSemanaPasada = fechaActual.subtract(Duration(days: diasARestar));
    diasARestar = domingoDeLaSemanaPasada.weekday - 1;
    var lunesDeLaSemanaPasada = domingoDeLaSemanaPasada.subtract(Duration(days: diasARestar));
    var fechaInicial = DateTime.parse("${lunesDeLaSemanaPasada.year}-${Utils.toDosDigitos(lunesDeLaSemanaPasada.month.toString())}-${Utils.toDosDigitos(lunesDeLaSemanaPasada.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${domingoDeLaSemanaPasada.year}-${Utils.toDosDigitos(domingoDeLaSemanaPasada.month.toString())}-${Utils.toDosDigitos(domingoDeLaSemanaPasada.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getUltimos2Dias(){
    var fechaActual = DateTime.now();
    var fechaDosDiasAtras = fechaActual.subtract(Duration(days: 2));
    var fechaInicial = DateTime.parse("${fechaDosDiasAtras.year}-${Utils.toDosDigitos(fechaDosDiasAtras.month.toString())}-${Utils.toDosDigitos(fechaDosDiasAtras.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getEsteMes(){
    var fechaActual = DateTime.now();
    var diasARestar = fechaActual.day - 1;
    var fechaPrimerDiaDeEsteMes = fechaActual.subtract(Duration(days: diasARestar));
    var fechaInicial = DateTime.parse("${fechaPrimerDiaDeEsteMes.year}-${Utils.toDosDigitos(fechaPrimerDiaDeEsteMes.month.toString())}-${Utils.toDosDigitos(fechaPrimerDiaDeEsteMes.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getUltimos30Dias(){
    var fechaActual = DateTime.now();
    var fechaDosDiasAtras = fechaActual.subtract(Duration(days: 30));
    var fechaInicial = DateTime.parse("${fechaDosDiasAtras.year}-${Utils.toDosDigitos(fechaDosDiasAtras.month.toString())}-${Utils.toDosDigitos(fechaDosDiasAtras.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }


  static isHoy(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getHoy();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isAyer(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getAyer();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isAnteAyer(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getAnteAyer();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isEstaSemana(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getEstaSemana();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isSemanaPasada(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getSemanaPasada();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isUltimo2Dias(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getUltimos2Dias();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isEsteMes(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getEsteMes();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isUltimos30Dias(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getUltimos30Dias();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static datesToString(DateTime fechaInicial, DateTime fechaFinal, [mostrarAno = false]){
    String fechaString = "fecha";
    print("MyDate.datesToString i: ${fechaInicial.toString()}");
    print("MyDate.datesToString f: ${fechaFinal.toString()}");
    if((fechaInicial.month == fechaFinal.month) && (fechaInicial.year == fechaFinal.year)){
      String dias = (fechaInicial.day == fechaFinal.day) ? "${fechaInicial.day}" : "${fechaInicial.day} - ${fechaFinal.day}";
      String ano = mostrarAno ? " ${fechaInicial.year}" : '';

      fechaString = "$dias ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)}$ano" ;
    }
    else if((fechaInicial.month != fechaFinal.month) && (fechaInicial.year == fechaFinal.year)){
      String ano = mostrarAno ? " ${fechaInicial.year}" : '';
      fechaString = "${fechaInicial.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)} - ${fechaFinal.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaFinal)}$ano";
    }
    else if((fechaInicial.month != fechaFinal.month) && (fechaInicial.year != fechaFinal.year)){
      fechaString = "${fechaInicial.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)} ${fechaInicial.year} - ${fechaFinal.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaFinal)} ${fechaFinal.year}";
    }
    return fechaString;
  }

  static MyDate dateRangeToMyDate(DateTimeRange date){
    MyDate dateString = null;
    if(MyDate.isHoy(date.start, date.end))
      dateString = MyDate.hoy;
    else if(MyDate.isAyer(date.start, date.end))
      dateString = MyDate.ayer;
    else if(MyDate.isAnteAyer(date.start, date.end))
      dateString = MyDate.anteayer;
    else if(MyDate.isEstaSemana(date.start, date.end))
      dateString = MyDate.estaSemana;
    else if(MyDate.isSemanaPasada(date.start, date.end))
      dateString = MyDate.laSemanaPasada;
    else if(MyDate.isUltimo2Dias(date.start, date.end))
      dateString = MyDate.ultimos2Dias;
    else if(MyDate.isEsteMes(date.start, date.end))
      dateString = MyDate.esteMes;
    else if(MyDate.isUltimos30Dias(date.start, date.end))
      dateString = MyDate.ultimos30Dias;

    print("MyDate dateRangeToNameOrString: $dateString");
    return dateString;
  }

  static String dateRangeToNameOrString(DateTimeRange date){
    var dateString = null;
    if(MyDate.isHoy(date.start, date.end))
      dateString = "Hoy";
    else if(MyDate.isAyer(date.start, date.end))
      dateString = "Ayer";
    else if(MyDate.isAnteAyer(date.start, date.end))
      dateString = "Anteayer";
    else if(MyDate.isEstaSemana(date.start, date.end))
      dateString = "Esta semana";
    else if(MyDate.isSemanaPasada(date.start, date.end))
      dateString = "La semana pasada";
    else if(MyDate.isUltimo2Dias(date.start, date.end))
      dateString = "Ultimos 2 días";
    else if(MyDate.isEsteMes(date.start, date.end))
      dateString = "Este mes";
    else if(MyDate.isUltimos30Dias(date.start, date.end))
      dateString = "Ultimos 30 días";
    
    if(dateString == null)
      dateString = MyDate.datesToString(date.start, date.end);

    print("MyDate dateRangeToNameOrString: $dateString");
    return dateString;
  }

  static datetimeToHour(DateTime fechaInicial, [mostrarAno = false]){
    String fechaString = "fecha";
    var now = DateTime.now();
    print("MyDate.datesToString i: ${fechaInicial.toString()}");
    if((fechaInicial.month == now.month) && (fechaInicial.year == now.year)){
      String dia = (fechaInicial.day == now.day) ? "" : "${fechaInicial.day}";
      String ano = mostrarAno ? " ${fechaInicial.year}" : '';

      if(dia.isEmpty)
        fechaString = "${DateFormat('hh:mm a').format(fechaInicial)}$ano" ;
      else
        fechaString = "$dia ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)} ${DateFormat('hh:mm a').format(fechaInicial)} $ano" ;
    }
    else if((fechaInicial.month != now.month) && (fechaInicial.year == now.year)){
      String ano = mostrarAno ? " ${fechaInicial.year}" : '';
      fechaString = "${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)} ${DateFormat('hh:mm a').format(fechaInicial)} $ano" ;
    }
    else if((fechaInicial.month != now.month) && (fechaInicial.year != now.year)){
      fechaString = "${DateFormat.yMd(MyApp.myLocale.languageCode).format(fechaInicial)}" ;
    }
    return fechaString;
  }

  static getTodayDateRange(){
    var _fechaHoy = DateTime.now();
    return DateTimeRange(
      start:  DateTime.parse("${_fechaHoy.year}-${Utils.toDosDigitos(_fechaHoy.month.toString())}-${Utils.toDosDigitos(_fechaHoy.day.toString())} 00:00"), 
      end: DateTime.parse("${_fechaHoy.year}-${Utils.toDosDigitos(_fechaHoy.month.toString())}-${Utils.toDosDigitos(_fechaHoy.day.toString())} 23:59:59")
    );
  }

}