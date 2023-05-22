import 'dart:async';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:flutter/material.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytext.dart';
import 'package:rxdart/rxdart.dart';

class VentasFacilScreen extends StatefulWidget {
  final Map<String, dynamic> datos;
  const VentasFacilScreen({Key key, this.datos}) : super(key: key);

  @override
  State<VentasFacilScreen> createState() => _VentasFacilScreenState();
}

class _VentasFacilScreenState extends State<VentasFacilScreen> {
  
  StreamController _streamController;
  bool _tienePermisoJugarComoCualquierBanca = false;
  DateTimeRange _date;
  List<Banca> bancas = [];
  Banca _banca;
  bool _isSmallOrMedium = true;
  
  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    _streamController = BehaviorSubject();
    // _init();
    super.initState();
  }

  // _init() async {
  //   try{
  //     inicializarFecha();
  //     inicializarPermisos();
  //     var respuesta = await ReporteService.ventas(fecha: _date.start, fechaFinal: _date.end, idBanca: await getIdBanca(), context: context,);
  //     print("_ventas fechaInicial: ${respuesta["bancas"]}");
  //     inicializarBancas(respuesta);
  //     _streamController.add(respuesta);
  //   } on Exception catch(e){
  //     mostrarError(e);
  //   }
  // }

  // getIdBanca() async {
  //   if(_tienePermisoJugarComoCualquierBanca && bancas.length > 0)
  //     return (_banca != null) ? _banca.id : 0;
  //   else
  //     return widget.idBancaReporteGeneral != null ? widget.idBancaReporteGeneral : await Db.idBanca();
  // }

  inicializarPermisos() async {
   _tienePermisoJugarComoCualquierBanca = await Db.existePermiso("Jugar como cualquier banca");
  }

  inicializarFecha(){
    _date = MyDate.getTodayDateRange();
  }

  // inicializarBancas(respuesta){
  //   bancas = respuesta["bancas"]  != null ? respuesta["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
  //   seleccionarBancaPertenecienteAUsuario();
  // }

  //  seleccionarBancaPertenecienteAUsuario() async {
  //   var bancaMap = await Db.getBanca();
  
  //   Banca banca = bancaMap != null ? Banca.fromMap(bancaMap) : null;
  //   if(banca != null){
  //     var b = bancas.length == 0 ? null : widget.idBancaReporteGeneral != null ? bancas.firstWhere((b) => b.id == widget.idBancaReporteGeneral, orElse: () => null) : bancas.firstWhere((b) => b.id == banca.id, orElse: () => null);
  //     setState(() => _banca = (b != null) ? b : bancas.length > 0 ? bancas[0] : null);
  //   }else{
  //     if(_tienePermisoJugarComoCualquierBanca){
  //       if(bancas.length > 0)
  //         setState(() => _banca = bancas[0]);
  //     }
  //     else
  //       setState(() =>_banca = null);
  //   }
  // }

  mostrarError(Exception e){
    _streamController.addError(e.toString());
  }

  @override
  Widget build(BuildContext context) {
    _isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return Column(
      children: [
        MySubtitle(title: "Ventas"),
        Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(children: [
                ListTile(
                  title: MyText(title: "Vendido"),
                  trailing: Text("${Utils.toCurrency(widget.datos["ventas"])}"),
                ),
                ListTile(
                  title: MyText(title: "Sacado"),
                  trailing: Text("${Utils.toCurrency(widget.datos["premios"])}"),
                ),
                ListTile(
                  title: MyText(title: "Porciento ganado"),
                  trailing: Text("${Utils.toCurrency(widget.datos["comisiones"])}"),
                ),
                ListTile(
                  title: MyText(title: "Total"),
                  trailing: Text("${Utils.toCurrency(widget.datos["neto"])}"),
                ),
              ]),
            )
        // StreamBuilder<Map<String, dynamic>>(
        //   stream: _streamController.stream,
        //   builder: (context, snapshot) {

        //     if(snapshot.hasError)
        //       return MyEmpty(
        //         icon: Icons.error,
        //         title: "Error",
        //         titleButton: "Cargar nuevamente",
        //         onTap: _init,
        //       );

        //     if(!snapshot.hasData)
        //       return Center(child: CircularProgressIndicator());

        //     var datos = snapshot.data;

        //     return Container(
        //       decoration: BoxDecoration(
        //         border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
        //         borderRadius: BorderRadius.circular(10.0)
        //       ),
        //       child: Column(children: [
        //         ListTile(
        //           title: MyText(title: "Vendido"),
        //           trailing: Text("${Utils.toCurrency(datos["ventas"])}"),
        //         ),
        //         ListTile(
        //           title: MyText(title: "Sacado"),
        //           trailing: Text("${Utils.toCurrency(datos["premios"])}"),
        //         ),
        //         ListTile(
        //           title: MyText(title: "Porciento ganado"),
        //           trailing: Text("${Utils.toCurrency(datos["comisiones"])}"),
        //         ),
        //         ListTile(
        //           title: MyText(title: "Total"),
        //           trailing: Text("${Utils.toCurrency(datos["neto"])}"),
        //         ),
        //       ]),
        //     );
        //   }
        // )
      ],
    );
  }
}