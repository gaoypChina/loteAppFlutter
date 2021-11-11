import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/pagodetalle.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/pagosservice.dart';
import 'package:loterias/ui/views/pagos/pagodetallebancasearch.dart';
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
  var _formKey = GlobalKey<FormState>();
  StreamController<List<Pagodetalle>> _streamController;
  var _cargandoNotifier = ValueNotifier<bool>(false);
  var _txtCliente = TextEditingController();
  var _txtPrecioPorBanca = TextEditingController();
  var _txtDescuentos = TextEditingController();
  var _txtCargos = TextEditingController();
  var _txtNota = TextEditingController();
  DateTimeRange _fechaPeriodoPago;
  Future _future;
  var _rotateNotifier = ValueNotifier<double>(0);
  List<Pagodetalle> listaBanca = [];
  List<Pagodetalle> listaBancaTmp = [];
  List<Tipo> listaTipo = [];
  Servidor _servidor;
  double totalAPagar = 0;
  Pago _data;

  _init() async {
    var parsed = await PagosService.index(context: context, servidor: widget.servidor, pago: widget.pago);
    _servidor = parsed["servidor"] != null ? Servidor.fromMap(parsed["servidor"]) : null;
    listaTipo = parsed["tipos"] != null ? parsed["tipos"].map<Tipo>((e) => Tipo.fromMap(e)).toList() : [];
    _initFechaPago();
    _setAllFields(parsed);
    _setTotalesBanca(listaBanca);
    print("PagosAddScreen _init: ${parsed['data']}");
    print("PagosAddScreen _init tipos: ${listaTipo.length}");
  }

  _setAllFields(var parsed){
    _data = parsed["data"] != null ? Pago.fromMap(parsed["data"]) : null;


    _txtCliente.text = _servidor != null ? "${_servidor.cliente != null  ? _servidor.cliente : ''}" : null;
    _txtPrecioPorBanca.text = _servidor != null ? "${_servidor.precioPorBanca > 0 ? _servidor.precioPorBanca : ''}" : null;

    _txtDescuentos.text = "${_data != null ? _data.descuento : ''}";
    _txtCargos.text = "${_data != null ? _data.cargo : ''}";
    _setDetalles(_data);

    if(_data == null)
      _data = Pago();
  }

  _setDetalles(Pago _data){
    print("PagosAddScreen _setDetalles 0: $_data");
    if(_data == null)
      return;
    print("PagosAddScreen _setDetalles 1: ${listaBanca.length}");

    if(_data.detalles.length == 0)
      return;
    print("PagosAddScreen _setDetalles 2: ${listaBanca.length}");

    listaBanca = List.from(_data.detalles);
    listaBancaTmp = List.from(_data.detalles);
    _streamController.add(listaBanca);
    print("PagosAddScreen _setDetalles: ${listaBanca.length}");
  }

  _guardar() async {
    if(!_formKey.currentState.validate())
      return;

    if(listaBanca == null){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay bancas, debe actualizar para obtenerlas");
      return;
    }

    if(listaBanca.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay bancas, debe actualizar para obtenerlas");
      return;
    }

    try {
      _data.fechaDiaPago = _fechaPeriodoPago.end;
      _data.fechaDiasGracia =  _data.fechaDiaPago.add(Duration(days: _servidor.diasGracia));
      _data.nota = _txtNota.text;
      _data.precioPorBanca = Utils.toDouble(_txtPrecioPorBanca.text);
      _data.servidor = widget.servidor;
      _data.descuento = Utils.toDouble(_txtDescuentos.text);
      _data.cargo = Utils.toDouble(_txtCargos.text);
      _data.total = _getTotal(listaBanca);
      _data.detalles = listaBanca.where((e) => e.total > 0).toList();
      
      _cargandoNotifier.value = true;
      var parsed = await PagosService.guardar(context: context, pago: _data, servidor: widget.servidor, fechaProximoPago: Utils.getFechaProximoPago(_servidor).end);
      
      print("PagosAddScreen guardar: $parsed");
      // print("PagosAddScreen guardar: ${Pago.fromMap(parsed["data"])}");
      Navigator.pop(context, Pago.fromMap(parsed["data"]));
      _cargandoNotifier.value = false;
    } on Exception catch (e) {
      _cargandoNotifier.value = false;
      // TODO
    }
  }

  _initFechaPago(){
    if(widget.servidor.fechaProximoPago == null){
      _fechaPeriodoPago = MyDate.getTodayDateRange();
      return;
    }

    if(widget.pago == null)
      _fechaPeriodoPago = DateTimeRange(start: Utils.getLastMonth(widget.servidor.fechaProximoPago, dayOfTheMonth: widget.servidor.diaPago), end: widget.servidor.fechaProximoPago);
    else{
      _fechaPeriodoPago = DateTimeRange(start: Utils.getLastMonth(widget.pago.fechaDiaPago, dayOfTheMonth: widget.servidor.diaPago), end: widget.pago.fechaDiaPago);
    }
  }

  _refreshBancas() async {
    var parsed = await PagosService.getBancaDetallesPago(context: context, servidor: widget.servidor, fechaInicial: _fechaPeriodoPago.start, fechaFinal: _fechaPeriodoPago.end, precioMensualPorBanca: Utils.toDouble(_txtPrecioPorBanca.text));
    print("PagosAddScreen _refreshBancas: $parsed");
    listaBanca = parsed["bancas"] != null ? parsed["bancas"].map<Pagodetalle>((e) => Pagodetalle.fromMap(e)).toList() : [];

    for (var detalle in listaBanca) {
      if(detalle.tipo == null && detalle.idTipo == null && listaTipo != null){
        if(listaTipo.length > 0)
          detalle.tipo = listaTipo[0];
      }
    }
    
    listaBancaTmp = List.from(listaBanca);
    _streamController.add(listaBanca);
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

   _showBottomSheetTipo({Pagodetalle detalle, bool cambiarTipoEnTodasLasBancas = false}) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        _back({Tipo tipo}){
              Navigator.pop(context, tipo);
            }
            tipoChanged(tipo){
              if(cambiarTipoEnTodasLasBancas){
                for (var detalle in listaBanca) {
                  detalle.tipo = tipo;
                }
                _setTotalesBanca(listaBanca);
                _streamController.add(listaBanca);
              }
              else
                setState(() {
                  detalle.tipo = tipo; 
                  _setTotalesBanca(listaBanca);
                  _streamController.add(listaBanca);
                });

              _back(tipo: tipo);
            }
        return Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaTipo.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: !cambiarTipoEnTodasLasBancas ? detalle.tipo == listaTipo[index] : false,
                          onChanged: (data){
                            tipoChanged(listaTipo[index]);
                          },
                          title: Text("${listaTipo[index].descripcion}",),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        
      
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }

  void _setTotalesBanca(List<Pagodetalle> data){
    if(data == null)
      return;

    if(data.length == 0)
      return;

    double precioMensual = Utils.toDouble(_txtPrecioPorBanca.text);
    double precioDiario = 0;
    if(precioMensual > 0)
      precioDiario = precioMensual / 30;

    for (var detalle in data) {
      detalle.total = 0;
      if(detalle.tipo.descripcion.toLowerCase() == "banca contratada")
        detalle.total = precioMensual;
      else if(detalle.tipo.descripcion.toLowerCase() == "banca usada"){
        if(detalle.diasUsados > 0)
          detalle.total += precioMensual;
      }else if(detalle.tipo.descripcion.toLowerCase() == "dias usados" && detalle.diasUsados > 0){
        detalle.total += precioDiario * detalle.diasUsados;
      }
    }

  }

  double _getTotal(List<Pagodetalle> data){
    double monto = 0;
    if(data == null)
      return monto;

    if(data.length == 0)
      return monto;

    double precioMensual = Utils.toDouble(_txtPrecioPorBanca.text);
    double precioDiario = 0;
    if(precioMensual > 0)
      precioDiario = precioMensual / 30;

    for (var detalle in data) {
      // if(detalle.tipo.descripcion.toLowerCase() == "banca contratada")
      //   monto += precioMensual;
      // else if(detalle.tipo.descripcion.toLowerCase() == "banca usada"){
      //   if(detalle.diasUsados > 0)
      //     monto += precioMensual;
      // }else if(detalle.tipo.descripcion.toLowerCase() == "dias usados" && detalle.diasUsados > 0){
      //   monto += precioDiario * detalle.diasUsados;
      //   print("PagosAddScreen monto: $monto diario: $precioDiario dias: ${detalle.diasUsados}");
      // }
      monto += detalle.total;
    }

    // double descuentos = Utils.toDouble(_txtDescuentos.text);
    // double cargos = Utils.toDouble(_txtCargos.text);

    // if(monto > 0)
    //   monto = (monto - descuentos) + cargos;
    
    return monto;
  }

  _agregarOEliminarBanca() async {
    await showSearch(context: context, delegate: PagoDetalleBancaSearch(listaBancaTmp, listaBanca));

    if(listaBanca.length > 0)
      listaBanca.sort((a, b) => b.diasUsados.compareTo(a.diasUsados));

    _streamController.add(listaBanca);
  }

  _avatarScreen(Pagodetalle data){

    return CircleAvatar(
      backgroundColor: data.diasUsados > 0 ? Colors.green : Colors.pink,
      child: data.diasUsados > 0 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }


  _bancasScreen(bool isSmallOrMedium){
    return StreamBuilder<List<Pagodetalle>>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        totalAPagar = _getTotal(snapshot.data);
        double descuentos = Utils.toDouble(_txtDescuentos.text);
        double cargos = Utils.toDouble(_txtCargos.text);

        return ExpansionTile(
          title: Text("Bancas (${snapshot.data != null ? snapshot.data.length : 0})"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(visible: descuentos > 0 || cargos > 0, child: Text("Subtotal ${Utils.toCurrency(Utils.toDouble(Utils.redondear(totalAPagar)))}")),
              // Text("Total ${Utils.toCurrency(Utils.toDouble(Utils.redondear(totalAPagar)))}"),
              Text("Total ${Utils.toCurrency(Utils.toDouble(Utils.redondear((totalAPagar- descuentos) + cargos)))}"),
            ],
          ),
          onExpansionChanged: (isExpanding){
            if(isExpanding)
              _rotateNotifier.value = pi / 1;
            else
              _rotateNotifier.value = 0;
          },
          trailing: Wrap(
            children: [
              IconButton(icon: Icon(Icons.refresh), onPressed: _refreshBancas, tooltip: "Obtener bancas",),
              IconButton(icon: Icon(Icons.add_rounded), onPressed: _agregarOEliminarBanca, tooltip: "Agregar o eliminar banca",),
              IconButton(icon: Icon(Icons.merge_type), onPressed: (){_showBottomSheetTipo(detalle: null, cambiarTipoEnTodasLasBancas: true);}, tooltip: "Cambiar tipo para todas las bancas",),
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
            snapshot.data.asMap().map((key, e){

              return MapEntry(
                key, 
                Padding(
                  padding: EdgeInsets.only(bottom: snapshot.data.length - 1 == key ? 20.0 : 0),
                  child: ListTile(
                    dense: true,
                    leading: _avatarScreen(e),
                    title: Text("${e.descripcionBanca}"),
                    subtitle: RichText(text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(text: "${e.diasUsados != null ? e.diasUsados : '0'} ${e.diasUsados != null ? e.diasUsados == 1 ? 'dia' : 'dias' : ''}"),
                          TextSpan(text: "${e.total != null ? '  •  ' + Utils.toCurrency(Utils.redondear(e.total)) : ''} a pagar"),
                        ]
                      )),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text("${e.diasUsados} dias"),
                    //     Text("${Utils.toDouble(Utils.redondear(e.aPagar))}"),
                    //   ],
                    // ),
                    trailing: GestureDetector(
                      onTap: (){_showBottomSheetTipo(detalle: e);},
                      child: Text("${e.tipo != null ? e.tipo.descripcion : 'Tipo...'}", style: TextStyle(decoration: TextDecoration.underline),)
                    ),
                  ),
                )
              );
            }).values.toList()
            :
            []
            :
            []
        );
      }
    );
  }

  _fechaScreen(bool isSmallOrMedium){
    // if(widget.servidor == null || _fechaPeriodoPago == null)
    //   return Text("Esa baina esta nula");

    // if(widget.servidor.fechaProximoPago != null)
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text("${_fechaPeriodoPago != null ? MyDate.dateRangeToNameOrString(_fechaPeriodoPago) : 'Seleccionar fecha'}"),
      onTap: (){
        _showDateTimeRangeCalendar();
      },
    );
  }

  _txtDescuentosChanged(data){
    if(data == null)
      return;

    if(totalAPagar > 0)
      setState(() {
        totalAPagar = totalAPagar - Utils.toDouble(data);
      });
  }

  _txtCargosChanged(data){
    if(data == null)
      return;

    if(totalAPagar > 0)
      setState(() {
        totalAPagar = totalAPagar + Utils.toDouble(data);
      });
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
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true, cargandoNotifier: _cargandoNotifier,)
          ],
          // subtitle: Padding(
          //   padding: EdgeInsets.only(left: isSmallOrMedium ? 50.0 : 0.0),
          //   child: MyContainerButton(
          //     borderColor: Colors.black,
          //     data: ["${widget.servidor.descripcion}", "${widget.servidor.descripcion}"], 
          //     onTap: (data){

          //     }
          //   ),
          // ),
        ), 
        sliver: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));


            // return SliverFillRemaining(child: Center(child: Text("hola")),);

            return SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: Wrap(
                    children: [
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
                          isDigitOnly: true,
                          onChanged: (data){
                            _setTotalesBanca(listaBanca);
                            _streamController.add(listaBanca);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                MyDivider(showOnlyOnSmall: true,),
                Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        small: 2,
                        leading: isSmallOrMedium ? Icon(Icons.money_off, color: Colors.black.withOpacity(0.7),) : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtDescuentos,
                        title: !isSmallOrMedium ? "Descuentos" : "",
                        hint: "Descuentos",
                        medium: 2,
                        xlarge: 1.6,
                        isDigitOnly: true,
                        onChanged: _txtDescuentosChanged,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        small: 2,
                        leading: isSmallOrMedium ? Icon(Icons.moving, color: Colors.black.withOpacity(0.7),) : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtCargos,
                        title: !isSmallOrMedium ? "Cargos" : "",
                        hint: "Cargos",
                        helperText: "El monto introducido se sumara al total",
                        medium: 2,
                        xlarge: 1.6,
                        isDigitOnly: true,
                        onChanged: _txtCargosChanged,
                      
                      ),
                    ),
                  ],
                ),
                MyDivider(showOnlyOnSmall: true,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyTextFormField(
                    small: 1,
                    leading: isSmallOrMedium ? Icon(Icons.description, color: Colors.black.withOpacity(0.7),) : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                    controller: _txtNota,
                    title: !isSmallOrMedium ? "Nota" : "",
                    hint: "Nota",
                    helperText: "Aqui puede dejar una nota o comentario",
                    medium: 1,
                    xlarge: 1.6,
                    // isDigitOnly: true,
                  
                  ),
                ),
                // MyDivider(showOnlyOnSmall: true,),
                
                
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