import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/pagodetalle.dart';
import 'package:loterias/core/services/pagosservice.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';

class PagosDetallesTabla {
  String descripcion;
  int diasUsados;
  double total;
  bool showDiasUsados;
  PagosDetallesTabla({@required this.descripcion, @required this.total, this.showDiasUsados = false, this.diasUsados});
}

class PagosVerScreen extends StatefulWidget {
  final int id;
  const PagosVerScreen({ Key key, @required this.id }) : super(key: key);

  @override
  _PagosVerScreenState createState() => _PagosVerScreenState();
}

class _PagosVerScreenState extends State<PagosVerScreen> {
  Future<Pago> _future;
  var _txtNota = TextEditingController();

  Future<Pago>_init() async {
    var parsed = await PagosService.getById(context: context, id: widget.id);

    return parsed["data"] != null ? Pago.fromMap(parsed["data"]) : null;
  }

  _share(){
    print("Hola desde _share");
  }

  _sendNotification(Pago data) async {
    await PagosService.reenviarNotificacion(context: context, data: data);
  }

  _edit(Pago data) async {
    var data2 = await Navigator.pushNamed(context, "/pagos/agregar", arguments: [data.servidor, data]);
    Navigator.pop(context, data2);
  }

  _pay(Pago data) async {
    var fechaProximoPago = Utils.getFechaProximoPago(data.servidor);
    var data2 = await PagosService.pagar(context: context, data: data, fechaProximoPago: fechaProximoPago.end);
    Pago dataToReturn;
    if(data2["data"] != null)
      dataToReturn = Pago.fromMap(data2["data"]);
    Navigator.pop(context, dataToReturn);
  }

  _headerScreen(){
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 20),
                      child: Container(
                        width: 60,
                        height: 60,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              widthFactor: 0.75,
                              heightFactor: 0.75,
                              child: Image(image: AssetImage('assets/images/loterias_dominicanas_sin_letras.png'), ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MyResizedContainer(
                      small: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Loterias dom.", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),),
                            Text("Jean Carlos Contreras", style: TextStyle(color: Utils.fromHex("#5f6368"), fontSize: 16),),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 18,),
                                ),
                                Text("829-426-6800  •  849-340-6800", style: TextStyle(color: Utils.fromHex("#5f6368"), fontSize: 12),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              );
  }

  Widget _clienteWidget(Pago data){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyDescripcon(title: "Facturado a:", fontSize: 14,),
          MySubtitle(title: "${data.servidor.cliente}", padding: EdgeInsets.only(bottom: 0), fontSize: 15,),
          MySubtitle(title: "${data.servidor.descripcion}", padding: EdgeInsets.only(bottom: 5), fontSize: 15,),
          Container(
            width: 100,
            height: 2,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  Widget _facturaWidget(Pago data){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyDescripcon(title: "Factura", fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700,),
          Row(
            children: [
              MyDescripcon(title: "Dia pago:", fontSize: 14,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MySubtitle(title: "${MyDate.dateRangeToNameOrString(DateTimeRange(start: data.fechaDiaPago, end: data.fechaDiaPago))}", padding: EdgeInsets.only(bottom: 0), fontSize: 14,),
              ),
            ],
          ),
          Row(
            children: [
              MyDescripcon(title: "Ultimo dia pago:", fontSize: 14,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MySubtitle(title: "${MyDate.dateRangeToNameOrString(DateTimeRange(start: data.fechaDiasGracia, end: data.fechaDiasGracia))}", padding: EdgeInsets.only(bottom: 0), fontSize: 14, color: Colors.pink,),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ultimoDiaPagoWidget(Pago data){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyDescripcon(title: "Ultimo dia de pago.", fontSize: 16,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MyDescripcon(title: "Cuando pase esta fecha el sistema se desactivará automaticamente y para reactivar deberá pagar 2,000 RD\$.",),
          ),
          MySubtitle(title: "${MyDate.dateRangeToNameOrString(DateTimeRange(start: data.fechaDiasGracia, end: data.fechaDiasGracia))}", padding: EdgeInsets.only(bottom: 5),),
        ],
      ),
    );
  }

  List<PagosDetallesTabla> _getDetalles(Pago data){
    List<PagosDetallesTabla> list = [];
    List<Pagodetalle> listaDetalleTipoBancaContratadas = data.detalles.where((element) => element.tipo.descripcion.toLowerCase() == "banca contratada").toList();
    List<Pagodetalle> listaDetalleTipoBancaUsada = data.detalles.where((element) => element.tipo.descripcion.toLowerCase() == "banca usada").toList();
    List<Pagodetalle> listaDetalleTipoDiasUsados = data.detalles.where((element) => element.tipo.descripcion.toLowerCase() == "dias usados").toList();
    
    if(listaDetalleTipoBancaContratadas.length > 0){
      list.add(PagosDetallesTabla(descripcion: "${listaDetalleTipoBancaContratadas.length} banca/s contratadas", total: listaDetalleTipoBancaContratadas.map((e) => e.total).toList().reduce((value, element) => value + element)));
    }
    if(listaDetalleTipoBancaUsada.length > 0){
      list.add(PagosDetallesTabla(descripcion: "${listaDetalleTipoBancaUsada.length} banca/s usadas", total: listaDetalleTipoBancaUsada.map((e) => e.total).toList().reduce((value, element) => value + element)));
    }
    print("PagosVerScreen _getDetalles diasUsuados: ${listaDetalleTipoBancaUsada.length}");
    if(listaDetalleTipoDiasUsados.length > 0){
    print("PagosVerScreen _getDetalles diasUsuados 2: ${listaDetalleTipoBancaUsada.length}");
      for (var detalle in listaDetalleTipoDiasUsados) {
        list.add(PagosDetallesTabla(descripcion: "${detalle.descripcionBanca}", total: detalle.total, diasUsados: detalle.diasUsados, showDiasUsados: true));
      }
    }

    return list;
  }

  _detallesWidget(Pago data){
    List<PagosDetallesTabla> detalles = _getDetalles(data);
    bool mostrarDiasUsados = detalles.indexWhere((e) => e.showDiasUsados == true) != -1;
    List columns = ["#", "Descripcion", "Total"];
    if(mostrarDiasUsados)
      columns =  ["Descripcion", "Dias", "Total"];

    

    return Column(
      children: [
        MySubtitle(title: "Detalles", padding: EdgeInsets.only(top: 40, bottom: 20),),
        MyTable(
          headerColor: Utils.colorPrimary,
          columns: columns, 
          isScrolled: false,
          rows: detalles.asMap().map((key, e){
            if(mostrarDiasUsados)
              // return MapEntry(key, [e, "${e.descripcion != null ? e.descripcion.substring(0, e.descripcion.length > 17 ? 17 : e.descripcion.length) : ''}", "${e.diasUsados}", "${Utils.toCurrency(e.total)}"]);
              return MapEntry(key, [e, "${e.descripcion}", "${e.diasUsados != null ? e.diasUsados : '-'}", "${Utils.toCurrency(e.total)}"]);

            return MapEntry(key, [e, "${key + 1}" ,"${e.descripcion}", "${Utils.toCurrency(e.total)}"]);
          }).values.toList()
        ),
      ],
    );
  }

  _totalWidget(Pago pago){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          
          Visibility(
            visible: pago.descuento > 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MySubtitle(title: "Descuentos: ", fontSize: 14, padding: EdgeInsets.all(0),),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: MyDescripcon(title: "${Utils.toCurrency(pago.descuento)}", fontSize: 14, fontWeight: FontWeight.w700,),
                  ),
                ],
              ),
          ),
          Visibility(
            visible: pago.cargo > 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MySubtitle(title: "Cargos: ", fontSize: 14, padding: EdgeInsets.all(0),),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: MyDescripcon(title: "${Utils.toCurrency(pago.cargo)}", fontSize: 14, fontWeight: FontWeight.w700,),
                  ),
                ],
              ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MySubtitle(title: "Total:", fontSize: 18,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: MyDescripcon(title: "${Utils.toCurrency((pago.total - pago.descuento) + pago.cargo)}", fontSize: 18, color: Colors.green[700], fontWeight: FontWeight.w700,),
                ),
              ],
            ),
        ],
      ),
    );
  }

  _notaWidget(Pago data){
    _txtNota.text = "${data.nota != null ? data.nota : ''}";
    return Visibility(
      visible: data.nota != null ? data.nota.isNotEmpty : false,
      child: MyTextFormField(
        controller: _txtNota,
        title: "Nota",
        type: MyType.border,
        maxLines: 2,
      ),
    );
  }


  Future<bool> _esProgramador() async {
    return (await (await DB.create()).getValue("tipoUsuario")) == "Programador";
  }

  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _txtNota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: '',
          actions: [
            MySliverButton(
              title: null, 
              iconWhenSmallScreen: IconButton(icon: Icon(Icons.share_outlined, color: Colors.black,), onPressed: _share,),
              // onTap: _share
            ),
            // MySliverButton(
            //   title: null, 
            //   iconWhenSmallScreen: IconButton(icon: Icon(Icons.notifications_outlined, color: Colors.black,), onPressed: _sendNotification,),
            //   // iconWhenSmallScreen: Icons.notifications_active_outlined,
            //   onTap: _sendNotification
            // ),
            // MySliverButton(
            //   title: null, 
            //   iconWhenSmallScreen: IconButton(icon: Icon(Icons.payment, color: Colors.black,), onPressed: _sendNotification,),
            //   // iconWhenSmallScreen: Icons.notifications_active_outlined,
            //   onTap: _sendNotification
            // ),
            MySliverButton(
              title: null, 
              iconWhenSmallScreen: FutureBuilder<Pago>(
                future: _future,
                builder: (context, snapshot) {
                  return FutureBuilder<bool>(
                    future: _esProgramador(),
                    builder: (context, snapshot2) {
                      if(snapshot.connectionState != ConnectionState.done || snapshot2.connectionState != ConnectionState.done)
                        return IconButton(icon: Icon(Icons.notifications_outlined, color: Colors.black38,), onPressed: null);

                      if(!snapshot2.data)
                        return IconButton(icon: Icon(Icons.notifications_outlined, color: Colors.black38,), onPressed: null);

                      return Visibility(visible: snapshot.connectionState == ConnectionState.done ? snapshot2.connectionState == ConnectionState.done ? snapshot2.data : false : false, child: IconButton(
                        icon: Icon(Icons.notifications_outlined, color: Colors.black,), 
                        onPressed: (){_sendNotification(snapshot.data);},
                      ));
                    }
                  );
                }
              ),
              // iconWhenSmallScreen: Icons.notifications_active_outlined,
              // onTap: _edit
            ),
            MySliverButton(
              title: null, 
              iconWhenSmallScreen: FutureBuilder<Pago>(
                future: _future,
                builder: (context, snapshot) {
                  return FutureBuilder<bool>(
                    future: _esProgramador(),
                    builder: (context, snapshot2) {
                      if(snapshot.connectionState != ConnectionState.done || snapshot2.connectionState != ConnectionState.done)
                        return IconButton(icon: Icon(Icons.payment, color: Colors.black38,), onPressed: null);

                      if(!snapshot2.data)
                        return IconButton(icon: Icon(Icons.payment, color: Colors.black38,), onPressed: null);

                      return Visibility(visible: snapshot.connectionState == ConnectionState.done ? snapshot2.connectionState == ConnectionState.done ? snapshot2.data : false : false, child: IconButton(
                        icon: Icon(Icons.payment, color: Colors.black,), 
                        onPressed: (){_pay(snapshot.data);},
                      ));
                    }
                  );
                }
              ),
              // iconWhenSmallScreen: Icons.notifications_active_outlined,
              // onTap: _edit
            ),
            MySliverButton(
              title: null, 
              iconWhenSmallScreen: FutureBuilder<Pago>(
                future: _future,
                builder: (context, snapshot) {
                  return FutureBuilder<bool>(
                    future: _esProgramador(),
                    builder: (context, snapshot2) {
                      return Visibility(visible: snapshot.connectionState == ConnectionState.done ? snapshot2.connectionState == ConnectionState.done ? snapshot2.data : false : false, child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.black,), 
                        onPressed: (){_edit(snapshot.data);},
                      ));
                    }
                  );
                }
              ),
              // iconWhenSmallScreen: Icons.notifications_active_outlined,
              // onTap: _edit
            ),
          ],
        ), 
        sliver: FutureBuilder<Pago>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            if(snapshot.data == null)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay facturas a mostrar", icon: Icons.description, titleButton: "No hay facturas a mostrar",)),);


            return SliverList(delegate: SliverChildListDelegate([
              // ListTile(
              //   leading: CircleAvatar(
              //     radius: 30,
                  
              //     backgroundImage: AssetImage('assets/images/loterias_dominicanas_sin_letras.png'),
              //   ),
              //   title: Text("Loterias dom."),
              //   subtitle: Text("Jean Carlos Contreras"),
              // ),
              _headerScreen(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // alignment: WrapAlignment.spaceBetween,
                      children: [
                        _clienteWidget(snapshot.data),
                        _facturaWidget(snapshot.data)
                      ],
                    ),
                    // _ultimoDiaPagoWidget(snapshot.data),
                    _detallesWidget(snapshot.data),
                    _notaWidget(snapshot.data),
                    _totalWidget(snapshot.data),
                  ],
                ),
              )
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child: Text("Sistema loteria | Factura ${MyDate.dateRangeToNameOrString(DateTimeRange(start: snapshot.data.fechaDiaPago, end: snapshot.data.fechaDiaPago))}", style: TextStyle(fontSize: 25),),
              // )
              // MySubtitle(title: "Sistema loteria | Factura ${MyDate.dateRangeToNameOrString(DateTimeRange(start: snapshot.data.fechaDiaPago, end: snapshot.data.fechaDiaPago))}"),
            ]));
          }
        )
      )
    );
  }
}