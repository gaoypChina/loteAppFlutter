import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/monedas.dart';

class MyMontoBloqueo extends StatelessWidget {
  final double monto;
  final Moneda moneda;
  const MyMontoBloqueo({Key key, @required this.monto, @required this.moneda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
      child: Text("${Utils.toCurrency(monto)} ${moneda.abreviatura}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
    );
  }
}