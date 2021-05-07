import 'package:intl/intl.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/main.dart';

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

  /// A list of all the date names.
  static const List<MyDate> values = <MyDate>[
    hoy, ayer, estaSemana, laSemanaPasada, ultimos2Dias, esteMes
  ];

  static List<dynamic> listaFecha = [[hoy, "Hoy"], [ayer, "Ayer"], [estaSemana, "Esta semana"], [laSemanaPasada, "La semana pasada"]];
  static List<dynamic> listaFechaLarga = [[hoy, "Hoy"], [ayer, "Ayer"], [ultimos2Dias, "Ultimos 2 días"], [estaSemana, "Esta semana"], [laSemanaPasada, "La Semana pasada"], [esteMes, "Este mes"],];

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


  static isHoy(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getHoy();
    return fechaInicial.isAtSameMomentAs(fechasHoy[0]) && fechaFinal.isAtSameMomentAs(fechasHoy[1]);
  }

  static isAyer(DateTime fechaInicial, DateTime fechaFinal){
    var fechasHoy = MyDate.getAyer();
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

  static datetimeToHour(DateTime fechaInicial, [mostrarAno = false]){
    String fechaString = "fecha";
    var now = DateTime.now();
    print("MyDate.datesToString i: ${fechaInicial.toString()}");
    if((fechaInicial.month == now.month) && (fechaInicial.year == now.year)){
      String dia = (fechaInicial.day == now.day) ? "" : "${fechaInicial.day}";
      String ano = mostrarAno ? " ${fechaInicial.year}" : '';

      if(dia.isEmpty)
        fechaString = "${DateFormat('hh:mm:ss a')}$ano" ;
      else
        fechaString = "$dia ${DateFormat.Md(MyApp.myLocale.languageCode).format(fechaInicial)}$ano" ;
    }
    else if((fechaInicial.month != now.month) && (fechaInicial.year == now.year)){
      String ano = mostrarAno ? " ${fechaInicial.year}" : '';
      fechaString = "${DateFormat.Md(MyApp.myLocale.languageCode).format(fechaInicial)}$ano" ;
    }
    else if((fechaInicial.month != now.month) && (fechaInicial.year != now.year)){
      fechaString = "${DateFormat.yMd(MyApp.myLocale.languageCode).format(fechaInicial)}" ;
    }
    return fechaString;
  }

}