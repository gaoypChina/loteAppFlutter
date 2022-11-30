import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/monitoreo.dart';
import 'package:loterias/core/classes/ticketimagev2.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/core/services/ticketservice.dart';

class DialogVerImprimirCompartirYCancelarTicket extends StatefulWidget {
  final Venta venta;
  const DialogVerImprimirCompartirYCancelarTicket({Key key, this.venta}) : super(key: key);

  @override
  State<DialogVerImprimirCompartirYCancelarTicket> createState() => _DialogVerImprimirCompartirYCancelarTicketState();
}

class _DialogVerImprimirCompartirYCancelarTicketState extends State<DialogVerImprimirCompartirYCancelarTicket> {
  bool _cargandoVerTicket = false;
  bool _cargandoImprimirTicket = false;
  bool _cargandoCompartirTicket = false;
  bool _cargandoCancelarTicket = false;
  bool isSmallOrMedium = true;

  @override
  Widget build(BuildContext context) {
    isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return _largeOrSmallScreen();
  }

  Widget _largeOrSmallScreen(){
    return _isSmall() ? _smallScreen() : _largeScreen();
  }

  Widget _smallScreen(){
    return _screen();
  }

  Widget _largeScreen(){
    return AlertDialog(
      shape: Utils.alertDialogRoundedShape(),
      title: Text("${Utils.toSecuencia(null, widget.venta.idTicket, false)}"),
      content: SingleChildScrollView(child: _screen()),
      actions: [
        TextButton(onPressed: _irAtras, child: Text("Ok", style: TextStyle(color: Colors.black),))
      ],
    );
  }

  Widget _screen(){
    return StatefulBuilder(
          builder: (context, setState) {

            return Container(
                  height: _isSmall() ? 290 : 215,
                  child: Column(
                    children: [
                      _barraDeColorGrisWidget(),
                      Expanded(
                        child: _opcionesWidget()
                      ),
                    ],
                  ),
                );
          }
        );
        
  }

  _barraDeColorGrisWidget(){
    return Visibility(
      visible: _isSmall(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
      ),
    );
  }

  _opcionesWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          _numeracionTicketCentralidaWidget(),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text("Ver ticket", style: TextStyle(color: Colors.black)),
            trailing: SizedBox(
              width: 28,
              height: 28,
              child: Visibility(
                visible: _cargandoVerTicket,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
            onTap: () => _verTicket(),
          ),
          ListTile(
            leading: Icon(Icons.print),
            title: Text("Reimprimir", style: TextStyle(color: Colors.black)),
            trailing: SizedBox(
              width: 28,
              height: 28,
              child: Visibility(
                visible: _cargandoImprimirTicket,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
            onTap: _reImprimirTicket,
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Compartir", style: TextStyle(color: Colors.black)),
            trailing: SizedBox(
              width: 28,
              height: 28,
              child: Visibility(
                visible: _cargandoCompartirTicket,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
            onTap: _compartirTicket,
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Eliminar", style: TextStyle(color: Colors.black)),
            trailing: SizedBox(
              width: 28,
              height: 28,
              child: Visibility(
                visible: _cargandoCancelarTicket,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
            onTap: _cancelarTicket,
          ),
        ],
      ),
    );
                       
  }

  _numeracionTicketCentralidaWidget(){
    return Visibility(
      visible: _isSmall(),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
        child: Center(child: Text("${Utils.toSecuencia(null, widget.venta.idTicket, false)}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))),
      ),
    );
  }

  _verTicket() async {
    try{
      setState(() => _cargandoVerTicket = true);
      var datos = await TicketService.buscarTicket(context: context, codigoBarra: widget.venta.codigoBarra);
      setState(() => _cargandoVerTicket = false);
      _irAtras();
      Monitoreo.showDialogVerTicket(context: context, mapVenta: datos["venta"], isSmallOrMedium: _isSmall());
    } on Exception catch(e){
      setState(() => _cargandoVerTicket = false);
    }
  }

  _isSmall() => isSmallOrMedium;

  _reImprimirTicket() async {
    try{
      if(await Utils.exiseImpresora() == false){
        _irAtras();
        Utils.showAlertDialog(context: context, title: "Alerta", content: "Debe registrar una impresora");
        return;
      }

      setState(() => _cargandoImprimirTicket = true);
      var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: widget.venta.codigoBarra);
      print("Monitoreo _showOpciones: $datos");
      await BluetoothChannel.printTicket(datos["venta"], BluetoothChannel.TYPE_COPIA);
      setState(() => _cargandoImprimirTicket = false);
      _irAtras();
    } on Exception catch(e){
      setState(() => _cargandoImprimirTicket = false);
    }
  }

  _compartirTicket() async {
    try{
      _mostrarUOcultarCirculoCargandoDeCompartirTicket();
      var parsed = await TicketService.ticketV2(context: context, idVenta: widget.venta.id, compartirTicket: true);
      _compartirImagenOEnlace(parsed);
      _mostrarUOcultarCirculoCargandoDeCompartirTicket(mostrar: false);
      _irAtras();
    } catch(e){
      _mostrarUOcultarCirculoCargandoDeCompartirTicket(mostrar: false);
    }
  }

  _mostrarUOcultarCirculoCargandoDeCompartirTicket({bool mostrar = true}){
    setState(() => _cargandoCompartirTicket = mostrar);
  }

  _compartirImagenOEnlace(var parsed){
    if(TicketService.esCompatirUrl(parsed))
      _compartirEnlaceDelTicket(parsed);
    else
      _compartirImagenDelTicket(parsed);
  }

  _compartirEnlaceDelTicket(Map<String, dynamic> map){
    String rutaUrlDelTicket = map["rutaUrlDelTicket"];
    String enlace = TicketService.agregarUrlActualALaRutaDelTicket(rutaUrlDelTicket);
    ShareChannel.shareText(textToShare: enlace, sms_o_whatsapp: true);
  }

  _compartirImagenDelTicket(var parsed) async {
    Sale sale = parsed["sale"] != null ? Sale.fromMap(parsed["sale"]) : null;
    if(sale == null)
      return;

    List<Salesdetails> salesdetails = Salesdetails.fromMapList(parsed["salesdetails"]);
    Uint8List image = await TicketImageV2.create(sale, salesdetails);
    ShareChannel.shareHtmlImageToSmsWhatsapp(base64image: image, codigoQr: sale.ticket.codigoBarra, sms_o_whatsapp: true);
  }

  _cancelarTicket() async {
    bool usuarioDeseaCancelar = await TicketService.showDialogAceptaCancelar(context: context, ticket: Utils.toSecuencia("", widget.venta.idTicket, false));
    if(!usuarioDeseaCancelar){
      _irAtras();
      return;
    }
        
    bool usuarioDeseaImprimir = await TicketService.showDialogDeseaImprimir(context: context);

    try{
      await _validarSiExisteImpresoraYSiElBluetoothEstaEncendidoSiUsuarioDeseaImprimir(usuarioDeseaImprimir);
      _mostrarUOcultarCirculoCargandoDeCancelarTicket();
      var datos = await TicketService.cancelar(codigoBarra: widget.venta.codigoBarra);
      _imprimirTicketCanceladoSiUsuarioDeseaImprimir(datos["ticket"], usuarioDeseaImprimir);
      _mostrarUOcultarCirculoCargandoDeCancelarTicket(mostrar: false);
      await _irAtras(seHaCanceladoElTicket: true);
    } catch(e){
      _mostrarUOcultarCirculoCargandoDeCancelarTicket(mostrar: false);
      Utils.showAlertDialog(context: context, content: e.toString(), title: "Error");
    }
  }

  Future<void> _validarSiExisteImpresoraYSiElBluetoothEstaEncendidoSiUsuarioDeseaImprimir(bool usuarioDeseaImprimir) async {
    if(!usuarioDeseaImprimir)
      return;
    if(await Utils.exiseImpresora() == false)
      throw Exception("Debe registrar una impresora");
    if(!(await BluetoothChannel.turnOn()))
      throw Exception("Debe encender el Bluetooth de su dispositivo");
  }

  _mostrarUOcultarCirculoCargandoDeCancelarTicket({bool mostrar = true}){
    setState(() => _cargandoCancelarTicket = mostrar);
  }

  Future<void> _imprimirTicketCanceladoSiUsuarioDeseaImprimir(ticket, bool usuarioDeseaImprimir) async {
    if(usuarioDeseaImprimir)
      await BluetoothChannel.printTicket(ticket, BluetoothChannel.TYPE_CANCELADO);
  }

  _irAtras({bool seHaCanceladoElTicket = false}){
    Future.delayed(Duration.zero, (){
      Navigator.pop(context, seHaCanceladoElTicket);
    });
  }
}