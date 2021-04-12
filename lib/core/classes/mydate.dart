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

  /// A list of all the date names.
  static const List<MyDate> values = <MyDate>[
    hoy, ayer, estaSemana, laSemanaPasada
  ];

  static List<dynamic> listaFecha = [[hoy, "Hoy"], [ayer, "Ayer"], [estaSemana, "Esta semana"], [laSemanaPasada, "La semana pasada"]];

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

  static datesToString(DateTime fechaInicial, DateTime fechaFinal){
    String fechaString = "fecha";
    print("MyDate.datesToString i: ${fechaInicial.toString()}");
    print("MyDate.datesToString f: ${fechaFinal.toString()}");
    if((fechaInicial.month == fechaFinal.month) && (fechaInicial.year == fechaFinal.year)){
      fechaString = "${fechaInicial.day} - ${fechaFinal.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)}";
    }
    else if((fechaInicial.month != fechaFinal.month) && (fechaInicial.year == fechaFinal.year)){
      fechaString = "${fechaInicial.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)} - ${fechaFinal.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaFinal)}";
    }
    else if((fechaInicial.month != fechaFinal.month) && (fechaInicial.year != fechaFinal.year)){
      fechaString = "${fechaInicial.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaInicial)} ${fechaInicial.year} - ${fechaFinal.day} ${DateFormat.LLL(MyApp.myLocale.languageCode).format(fechaFinal)} ${fechaFinal.year}";
    }
    return fechaString;
  }

}