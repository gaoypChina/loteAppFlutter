import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/pagodetalle.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/pagosservice.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:rxdart/rxdart.dart';

class PagosAddScreen extends StatefulWidget {
  final Servidor servidor;
  final Pago pago;
  const PagosAddScreen({ Key key, @required this.servidor, this.pago}) : super(key: key);

  @override
  _PagosAddScreenState createState() => _PagosAddScreenState();
}

class _PagosAddScreenState extends State<PagosAddScreen> {
  StreamController<List<Pagodetalle>> _streamController;
  var _txtCliente = TextEditingController();
  var _txtPrecioPorBanca = TextEditingController();
  var _txtDescuentos = TextEditingController();
  var _txtCargos = TextEditingController();
  DateTimeRange _fechaPeriodoPago;
  Future _future;
  var _rotateNotifier = ValueNotifier<double>(0);
  List<Banca> listaBanca = [];

  _init() async {
    var parsed = await PagosService.index(context: context, servidor: widget.servidor);
    _initFechaPago();
    print("PagosAddScreen _init: $parsed");
  }

  _initFechaPago(){
    if(widget.servidor.fechaProximoPago == null){
      _fechaPeriodoPago = null;
      return;
    }

    _fechaPeriodoPago = DateTimeRange(start: Utils.getLastMonth(widget.servidor.fechaProximoPago, dayOfTheMonth: widget.servidor.diaPago), end: widget.servidor.fechaProximoPago);
  }

  _refreshBancas() async {
    var parsed = await PagosService.getBancaDetallesPago(context: context, servidor: widget.servidor, fechaInicial: _fechaPeriodoPago.start, fechaFinal: _fechaPeriodoPago.end, precioMensualPorBanca: Utils.toDouble(_txtPrecioPorBanca.text));
    print("PagosAddScreen _refreshBancas: $parsed");
  }

  _dateChanged(DateTimeRange date){
    setState(() => _fechaPeriodoPago = date);
  }

  _showDateTimeRangeCalendar(){
    _back(){
      Navigator.pop(context);
    }
    showMyModalBottomSheet(
      context: context, 
      myBottomSheet2: MyBottomSheet2(
        child: MyDateRangeDialog(
          date: _fechaPeriodoPago,
          onCancel: _back,
          onOk: (date){
            _dateChanged(date);
            _back();
          },
        ), 
      height: 350
      )
    );
  }

  _bancasScreen(bool isSmallOrMedium){
    return StreamBuilder<List<Pagodetalle>>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        double total = snapshot.data != null ? snapshot.data.length > 0 ? snapshot.data.map((e) => e.aPagar).toList().reduce((value, element) => value + element) : 0 : 0;

        return ExpansionTile(
          title: Text("Bancas"),
          subtitle: Text("Total $total"),
          onExpansionChanged: (isExpanding){
            if(isExpanding)
              _rotateNotifier.value = pi / 1;
            else
              _rotateNotifier.value = 0;
          },
          trailing: Wrap(
            children: [
              IconButton(icon: Icon(Icons.refresh), onPressed: _refreshBancas,),
              ValueListenableBuilder<Object>(
                valueListenable: _rotateNotifier,
                builder: (context, value, __) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Transform.rotate(
                      angle: value,
                      child: Icon(Icons.arrow_drop_down)
                    ),
                  );
                }
              )
            ],
          ),
          children: 
            snapshot.data != null 
            ? 
            snapshot.data.length > 0 
            ? 
            snapshot.data.map((e) => ListTile(
              title: Text("${e.descripcionBanca}"),
            ))
            ,
        );
      }
    );
  }

  _fechaScreen(bool isSmallOrMedium){
    if(widget.servidor.fechaProximoPago != null)
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text("${_fechaPeriodoPago != null ? MyDate.dateRangeToNameOrString(_fechaPeriodoPago) : 'Seleccionar fecha'}"),
      onTap: (){
        _showDateTimeRangeCalendar();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _future = _init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Crear factura",
          subtitle: Padding(
            padding: EdgeInsets.only(left: isSmallOrMedium ? 50.0 : 0.0),
            child: MyContainerButton(
              borderColor: Colors.black,
              data: ["${widget.servidor.descripcion}", "${widget.servidor.descripcion}"], 
              onTap: (data){

              }
            ),
          ),
        ), 
        sliver: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

            return SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyTextFormField(
                    leading: isSmallOrMedium ? SizedBox.shrink() : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                    fontSize: isSmallOrMedium ? 28 : null,
                    controller: _txtCliente,
                    title: !isSmallOrMedium ? "Cliente" : "",
                    hint: "Cliente",
                    medium: 1,
                    xlarge: 1.6,
                    isRequired: true,
                    
                  ),
                ),
                MyDivider(showOnlyOnSmall: true,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyTextFormField(
                    leading: isSmallOrMedium ? Icon(Icons.attach_money, color: Colors.black.withOpacity(0.7),) : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                    controller: _txtPrecioPorBanca,
                    title: !isSmallOrMedium ? "Precio por banca" : "",
                    hint: "Precio por banca",
                    medium: 1,
                    xlarge: 1.6,
                    isRequired: true,
                    
                  ),
                ),
                MyDivider(showOnlyOnSmall: true,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyTextFormField(
                    leading: isSmallOrMedium ? Icon(Icons.money_off, color: Colors.black.withOpacity(0.7),) : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                    controller: _txtDescuentos,
                    title: !isSmallOrMedium ? "Descuentos" : "",
                    hint: "Descuentos",
                    medium: 1,
                    xlarge: 1.6,
                    isRequired: true,
                    
                  ),
                ),
                MyDivider(showOnlyOnSmall: true,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyTextFormField(
                    leading: isSmallOrMedium ? Icon(Icons.moving, color: Colors.black.withOpacity(0.7),) : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                    controller: _txtCargos,
                    title: !isSmallOrMedium ? "Cargos" : "",
                    hint: "Cargos",
                    helperText: "El monto introducido se sumara al total",
                    medium: 1,
                    xlarge: 1.6,
                    isRequired: true,
                    
                  ),
                ),
                
                MyDivider(showOnlyOnSmall: true,),
               _fechaScreen(isSmallOrMedium),
                MyDivider(showOnlyOnSmall: true,),
               _bancasScreen(isSmallOrMedium)
              ]),
            );
            // return SliverList(delegate: SliverChildListDelegate([]));
          }
        )
      )
    );
  }
}