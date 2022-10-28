

import 'package:loterias/core/classes/tipos/tipoVentanaBanca.dart';

class ParametrosBanca{
  int idBanca;
  TipoVentanaBanca tipoVentana;
  ParametrosBanca({this.idBanca, this.tipoVentana = TipoVentanaBanca.normal});
}
