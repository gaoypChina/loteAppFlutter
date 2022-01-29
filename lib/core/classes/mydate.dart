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

  static const MyDate hastaManana = MyDate._(8);
  static const MyDate porDosDias = MyDate._(9);
  static const MyDate porTresDias = MyDate._(10);
  static const MyDate porUnaSemana = MyDate._(11);
  static const MyDate porDosSemanas = MyDate._(12);
  static const MyDate porUnMes = MyDate._(13);
  static const MyDate porTresMeses = MyDate._(14);
  static const MyDate porUnAno = MyDate._(15);

  /// A list of all the date names.
  static const List<MyDate> values = <MyDate>[
    hoy, ayer, estaSemana, laSemanaPasada, ultimos2Dias, esteMes, anteayer, ultimos30Dias, hastaManana, porDosDias, porTresDias, porUnaSemana, porDosSemanas, porUnMes, porTresMeses, porUnAno
  ];

  static List<dynamic> listaFecha = [[hoy, "Hoy"], [ayer, "Ayer"], [anteayer, "Anteayer"], [ultimos2Dias, "Ultimos 2 días"], [estaSemana, "Esta semana"], [laSemanaPasada, "La semana pasada"]];
  static List<dynamic> listaFechaLarga = [[hoy, "Hoy"], [ayer, "Ayer"], [anteayer, "Anteayer"], [ultimos2Dias, "Ultimos 2 días"], [estaSemana, "Esta semana"], [laSemanaPasada, "La Semana pasada"], [esteMes, "Este mes"], [ultimos30Dias, "Ultimos 30 días"],];
  static List<dynamic> listaFechaCorta = [[hoy, "Hoy"], [ayer, "Ayer"], [anteayer, "Anteayer"],];
  static List<dynamic> listaFechaFuturo = [[hoy, "Hoy"], [porDosDias, "Por 2 dias"], [porTresDias, "Por 3 dias"], [porUnaSemana, "Por 1 semana"], [porDosSemanas, "Por 2 semanas"], [porUnMes, "Por 1 mes"], [porTresMeses, "Por 3 meses"], [porUnAno, "Por 1 año"],];

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

  static List<DateTime> getPorDosDias(){
    var fechaActual = DateTime.now();
    var fecha2Dias = DateTime.now().add(Duration(days: 2));
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fecha2Dias.year}-${Utils.toDosDigitos(fecha2Dias.month.toString())}-${Utils.toDosDigitos(fecha2Dias.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getPorTresDias(){
    var fechaActual = DateTime.now();
    var fecha3Dias = DateTime.now().add(Duration(days: 3));
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fecha3Dias.year}-${Utils.toDosDigitos(fecha3Dias.month.toString())}-${Utils.toDosDigitos(fecha3Dias.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getPorUnaSemana(){
    var fechaActual = DateTime.now();
    var fechaUnaSemana = DateTime.now().add(Duration(days: 7));
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaUnaSemana.year}-${Utils.toDosDigitos(fechaUnaSemana.month.toString())}-${Utils.toDosDigitos(fechaUnaSemana.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getPorDosSemanas(){
    var fechaActual = DateTime.now();
    var fechaDosSemanas = DateTime.now().add(Duration(days: 14));
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaDosSemanas.year}-${Utils.toDosDigitos(fechaDosSemanas.month.toString())}-${Utils.toDosDigitos(fechaDosSemanas.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getPorUnMes(){
    var fechaActual = DateTime.now();
    var fechaPorUnMes = Utils.getNextMonth(fechaActual);
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaPorUnMes.year}-${Utils.toDosDigitos(fechaPorUnMes.month.toString())}-${Utils.toDosDigitos(fechaPorUnMes.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getPorTresMeses(){
    var fechaActual = DateTime.now();
    var fechaPorTresMeses = Utils.getNextMonth(fechaActual, monthsToAdd: 3);
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaPorTresMeses.year}-${Utils.toDosDigitos(fechaPorTresMeses.month.toString())}-${Utils.toDosDigitos(fechaPorTresMeses.day.toString())} 23:59:59");
    return [fechaInicial, fechaFinal];
  }

  static List<DateTime> getPorUnAno(){
    var fechaActual = DateTime.now();
    var fechaPorUnAno = DateTime(fechaActual.year + 1, fechaActual.month, fechaActual.day);
    print("MyDate getPorUnAno: ${fechaPorUnAno.year}");
    var fechaInicial = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(fechaActual.month.toString())}-${Utils.toDosDigitos(fechaActual.day.toString())} 00:00");
    var fechaFinal = DateTime.parse("${fechaPorUnAno.year}-${Utils.toDosDigitos(fechaPorUnAno.month.toString())}-${Utils.toDosDigitos(fechaPorUnAno.day.toString())} 23:59:59");
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

  static isPorDosDias(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorDosDias();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isPorTresDias(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorTresDias();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isPorUnaSemana(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorUnaSemana();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isPorDosSemanas(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorDosSemanas();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isPorUnMes(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorUnMes();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isPorTresMeses(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorTresMeses();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isPorUnAno(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getPorUnAno();
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

  static String dateRangeToNameOrString(DateTimeRange date, [String nullMessage = '']){
    var dateString;

    if(date == null)
      return nullMessage;

    if(date.start == null || date.end == null)
      return nullMessage;
      
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
    else if(MyDate.isPorDosDias(date.start, date.end))
      dateString = "Por 2 días";
    else if(MyDate.isPorTresDias(date.start, date.end))
      dateString = "Por 3 días";
    else if(MyDate.isPorUnaSemana(date.start, date.end))
      dateString = "Por 1 semana";
    else if(MyDate.isPorDosSemanas(date.start, date.end))
      dateString = "Por 2 semanas";
    else if(MyDate.isPorUnMes(date.start, date.end))
      dateString = "Por 1 mes";
    else if(MyDate.isPorTresMeses(date.start, date.end))
      dateString = "Por 3 meses";
    else if(MyDate.isPorUnAno(date.start, date.end))
      dateString = "Por 1 año";
    else if(MyDate.isUltimos30Dias(date.start, date.end))
      dateString = "Ultimos 30 días";
    
    if(dateString == null && date != null)
      dateString = MyDate.datesToString(date.start, date.end);

    print("MyDate dateRangeToNameOrString: $dateString");
    return dateString != null ? dateString : '';
  }

  static String datetimeToHour(DateTime fechaInicial, [mostrarAno = false]){
    String fechaString = "fecha";
    var now = DateTime.now();
    if(fechaInicial == null)
      return '';
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

  static toDateTime(dynamic fecha){
    var datetime = DateTime.tryParse(fecha);
    return datetime != null ? datetime : DateTime.now();
  }

  static int daysDifference(DateTime from, [DateTime to]) {
    if(from == null)
      return null;

    if(to == null)
      to = DateTime.now();

     from = DateTime(from.year, from.month, from.day);
     to = DateTime(to.year, to.month, to.day);
   return (to.difference(from).inHours / 24).round();
  }

  static DateTime getDateFromDiaPago(int diaPago, [DateTime date]){
    DateTime fechaActual = date != null ? date : DateTime.now();
    int lastMonth = fechaActual.month == 1 ? 12 : fechaActual.month - 1;
    DateTime lastMonthFirstDay = DateTime.parse("${fechaActual.year}-${Utils.toDosDigitos(lastMonth.toString())}-${Utils.toDosDigitos('1')} 00:00");
      print("MyDate getDateFromDiaPago: ${diaPago}");

    return Utils.getNextMonthV2(lastMonthFirstDay, dayOfTheMonth: diaPago);
  }

  static String listDateTimeToNameOrString(List<DateTime> dates){
    var dateString;

    if(dates == null)
      return '';
    if(dates.length == 0)
      return '';
      
    
    for (var i=0; i < dates.length; i++) {
      var date = dates[i];

      if(dateString == null)
        dateString = '';

      var string = MyDate.dateRangeToNameOrString(DateTimeRange(start: date, end: date));
      if(string != '')
        dateString += (i + 1) < dates.length ? "$string, " : string;
    }
    
    print("MyDate listDateTimeToNameOrString: $dateString");
    return dateString != null ? dateString : '';
  }

 
}