import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/parametros_rutas/parametros_banca.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/tipos/tipoVentanaBanca.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/extensions/listextensions.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/comision.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/frecuencia.dart';
import 'package:loterias/core/models/gastos.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/pagoscombinacion.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/ui/views/bancas/bancasmultiplesearch.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myhorizontalmultiselect.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/mytogglebuttons.dart';
import 'package:loterias/ui/views/bancas/gastosscreen.dart';
import 'package:rxdart/rxdart.dart';


class BancasAddScreen extends StatefulWidget {
  final ParametrosBanca parametros;
  BancasAddScreen({Key key, this.parametros}) : super(key: key);
  @override
  _BancasAddScreenState createState() => _BancasAddScreenState();
}

class _BancasAddScreenState extends State<BancasAddScreen> with TickerProviderStateMixin{
  var _cargandoNotify = ValueNotifier<bool>(false);
  StreamController<List<Gasto>> _streamControllerGastos;
  var _formKey = GlobalKey<FormState>();
  var _formKeyGasto = GlobalKey<FormState>();
  Future _future;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  var _txtDueno = TextEditingController();
  var _txtLocalidad = TextEditingController();
  var _txtNombreUsuarioConSecuencias = TextEditingController();
  var _txtNombreBancaConSecuencias = TextEditingController();

  var _txtLimiteVentasPorDia = TextEditingController();
  var _txtBalance = TextEditingController();
  var _txtDescontar = TextEditingController();
  var _txtDeCada = TextEditingController();
  var _txtMinutosParaCancelarTicket = TextEditingController();
  var _txtPiePagina1 = TextEditingController();
  var _txtPiePagina2 = TextEditingController();
  var _txtPiePagina3 = TextEditingController();
  var _txtPiePagina4 = TextEditingController();

  var _txtDirecto = TextEditingController();
  var _txtPale = TextEditingController();
  var _txtTripleta = TextEditingController();
  var _txtSuperpale = TextEditingController();
  var _txtPick3Box = TextEditingController();
  var _txtPick3Straight = TextEditingController();
  var _txtPick4Straight = TextEditingController();
  var _txtPick4Box = TextEditingController();

  var _txtPrimera = TextEditingController();
  var _txtSegunda = TextEditingController();
  var _txtTercera = TextEditingController();

  var _txtPrimeraSegunda = TextEditingController();
  var _txtPrimeraTercera = TextEditingController();
  var _txtSegundaTercera = TextEditingController();

  var _txtTresNumeros = TextEditingController();
  var _txtDosNumeros = TextEditingController();

  var _txtPrimerPago = TextEditingController();

  var _txtPick3TodosEnSecuencia = TextEditingController();
  var _txtPick33Way = TextEditingController();
  var _txtPick36Way = TextEditingController();

  var _txtPick4TodosEnSecuencia = TextEditingController();
  var _txtPick44Way = TextEditingController();
  var _txtPick46Way = TextEditingController();
  var _txtPick412Way = TextEditingController();
  var _txtPick424Way = TextEditingController();

  var _txtDescripcionGasto = TextEditingController();
  var _txtMontoGasto = TextEditingController();


  bool _status = true;
  bool _imprimirCodigoQr = true;
  Banca _data;
  List<Loteria> _loterias;
  List<Loteria> _loteriasComisiones;
  List<Loteria> _loteriasPagosCombinaciones;
  List<Gasto> _gastos;
  List<Comision> _comisiones;
  Comision _comisionPorDefectoParaLlenarCamposComisionAlAgregarUnaLoteriaAEstaBanca;
  List<Pagoscombinacion> _pagosCombinaciones;
  Pagoscombinacion _pagoCombinacionPorDefectoParaLlenarCamposPagoCombinacionAlAgregarUnaLoteriaAEstaBanca;
  List<Loteria> listaLoteria;
  List<Usuario> listaUsuario;
  List<Moneda> listaMoneda;
  List<Grupo> listaGrupo;
  List<Frecuencia> listaFrecuencia;
  List<Dia> listaDia;
  List<Banca> listaBanca;
  List<Banca> _bancas = [];
  List<Dia> dias;
  TabController _tabController;
  Usuario _usuario;
  Moneda _moneda;
  Grupo _grupo;
  Loteria selectedLoteriaComision;
  Loteria selectedLoteriaPagosCombinacion;
  bool _agregarYQuitarLoterias = false;

  bool _esTipoVentanaActualizarMasivamente(){
    return widget.parametros.tipoVentana == TipoVentanaBanca.actualizarMasivamente;
  }

  bool _esTipoVentanaCrearMasivamente(){
    return widget.parametros.tipoVentana == TipoVentanaBanca.crearMasivamente;
  }

  bool _esTipoVentanaNormal(){
    return widget.parametros.tipoVentana == TipoVentanaBanca.normal;
  }

  void _llenarListas(var parsed){
    listaLoteria = Loteria.fromMapList(parsed["loterias"]);
    listaUsuario = Usuario.fromMapList(parsed["usuarios"]);
    listaMoneda = Moneda.fromMapList(parsed["monedas"]);
    listaGrupo = Grupo.fromMapList(parsed["grupos"]);
    listaFrecuencia = Frecuencia.fromMapList(parsed["frecuencias"]);
    listaDia = Dia.fromMapList(parsed["dias"]);
    listaGrupo.insert(0, Grupo(id: 0, descripcion: "Ninguno"));
    listaBanca = Banca.fromMapList(parsed["bancas"]);
    print("BancasAddScreen _llenarListas: ${listaBanca.length}");
  }

  _llenarVariableBancaSiEstaNula(){
    if(_data == null)
      _data = Banca();
  }

  _init() async {
    var parsed = await BancaService.index(context: context, retornarLoterias: true, retornarUsuarios: true, retornarDias: true, retornarGrupos: true, retornarMonedas: true, retornarFrecuencias: true, retornarBancas: _esTipoVentanaActualizarMasivamente(), idBanca: widget.parametros.idBanca);
    _llenarListas(parsed);
    _llenarCampos(parsed);
    _setsLoterias();
    _setsComisiones();
    _setsPagosCombinaciones(); 
    _llenarVariableBancaSiEstaNula(); 
  }

  _llenarCampos(parsed){
    if(_esTipoVentanaActualizarMasivamente())
      return;

    _data = parsed["data"] != null ? Banca.fromMap(parsed["data"]) : null;
    // print("BancasAddScreen _llenarCampos: ${parsed['data']['minutosCancelarTicket']} - ${_data.minutosCancelarTicket}");
    _txtDescripcion.text = (_data != null) ? _data.descripcion : '';
    _txtCodigo.text = (_data != null) ? _data.codigo : '';
    _txtDueno.text = (_data != null) ? _data.dueno : '';
    _txtLocalidad.text = (_data != null) ? _data.localidad : '';
    _status = (_data != null) ? _data.status == 1 ? true : false : true;
    _usuario = (_data != null) ? listaUsuario.firstWhere((element) => element.id == _data.usuario.id, orElse: () => null) : null;
    _moneda = (_data != null) ? listaMoneda.firstWhere((element) => element.id == _data.monedaObject.id) : null;
    _grupo = _data != null ? _data.grupo != null ? listaGrupo.firstWhere((element) => element.id == _data.grupo.id, orElse: () => null) : null : null;

    _txtLimiteVentasPorDia.text = (_data != null) ? _data.limiteVenta != null ? _data.limiteVenta.toString() : '' : '';
    _txtBalance.text = (_data != null) ? _data.balanceDesactivacion != null ? _data.balanceDesactivacion.toString() : '' : '';
    _txtDescontar.text = (_data != null) ? _data.descontar != null ? _data.descontar.toString() : '' : '';
    _txtDeCada.text = (_data != null) ? _data.deCada != null ? _data.deCada.toString() : '' : '';
    _txtMinutosParaCancelarTicket.text = (_data != null) ? _data.minutosCancelarTicket != null ? _data.minutosCancelarTicket.toString() : '' : '';
    _imprimirCodigoQr = (_data != null) ? _data.imprimirCodigoQr == 1 ? true : false : true;
    _txtPiePagina1.text = (_data != null) ? _data.piepagina1 : '';
    _txtPiePagina2.text = (_data != null) ? _data.piepagina2 : '';
    _txtPiePagina3.text = (_data != null) ? _data.piepagina3 : '';
    _txtPiePagina4.text = (_data != null) ? _data.piepagina4 : '';

    // _setsLoterias();
    // _setsComisiones();
    // _setsPagosCombinaciones();  
    _gastos = _data != null ? _data.gastos != null ? _data.gastos : [] : [];
    listaDia = _data != null ? _data.dias != null ? _data.dias : listaDia : listaDia;
    _streamControllerGastos.add(_gastos);

  }

  // _setsSorteos(){
  //   _sorteos = [];
  //   if(_data != null){
  //     if(_data.sorteos != null){
  //       for (var sorteo in _data.sorteos) {
  //         var s = listaSorteo.firstWhere((element) => element.descripcion == sorteo.descripcion, orElse: () => null);
  //         if(s != null)
  //           _sorteos.add(s);
  //         print("LoteriasAddScreen _init sorteos: ${s != null} : ${s != null ? s.descripcion : ''}");
  //       }
  //     }
  //   }
  // }

  _llenarComisionPorDefectoParaLlenarCamposComisionAleAgregarUnaLoteriaAEstaBanca(){
    if(_comisiones == null)
      return;
    if(_comisiones.length == 0)
      return;
    _comisionPorDefectoParaLlenarCamposComisionAlAgregarUnaLoteriaAEstaBanca = _comisiones.firstWhere((element) => element.directo > 0, orElse: () => null);
  }

  _setsComisiones(){
    _setsLoteriasComision();
    _comisiones = [];
    if(_data == null){
      for (var item in listaLoteria) {
        _comisiones.add(Comision(idLoteria: item.id));
      } 
      return;
    }else{
      _comisiones = _data.comisiones;
      if(_loterias.length > 0)
        _removerLoteriasQueNoEstanDeUnaListaDada(_comisiones, "idLoteria", _loterias);

      _llenarComisionPorDefectoParaLlenarCamposComisionAleAgregarUnaLoteriaAEstaBanca();
    }
  }

  _setsLoteriasComision(){
      if(_loterias == null){
        _loteriasComisiones = [];
        return;
      }
      if(_loterias.length == 0){
         _loteriasComisiones = [];
        return;
      }

      _loteriasComisiones = [];
      _loteriasComisiones.add(Loteria(id: 0, descripcion: "Copiar a todas"));
      for (var item in _loterias) {
        _loteriasComisiones.add(item);
      }
      selectedLoteriaComision = _loteriasComisiones[0];
      // _loteriasComisiones.insert(0, Loteria(id: 0, descripcion: "Copiar a todas"));
    }

  _setsLoteriasPagosCombinacion(){
      if(_loterias == null){
        _loteriasPagosCombinaciones = [];
        return;
      }
      if(_loterias.length == 0){
        _loteriasPagosCombinaciones = [];
        return;
      }

      _loteriasPagosCombinaciones = [];
      _loteriasPagosCombinaciones.add(Loteria(id: 0, descripcion: "Copiar a todas"));
      for (var item in _loterias) {
        _loteriasPagosCombinaciones.add(item);
      }
      selectedLoteriaPagosCombinacion = _loteriasPagosCombinaciones[0];
      // _loteriasComisiones.insert(0, Loteria(id: 0, descripcion: "Copiar a todas"));
    }

  _llenarPagoCombinacionPorDefectoParaLlenarCamposPagoCombinacionAlAgregarUnaLoteriaAEstaBanca(){
    if(_comisiones == null)
      return;
    if(_comisiones.length == 0)
      return;
    _pagoCombinacionPorDefectoParaLlenarCamposPagoCombinacionAlAgregarUnaLoteriaAEstaBanca = _pagosCombinaciones.firstWhere((element) => element.primera > 0, orElse: () => null);
  }

  _setsPagosCombinaciones(){
    _setsLoteriasPagosCombinacion();
    _pagosCombinaciones = [];
    if(_data == null){
      for (var item in listaLoteria) {
        _pagosCombinaciones.add(Pagoscombinacion(idLoteria: item.id));
      } 
      return;
    }else{
      _pagosCombinaciones = _data.pagosCombinaciones;
      if(_loterias.length > 0)
        _removerLoteriasQueNoEstanDeUnaListaDada(_pagosCombinaciones, "idLoteria", _loterias);

      _llenarPagoCombinacionPorDefectoParaLlenarCamposPagoCombinacionAlAgregarUnaLoteriaAEstaBanca();
    }
  }

  _setsLoterias(){
    _loterias = [];
    if(_data == null){
      _loterias = List.from(listaLoteria);
      return;
    }

    if(_data.loterias == null){
      _loterias = List.from(listaLoteria);
      return;
    }

    if(_data.loterias.length == 0){
      _loterias = List.from(listaLoteria);
      return;
    }

    List<Loteria> loterias = [];
    for (var loteria in _data.loterias) {
      var l = listaLoteria.firstWhere((element) => element.id == loteria.id, orElse: () => null);
      if(l != null)
        _loterias.add(l);
    }
  }

  _pagosCombinacionesFieldsAreEmpty(){
    for (var pago in _pagosCombinaciones) {
      if(_existeSorteoPagosCombinacion("directo", pago.idLoteria)){
        if((pago.primera > 0 && pago.segunda > 0 && pago.tercera > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("pale", pago.idLoteria)){
        if((pago.primeraSegunda > 0 && pago.primeraTercera > 0 && pago.segundaTercera > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("tripleta", pago.idLoteria)){
        if((pago.tresNumeros > 0 && pago.dosNumeros > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("super pale", pago.idLoteria)){
        if((pago.primerPago > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("pick 3 box", pago.idLoteria)){
        if((pago.pick33Way > 0 && pago.pick36Way > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("pick 3 straight", pago.idLoteria)){
        if((pago.pick3TodosEnSecuencia > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("pick 4 box", pago.idLoteria)){
        if((pago.pick44Way > 0 && pago.pick46Way > 0 && pago.pick412Way > 0 && pago.pick424Way > 0) == false)
          return true;
      }
      if(_existeSorteoPagosCombinacion("pick 4 straight", pago.idLoteria)){
        if((pago.pick4TodosEnSecuencia > 0) == false)
          return true;
      }
    }

    return false;
  }

  _actualizarMasivamente() async {
    if(_cargandoNotify.value == true)
      return;

    if(_bancas.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay bancas seleccionadas");
      return;
    }

    try{

      _data.descripcion = _txtDescripcion.text;
      _data.codigo = _txtCodigo.text;
      _data.dueno = _txtDueno.text;
      _data.localidad = _txtLocalidad.text;
      _data.status = _status ? 1 : 0;
      _data.usuario = _usuario;
      _data.monedaObject = _moneda;
      _data.grupo = _grupo;

      _data.limiteVenta = Utils.toDouble(_txtLimiteVentasPorDia.text);
      _data.balanceDesactivacion = Utils.toDouble(_txtBalance.text, returnNullIfNotDouble: true);
      _data.descontar = Utils.toDouble(_txtDescontar.text);
      _data.deCada = Utils.toDouble(_txtDeCada.text);
      _data.minutosCancelarTicket = Utils.toInt(_txtMinutosParaCancelarTicket.text);
      _data.imprimirCodigoQr = _imprimirCodigoQr ? 1 : 0;
      _data.piepagina1 = _txtPiePagina1.text;
      _data.piepagina2 = _txtPiePagina2.text;
      _data.piepagina3 = _txtPiePagina3.text;
      _data.piepagina4 = _txtPiePagina4.text;

      _data.dias = listaDia;
      _data.comisiones = _comisiones;
      _data.pagosCombinaciones = _pagosCombinaciones;
      _data.loterias = _loterias;
      _data.gastos = _gastos;

      _cargandoNotify.value = true;
      var parsed = await BancaService.actualizarMasivamente(context: context, data: _data, bancas: _bancas, agregarYQuitarLoterias: _agregarYQuitarLoterias);
      print("_showDialogGuardar parsed: $parsed");
      
      _cargandoNotify.value = false;
      _back(parsed);
    } on dynamic catch (e) {
      print("_showDialogGuardar _erroor: $e");
      _cargandoNotify.value = false;
    }
  }

  _guardar() async {
    if(_esTipoVentanaActualizarMasivamente()){
      _actualizarMasivamente();
      return;
    }

    if(_cargandoNotify.value == true)
      return;
      
      try {
        if(!_formKey.currentState.validate())
          return;

        if(_usuario == null && _esTipoVentanaNormal()){
          Utils.showAlertDialog(title: "Error", content: "Debe seleccionar un usuario", context: context);
          return;
        }

        if(_moneda == null){
          Utils.showAlertDialog(title: "Error", content: "Debe seleccionar una moneda", context: context);
          return;
        }

        if(_txtLimiteVentasPorDia.text.isEmpty || _txtMinutosParaCancelarTicket.text.isEmpty){
          if(_tabController.index != 1)
            setState(() {
              _tabController.index = 1;

              //I use a future.delayed with 0.5 seconds to wait until the tabbarview change and load the tab and after that time I validate the form again
              Future.delayed(Duration(milliseconds: 500), ()  {
                _formKey.currentState.validate();
                print('Large latte');

              });
            });
          return;
        }

        if(_pagosCombinacionesFieldsAreEmpty()){
          Utils.showAlertDialog(title: "Error", content: "Hay campos vacios en la venta premios", context: context);
          return;
        }

        _data.descripcion = _txtDescripcion.text;
        _data.codigo = _txtCodigo.text;
        _data.dueno = _txtDueno.text;
        _data.localidad = _txtLocalidad.text;
        _data.status = _status ? 1 : 0;
        _data.usuario = _usuario;
        _data.monedaObject = _moneda;
        _data.grupo = _grupo;


        _data.limiteVenta = Utils.toDouble(_txtLimiteVentasPorDia.text);
        _data.balanceDesactivacion = Utils.toDouble(_txtBalance.text, returnNullIfNotDouble: true);
        _data.descontar = Utils.toDouble(_txtDescontar.text);
        _data.deCada = Utils.toDouble(_txtDeCada.text);
        _data.minutosCancelarTicket = Utils.toInt(_txtMinutosParaCancelarTicket.text);
        _data.imprimirCodigoQr = _imprimirCodigoQr ? 1 : 0;
        _data.piepagina1 = _txtPiePagina1.text;
        _data.piepagina2 = _txtPiePagina2.text;
        _data.piepagina3 = _txtPiePagina3.text;
        _data.piepagina4 = _txtPiePagina4.text;

        _data.dias = listaDia;
        _data.comisiones = _comisiones;
        _data.pagosCombinaciones = _pagosCombinaciones;
        _data.loterias = _loterias;
        _data.gastos = _gastos;

        _cargandoNotify.value = true;
        var parsed = 
        _esTipoVentanaNormal()
          ? await BancaService.guardar(context: context, data: _data)
          : await BancaService.crearMasivamente(context: context, nombreBancaConSecuenciasSeparadasPorGuion: _txtNombreBancaConSecuencias.text, nombreUsuarioConSecuenciasSeparadasPorGuion: _txtNombreUsuarioConSecuencias.text, data: _data);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        _back(parsed);
      } on dynamic catch (e) {
        print("_showDialogGuardar _erroor: $e");
        _cargandoNotify.value = false;
      }
    }

    _back(Map<String, dynamic> parsed){
      Banca data;
      if(parsed["data"] != null)
        data = Banca.fromMap(parsed["data"]);

      Navigator.pop(context, data);
    }

    _statusScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Activo", value: _status, onChanged: _statusChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(title: "Estado", hint: "${_status ? 'Activa' : 'Desactivada'}", isSideTitle: true, xlarge: 1.35, elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _statusChanged,),
      );
    }

    _qrScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Mostrar codigo qr", value: _imprimirCodigoQr, onChanged: _qrChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(color: Colors.green[100], textColor: Colors.green, title: "Mostrar codigo QR", hint: "${_imprimirCodigoQr ? 'Si' : 'No'}", isSideTitle: true, xlarge: 1.35, elements: [[true, "Si"], [false, "No"]], onTap: _qrChanged,),
      );
    }

    _statusChanged(data){
      setState(() => _status = data);
    }

    _qrChanged(data){
      print("BancasAddScreen _qrChanged: $data");
      setState(() => _imprimirCodigoQr = data);
    }

    // _sorteosScreen(bool isSmallOrMedium){
    //   if(isSmallOrMedium)
    //     return ListTile(
    //       leading: Icon(Icons.ballot),
    //       title: Text(_sorteos.length > 0 ? _sorteos.map((e) => e.descripcion).join(", ") : "Agregar sorteos"),
    //       onTap: () async {
    //         var sorteosRetornados = await showDialog(
    //           context: context, 
    //           builder: (context){
    //             return MyMultiselect(
    //               title: "Agregar sorteos",
    //               items: listaSorteo.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
    //               initialSelectedItems: _sorteos.length == 0 ? [] : _sorteos.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
    //             );
    //           }
    //         );

    //         if(sorteosRetornados != null)
    //           setState(() => _sorteos = List.from(sorteosRetornados));
    //       },
    //     );

    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       MySubtitle(title: "Sorteos", padding: EdgeInsets.only(top: 15, bottom: 4),),
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 15.0),
    //         child: MyDescripcon(title: "Son los sorteos que se podran jugar en esta loteria.", fontSize: 14,),
    //       ),
    //       MyToggleButtons(
    //         items: listaSorteo.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
    //         selectedItems: _sorteos != null ? _sorteos.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList() : [],
    //         onTap: (value){
    //           int index = _sorteos.indexWhere((element) => element == value);
    //           if(index != -1)
    //             setState(() => _sorteos.removeAt(index));
    //           else
    //             setState(() => _sorteos.add(value));
    //         },
    //       )
    //       // ToggleButtons(
    //       //           borderColor: Colors.black,
                    
    //       //           // fillColor: Colors.grey,
    //       //           // borderWidth: 2,
    //       //           // selectedBorderColor: Colors.black,
    //       //           // selectedColor: Colors.white,
    //       //           borderWidth: 0.5,
    //       //           // selectedColor: Colors.pink,
    //       //           // selectedBorderColor: Colors.black,
    //       //           fillColor: Colors.grey[300],
    //       //           borderRadius: BorderRadius.circular(10),
    //       //           constraints: BoxConstraints(minHeight: 34, minWidth: 48),
    //       //           children: listaSorteo.map((e) => Padding(
    //       //             padding: const EdgeInsets.symmetric(horizontal: 18.0),
    //       //             child: Text(e.descripcion, style: TextStyle(fontWeight: FontWeight.w600),),
    //       //           )).toList(),
    //       //           // children: [Text("Hola"), Text("Hola")],
    //       //           onPressed: (int index) {
    //       //               setState(() {
    //       //               // for (int i = 0; i < isSelected.length; i++) {
    //       //               //     isSelected[i] = i == index;
    //       //               // }
    //       //               isSelected[index] = !isSelected[index];
    //       //               });
    //       //           },
    //       //           isSelected: isSelected,
    //       //           ),
    //     ],
    //   );
    // }

    _loteriasButtonsScreen(bool isSmallOrMedium){
      if(isSmallOrMedium)
        return ListTile(
          leading: Icon(Icons.ballot),
          title: Text(_loterias.length > 0 ? _loterias.map((e) => e.descripcion).join(", ") : "Agregar loterias "),
          onTap: () async {
            var loteriasRetornadas = await showDialog(
              context: context, 
              builder: (context){
                return MyMultiselect(
                  title: "Agregar loterias",
                  items: listaLoteria.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
                  initialSelectedItems: _loterias.length == 0 ? [] : _loterias.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
                );
              }
            );

            if(loteriasRetornadas != null)
              setState(() => _loterias = List.from(loteriasRetornadas));
          },
        );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySubtitle(title: "Loterias", padding: EdgeInsets.only(top: 15, bottom: 4),),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 15.0),
          //   child: MyDescripcon(title: "Son los sorteos que se podran jugar en esta loteria.", fontSize: 14,),
          // ),
          MyToggleButtons(
            items: listaLoteria.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
            selectedItems: _loterias != null ? _loterias.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList() : [],
            onTap: (value){
              int index = _loterias.indexWhere((element) => element == value);
              if(index != -1)
                setState(() => _loterias.removeAt(index));
              else
                setState(() => _loterias.add(value));
            },
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: ToggleButtons(
          //             borderColor: Colors.black,
                      
          //             // fillColor: Colors.grey,
          //             // borderWidth: 2,
          //             // selectedBorderColor: Colors.black,
          //             // selectedColor: Colors.white,
          //             borderWidth: 0.5,
          //             // selectedColor: Colors.pink,
          //             // selectedBorderColor: Colors.black,
          //             fillColor: Colors.grey[300],
          //             borderRadius: BorderRadius.circular(10),
          //             constraints: BoxConstraints(minHeight: 34, minWidth: 48),
          //             children: listaLoteria.map((e) => Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 18.0),
          //               child: Text(e.descripcion, style: TextStyle(fontWeight: FontWeight.w600),),
          //             )).toList(),
          //             // children: [Text("Hola"), Text("Hola")],
          //             onPressed: (int index) {
          //                 setState(() {
          //                 // for (int i = 0; i < isSelected.length; i++) {
          //                 //     isSelected[i] = i == index;
          //                 // }
          //                 isSelectedLoteria[index] = !isSelectedLoteria[index];
          //                 });
          //             },
          //             isSelected: isSelectedLoteria,
          //             ),
          
          // ),
        ],
      );
    }

    _horaAperturaChanged(Dia dia) async {
     TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(dia.horaApertura));
      final now = new DateTime.now();
      if(t == null)
        return;

     setState(() => dia.horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
     print("_horaAperturaChanged: ${t.format(context)}");
    }

    _horaCierreChanged(Dia dia) async {
     TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(dia.horaCierre));
      if(t == null)
        return;

      final now = new DateTime.now();
     setState(() => dia.horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
     print("_horaCierreChanged: ${t.format(context)}");
    }

    _horaAperturaTodosChanged() async {
      TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(Utils.dateTimeToDate(DateTime.now(), "01:00"))));
      if(t == null)
        return;
      final now = new DateTime.now();
      listaDia.forEach((element) {
        setState(() => element.horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
      });
    }

    _horaCierreTodosChanged() async {
      TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(Utils.dateTimeToDate(DateTime.now(), "23:00"))));
      if(t == null)
        return;
      final now = new DateTime.now();
      listaDia.forEach((element) {
        setState(() => element.horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
      });
    }

    _horariosColumnChildren(bool isSmallOrMedium){
      var children = listaDia.map((e) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isSmallOrMedium ? 20 : 0),
            child: Wrap(
              alignment: isSmallOrMedium ? WrapAlignment.spaceBetween : WrapAlignment.start,
              crossAxisAlignment: isSmallOrMedium ? WrapCrossAlignment.center : WrapCrossAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 8.0 : 0),
                  child: MyResizedContainer( xlarge: 8, child: Text("${e.descripcion}", style: TextStyle(fontSize: isSmallOrMedium ? 20 : null),)),
                ), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 35.0),
                  child: MyResizedContainer(medium: 7, large: 6, xlarge: 9, small: 2.5, child: Container(child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(child: Center(child: Text("${TimeOfDay.fromDateTime(e.horaApertura).format(context)}", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))), onTap: (){_horaAperturaChanged(e);},),
                  ))),
                ), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 35.0),
                  child: MyResizedContainer(medium: 7,  xlarge: 9, small: 2.5, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(child: Center(child: Text("${TimeOfDay.fromDateTime(e.horaCierre).format(context)}", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),)), onTap: (){_horaCierreChanged(e);},))),
                )
              ],
            ),
          )
          ).toList();

        //INSERT CAMPOS PARA CAMBIAR TODOS LOS HORARIOS
        children.insert(0, Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isSmallOrMedium ? 20 : 0),
            child: Wrap(
              alignment: isSmallOrMedium ? WrapAlignment.spaceBetween : WrapAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 8.0 : 0),
                  child: MyResizedContainer( xlarge: 8, child: Text("Cambiar todos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallOrMedium ? 20 : null),)),
                ), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 35.0),
                  child: MyResizedContainer(medium: 7, large: 6, xlarge: 9, small: 2.5, child: Container(child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(child: Center(child: Text("Todos", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))), onTap: (){_horaAperturaTodosChanged();},),
                  ))),
                ), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 35.0),
                  child: MyResizedContainer(medium: 7,  xlarge: 9, small: 2.5, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(child: Center(child: Text("Todos", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),)), onTap: (){_horaCierreTodosChanged();},))),
                )
              ],
            ),
          ));

        if(!isSmallOrMedium)
          children.insert(0, Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                  MyResizedContainer( xlarge: 8, child: Center(child: MySubtitle(title: "Dias",))), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: MyResizedContainer( xlarge: 9, child:  Center(child: MySubtitle(title: "Apertura",))),
                  ), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: MyResizedContainer( xlarge: 9, child:  Center(child: MySubtitle(title: "Cierre",))),
                  ), 
              ],
            ),
          ));

        return children;
    }

    _horariosScreen(bool isSmallOrMedium){
      return MyScrollbar(
          child: MyResizedContainer(
          xlarge: 2,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: _horariosColumnChildren(isSmallOrMedium),
          ),
        ),
      );
      // return MyTable(
      //   columns: [Center(child: Text("Dias")), Center(child: Text("Apertura")), Center(child: Text("Cierre"))], 
      //   rows: listaDia.map((e) => [e, "${e.descripcion}", InkWell(child: Text("${TimeOfDay.fromDateTime(e.horaApertura).format(context)}"), onTap: (){_horaAperturaChanged(e);},), InkWell(child: Text("${TimeOfDay.fromDateTime(e.horaCierre).format(context)}"), onTap: (){_horaCierreChanged(e);},)]).toList()
      // );
    }

    // _showDialogCopiarComisionYPagosALoteria(Loteria loteria){
    //   showDialog(
    //     context: context, 
    //     builder: (context){
    //       return MyAlertDialog(
    //         title: "Copiar comisiones",
    //       );
    //     }
    //   );
    // }

    _ckbLoteriasChanged(bool value, Loteria loteria){
      if(value){
        if(_loterias.indexWhere((element) => element.id == loteria.id) != -1)
          return;

        

        setState((){
          _loterias.add(loteria);
          if(_loteriasComisiones.indexWhere((element) => element.id == loteria.id) == -1){
            _loteriasComisiones.add(loteria);
            if(_comisiones.indexWhere((element) => element.idLoteria == loteria.id) == -1)
              _comisiones.add(Comision(idLoteria: loteria.id));
          }
          if(_loteriasPagosCombinaciones.indexWhere((element) => element.id == loteria.id) == -1){
            _loteriasPagosCombinaciones.add(loteria);
            if(_pagosCombinaciones.indexWhere((element) => element.idLoteria == loteria.id) == -1)
              _pagosCombinaciones.add(Pagoscombinacion(idLoteria: loteria.id));
          }
        });
      }else{
        setState((){
          _loterias.removeWhere((element) => element.id == loteria.id);
          _loteriasComisiones.removeWhere((element) => element.id == loteria.id);
          _comisiones.removeWhere((element) => element.idLoteria == loteria.id);
          _loteriasPagosCombinaciones.removeWhere((element) => element.id == loteria.id);
          _pagosCombinaciones.removeWhere((element) => element.idLoteria == loteria.id);
        });
      }
    }

    _loteriaIsSelected(Loteria loteria){
      if(_loterias == null)
        return false;

      if(_loterias.length == 0)
        return false;

      return _loterias.firstWhere((element) => element.id == loteria.id, orElse: () => null) != null;
    }

    Widget _loteriaItemColorWidget(Loteria loteria){
      return Padding(
        padding: const EdgeInsets.only(right: 22.0),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: loteria.color != null ? Utils.fromHex("${loteria.color}") : null,
            borderRadius: BorderRadius.circular(5.0)
          ),
        ),
      );
    }

    Widget _loteriaItemColorDescripcionWidget(Loteria loteria){
      return Text("${loteria.descripcion}");
    }

    Widget _loteriaItemSelectedWidget(Loteria loteria){
      return Checkbox(value: _loteriaIsSelected(loteria), onChanged: (value) => _ckbLoteriasChanged(value, loteria),);
    }

    Widget _loteriaItemWidget(Loteria loteria){
      return InkWell(
        onTap: () => _ckbLoteriasChanged(!_loteriaIsSelected(loteria), loteria),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _loteriaItemColorWidget(loteria),
                  _loteriaItemColorDescripcionWidget(loteria),
                ],
              ),
              _loteriaItemSelectedWidget(loteria)
            ],
          ),
        ),
      );
      return ListTile(
        minVerticalPadding: 2,
        leading: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: loteria.color != null ? Utils.fromHex("${loteria.color}") : null,
            borderRadius: BorderRadius.circular(5.0)
          ),
        ),
        // CircleAvatar(
        //   backgroundColor: loteria.color != null ? Utils.fromHex("${loteria.color}") : null,
        //   radius: 13,
        // ),
        title: Text("${loteria.descripcion}"),
        trailing: Checkbox(value: _loteriaIsSelected(loteria), onChanged: (value) => _ckbLoteriasChanged(value, loteria),),
      );
      return MyCheckBox(xlarge: 4, title: "${loteria.descripcion}", value: _loteriaIsSelected(loteria), onChanged: (value){_ckbLoteriasChanged(value, loteria);},);
    }

  Widget  _agregarYQuitarLoteriasWidget(bool isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Afectar loterias", value: _status, onChanged: _statusChanged, helperText: "Se agregarán las loterias marcadas y removerán las que no.",);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(
          title: "Estado", 
          helperText: "Agregará las loterias marcadas y removerá las que no.",
          hint: "${_status ? 'Activa' : 'Desactivada'}", isSideTitle: true, xlarge: 1.35, elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _statusChanged,),
      );
    }

   void _removerLoteriasQueNoEstanDeUnaListaDada(List listaDada, String nombreDelIdLoteriaDeLaListaDada, List<Loteria> listaLoteria){
      if(listaDada == null)
        return;
      if(listaDada.length == 0)
        return;

      listaDada.removeWhere((element) => !listaLoteria.map((e) => e.id).contains(element.get("$nombreDelIdLoteriaDeLaListaDada")));
    }

    Comision _obtenerComisionPorDefectoSiExiste(Loteria loteria){
      Comision _comisionARetornar = Comision(idLoteria: loteria.id);
      if(_comisionPorDefectoParaLlenarCamposComisionAlAgregarUnaLoteriaAEstaBanca != null){
        _comisionARetornar = Comision.fromMap(_comisionPorDefectoParaLlenarCamposComisionAlAgregarUnaLoteriaAEstaBanca.toJson());
        _comisionARetornar.idLoteria = loteria.id;
      } 
      return _comisionARetornar;
    }

  Pagoscombinacion _obtenerPagoCombinacionPorDefectoSiExiste(Loteria loteria){
      Pagoscombinacion _pagoCombinacionARetornar = Pagoscombinacion(idLoteria: loteria.id);
      if(_pagoCombinacionPorDefectoParaLlenarCamposPagoCombinacionAlAgregarUnaLoteriaAEstaBanca != null){
        _pagoCombinacionARetornar = Pagoscombinacion.fromMap(_pagoCombinacionPorDefectoParaLlenarCamposPagoCombinacionAlAgregarUnaLoteriaAEstaBanca.toJson());
        _pagoCombinacionARetornar.idLoteria = loteria.id;
      } 
      return _pagoCombinacionARetornar;
    }

    _agregarLoteriasAComisiones(List<Loteria> loterias){
      _removerLoteriasQueNoEstanDeUnaListaDada(_comisiones, "idLoteria", loterias);
      _removerLoteriasQueNoEstanDeUnaListaDada(_loteriasComisiones, "id", loterias);

      for (var loteria in loterias) {
        if(_loteriasComisiones.firstWhere((element) => element.id == loteria.id, orElse: () => null) == null)
          _loteriasComisiones.add(loteria);
        if(_comisiones.firstWhere((element) => element.idLoteria == loteria.id, orElse: () => null) == null){
          Comision comision = _obtenerComisionPorDefectoSiExiste(loteria);
          _comisiones.add(comision);
        }
      }
    }
    
    _agregarLoteriasAPagosCombinaciones(List<Loteria> loterias){
      _removerLoteriasQueNoEstanDeUnaListaDada(_pagosCombinaciones, "idLoteria", loterias);
      _removerLoteriasQueNoEstanDeUnaListaDada(_loteriasPagosCombinaciones, "id", loterias);
      
      for (var loteria in loterias) {
        if(_loteriasPagosCombinaciones.indexWhere((element) => element.id == loteria.id) == -1)
        _loteriasPagosCombinaciones.add(loteria);
        if(_pagosCombinaciones.indexWhere((element) => element.idLoteria == loteria.id) == -1)
          _pagosCombinaciones.add(_obtenerPagoCombinacionPorDefectoSiExiste(loteria));
      }
    }

    _loteriasChanged(List<Loteria> listaLoteriaSeleccionadas){
      _agregarLoteriasAComisiones(listaLoteriaSeleccionadas);
      _agregarLoteriasAPagosCombinaciones(listaLoteriaSeleccionadas);
      List<int> listaIdLoteriasUnicos = listaLoteriaSeleccionadas.map<int>((e) => e.id).toList().unique();
      setState(() => _loterias = listaLoteria.where((element) => listaIdLoteriasUnicos.contains(element.id)).toList());
    }

    bool _loteriaNoEstaSeleccionada(Loteria loteria){
      return !_loterias.map((e) => e.id).toList().contains(loteria.id);
    }

    _removerLoteria(Loteria loteria){
      setState(() => _loterias.removeWhere((element) => element.id == loteria.id));
    }

    _loteriasScreen(bool isSmallOrMedium){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 8.0 : 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(visible: _esTipoVentanaActualizarMasivamente(), child: _agregarYQuitarLoteriasWidget(isSmallOrMedium)),
            // Wrap(
            //   children: listaLoteria.map((e) => _loteriaItemWidget(e)).toList(),
            // ),
            MySubtitle(title: "Loterias asignadas"),
            MyDescripcon(title: "Son las loterías que esta banca tendrá disponible al vender."),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: MyhorizontalMultiSelect<Loteria>(
                items: listaLoteria.where((element) => _loteriaNoEstaSeleccionada(element)).map((e) => MyhorizontalMultiSelectItem<Loteria>(value: e, child: e.descripcion)).toList(),
                selectedItems: _loterias.map((e) => MyhorizontalMultiSelectItem<Loteria>(value: e, child: e.descripcion, color: Utils.fromHex(e.color))).toList(),
                onChanged: _loteriasChanged,
                onRemove: _removerLoteria,
              ),
            )
          ],
        ),
      );
    }

    _comisionQuinielaChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);
      print("Quiniela change != copiar todas data: $index");

        if(index == -1)
          return;

        
        _comisiones[index].directo = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.directo = double.tryParse(data);});
      }
    }
    
    _comisionPaleChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        
        _comisiones[index].pale = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.pale = double.tryParse(data);});
      }
    }

    _comisionTripletaChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        
        _comisiones[index].tripleta = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.tripleta = double.tryParse(data);});
      }
    }

    _comisionSuperpaleChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        _comisiones[index].superPale = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.superPale = double.tryParse(data);});
      }
    }

    _comisionPick3BoxChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        _comisiones[index].pick3Box = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.pick3Box = double.tryParse(data);});
      }
    }

    _comisionPick3StraightChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        _comisiones[index].pick3Straight = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.pick3Straight = double.tryParse(data);});
      }
    }

    _comisionPick4BoxChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        _comisiones[index].pick4Box = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.pick4Box = double.tryParse(data);});
      }
    }

    _comisionPick4StraightChanged(data){
      if(selectedLoteriaComision == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _comisiones.indexWhere((element) => element.idLoteria == selectedLoteriaComision.id);

        if(index == -1)
          return;

        _comisiones[index].pick4Straight = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _comisiones.forEach((element) {element.pick4Straight = double.tryParse(data);});
      }
    }

    _existeSorteoComision(String sorteo){
      if(selectedLoteriaComision == null)
        return false;
      if(selectedLoteriaComision.id == 0)
        return true;

        print("_existeSorteoComision: ${selectedLoteriaComision.descripcion} - ${selectedLoteriaComision.sorteos.length}");

      return selectedLoteriaComision.sorteos.indexWhere((element) => element.descripcion.toLowerCase() == sorteo) != -1;
    }

    

    _comisionesScreen(bool isSmallOrMedium){
      return MyScrollbar(
        child: Wrap(
          children: [
            MyToggleButtons(
                onTap: (data){
                  var d = _loteriasComisiones.firstWhere((element) => element.id == data, orElse: () => null);
                  setState(() {
                    selectedLoteriaComision = d;
                    print("hola comi: ${selectedLoteriaComision.descripcion}");
                    var comision = selectedLoteriaComision.id != 0 ? _comisiones.firstWhere((element) => element.idLoteria == selectedLoteriaComision.id) : Comision();
                    _txtDirecto.text = comision.directo != null ? "${comision.directo}" : '';
                    _txtPale.text = comision.pale != null ? "${comision.pale}" : '';
                    _txtTripleta.text = comision.tripleta != null ? "${comision.tripleta}" : '';
                    _txtSuperpale.text = comision.superPale != null ? "${comision.superPale}" : '';
                    _txtPick3Box.text = comision.pick3Box != null ? "${comision.pick3Box}" : '';
                    _txtPick3Straight.text = comision.pick3Straight != null ? "${comision.pick3Straight}" : '';
                    _txtPick4Box.text = comision.pick4Box != null ? "${comision.pick4Box}" : '';
                    _txtPick4Straight.text = comision.pick4Straight != null ? "${comision.pick4Straight}" : '';
                  });
                },
                // items: _loterias.map((e) => MyToggleData(value: e, child: e.descripcion)).toList(),
                items: _loteriasComisiones.map<MyToggleData>((e) => MyToggleData(value: e.id, child: e.descripcion)).toList(),
                selectedItems: selectedLoteriaComision != null ? [MyToggleData(value: selectedLoteriaComision.id, child: "${selectedLoteriaComision.descripcion}")] : [],
              ),
              
            MyScrollbar(
              child: Column(
                children: [
                  Visibility(
                    visible: selectedLoteriaComision != null ? selectedLoteriaComision.id == 0 : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("Al llenar las campos debajos se copiaran los valores automaticamentes a todas las loterias", style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  Visibility(
                    visible: _existeSorteoComision("directo"),
                    child: Wrap(
                      children: [
                        MyDivider(showOnlyOnSmall: true,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                          child: MyTextFormField(
                            leading: isSmallOrMedium ? Text("QN") : null,
                            isSideTitle: isSmallOrMedium ? false : true,
                            type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            controller: _txtDirecto,
                            isDigitOnly: true,
                            title: !isSmallOrMedium ? "Quiniela" : "",
                            hint: "Quiniela",
                            medium: 1,
                            onChanged: _comisionQuinielaChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _existeSorteoComision("pale"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("PL") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtPale,
                        title: !isSmallOrMedium ? "Pale" : "",
                        hint: "Pale",
                        medium: 1,
                        onChanged: _comisionPaleChanged,
                        isDigitOnly: true,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _existeSorteoComision("tripleta"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("TP") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtTripleta,
                        title: !isSmallOrMedium ? "Tripleta *" : "",
                        hint: "Tripleta",
                        medium: 1,
                        onChanged: _comisionTripletaChanged,
                        isDigitOnly: true,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _existeSorteoComision("super pale"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("SP") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtSuperpale,
                        title: !isSmallOrMedium ? "Super pale" : "",
                        hint: "Super pale",
                        onChanged: _comisionSuperpaleChanged,
                        medium: 1,
                        isDigitOnly: true,
                      ),
                    ),
                  ),
                  MyDivider(showOnlyOnSmall: true,),
                  Visibility(
                    visible: _existeSorteoComision("pick 3 box"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("P3B") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtPick3Box,
                        title: !isSmallOrMedium ? "Pick 3 box" : "",
                        hint: "Pick 3 box",
                        medium: 1,
                        onChanged: _comisionPick3BoxChanged,
                        isDigitOnly: true,
                      ),
                    ),
                  ),
                   
                  Visibility(
                    visible: _existeSorteoComision("pick 3 straight"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("P3S") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtPick3Straight,
                        title: !isSmallOrMedium ? "Pick 3 straight" : "",
                        hint: "Pick 3 straight",
                        medium: 1,
                        onChanged: _comisionPick3StraightChanged,
                        isDigitOnly: true,
                      ),
                    ),
                  ),
                   Visibility(
                    visible: _existeSorteoComision("pick 4 box"),
                     child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("P3B") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtPick4Box,
                        title: !isSmallOrMedium ? "Pick 4 box" : "",
                        hint: "Pick 4 box",
                        medium: 1,
                        onChanged: _comisionPick4BoxChanged,
                        isDigitOnly: true,
                      ),
                  ),
                   ),
                  Visibility(
                    visible: _existeSorteoComision("pick 4 straight"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("P4S") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                        controller: _txtPick4Straight,
                        title: !isSmallOrMedium ? "Pick 4 straight" : "",
                        hint: "Pick 4 straight",
                        medium: 1,
                        onChanged: _comisionPick4StraightChanged,
                        isDigitOnly: true,
                      ),
                    ),
                  ),
                   
                ],
              ),
            ),
          ],
        ),
      );
    }

    _pagosCombinacionPrimeraChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].primera = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.primera = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionSegundaChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].segunda = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.segunda = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionTerceraChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].tercera = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.tercera = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPrimeraSegundaChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].primeraSegunda = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.primeraSegunda = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPrimeraTerceraChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].primeraTercera = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.primeraTercera = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionSegundaTerceraChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].segundaTercera = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.segundaTercera = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionTresNumerosChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].tresNumeros = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.tresNumeros = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionDosNumerosChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].dosNumeros = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.dosNumeros = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPrimerPagoChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].primerPago = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.primerPago = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick3TodosEnSecuenciaChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick3TodosEnSecuencia = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick3TodosEnSecuencia = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick33WayChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick33Way = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick33Way = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick36WayChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick36Way = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick36Way = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick4TodosEnSecuenciaChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick4TodosEnSecuencia = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick4TodosEnSecuencia = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick44WayChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick44Way = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick44Way = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick46WayChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick46Way = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick46Way = Utils.toDouble(data);});
      }

    }
    _pagosCombinacionPick412WayChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick412Way = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick412Way = Utils.toDouble(data);});
      }
    }

    _pagosCombinacionPick424WayChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaPagosCombinacion.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].pick424Way = Utils.toDouble(data) != null ? Utils.toDouble(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.pick424Way = Utils.toDouble(data);});
      }
    }

    _existeSorteoPagosCombinacion(String sorteo,[int idLoteria]){
      if(idLoteria == null){
        if(selectedLoteriaPagosCombinacion == null)
          return false;
        if(selectedLoteriaPagosCombinacion.id == 0)
          return true;

          print("_existeSorteoPagosCombinacion: ${selectedLoteriaPagosCombinacion.descripcion} - ${selectedLoteriaPagosCombinacion.sorteos.length}");

        return selectedLoteriaPagosCombinacion.sorteos.indexWhere((element) => element.descripcion.toLowerCase() == sorteo) != -1;
      }else{
        var loteria = _loteriasPagosCombinaciones.firstWhere((element) => element.id == idLoteria, orElse: () => null);
        if(loteria == null)
          return false;
          
        if(loteria.id == 0)
          return false;

          print("_existeSorteoPagosCombinacion idLoteria != null: ${loteria.descripcion} - ${loteria.sorteos.length}");

        return loteria.sorteos.indexWhere((element) => element.descripcion.toLowerCase() == sorteo) != -1;
      }
    }

    _pagosCombinacionesScreen(bool isSmallOrMedium){
      return MyScrollbar(
        child: MyResizedContainer(
          xlarge: 1.2,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                MyToggleButtons(
                  onTap: (data){
                    var d = _loteriasPagosCombinaciones.firstWhere((element) => element.id == data, orElse: () => null);
                    setState(() {
                      selectedLoteriaPagosCombinacion = d;
                      print("hola pago: ${selectedLoteriaPagosCombinacion.descripcion}");
                      var pago = selectedLoteriaPagosCombinacion.id != 0 ? _pagosCombinaciones.firstWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id) : Pagoscombinacion();
                      _txtPrimera.text = pago.primera != null ? "${pago.primera}" : '';
                      _txtSegunda.text = pago.segunda != null ? "${pago.segunda}" : '';
                      _txtTercera.text = pago.tercera != null ? "${pago.tercera}" : '';
                      _txtPrimerPago.text = pago.primerPago != null ? "${pago.primerPago}" : '';
                      _txtPrimeraSegunda.text = pago.primeraSegunda != null ? "${pago.primeraSegunda}" : '';
                      _txtPrimeraTercera.text = pago.primeraTercera != null ? "${pago.primeraTercera}" : '';
                      _txtSegundaTercera.text = pago.segundaTercera != null ? "${pago.segundaTercera}" : '';
                      _txtTresNumeros.text = pago.tresNumeros != null ? "${pago.tresNumeros}" : '';
                      _txtDosNumeros.text = pago.dosNumeros != null ? "${pago.dosNumeros}" : '';
                      _txtPrimerPago.text = pago.primerPago != null ? "${pago.primerPago}" : '';
                      _txtPick3TodosEnSecuencia.text = pago.pick3TodosEnSecuencia != null ? "${pago.pick3TodosEnSecuencia}" : '';
                      _txtPick33Way.text = pago.pick33Way != null ? "${pago.pick33Way}" : '';
                      _txtPick36Way.text = pago.pick36Way != null ? "${pago.pick36Way}" : '';
                      _txtPick4TodosEnSecuencia.text = pago.pick4TodosEnSecuencia != null ? "${pago.pick4TodosEnSecuencia}" : '';
                      _txtPick44Way.text = pago.pick44Way != null ? "${pago.pick44Way}" : '';
                      _txtPick46Way.text = pago.pick46Way != null ? "${pago.pick46Way}" : '';
                      _txtPick412Way.text = pago.pick412Way != null ? "${pago.pick412Way}" : '';
                      _txtPick424Way.text = pago.pick424Way != null ? "${pago.pick424Way}" : '';
                    
                    });
                  },
                  // items: _loterias.map((e) => MyToggleData(value: e, child: e.descripcion)).toList(),
                  items: _loteriasPagosCombinaciones.map<MyToggleData>((e) => MyToggleData(value: e.id, child: e.descripcion)).toList(),
                  selectedItems: selectedLoteriaPagosCombinacion != null ? [MyToggleData(value: selectedLoteriaPagosCombinacion.id, child: "${selectedLoteriaPagosCombinacion.descripcion}")] : [],
                ),
                Visibility(
                  visible: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id == 0 : false,
                  child: MyResizedContainer(
                    xlarge: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("Al llenar las campos debajos se copiaran los valores automaticamentes a todas las loterias", style: TextStyle(color: Colors.green)),
                    ),
                  ),
                ),
                Visibility(
                  visible: _existeSorteoPagosCombinacion("directo"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Quiniela", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              
                              leading: isSmallOrMedium ? Text("1ra") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPrimera,
                              title: !isSmallOrMedium ? "Primera" : "",
                              hint:  isSmallOrMedium ? "Primera" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion.id != 0,
                              onChanged: _pagosCombinacionPrimeraChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("2da") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtSegunda,
                              title: !isSmallOrMedium ? "Segunda" : "",
                              hint: isSmallOrMedium ? "Segunda" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionSegundaChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("3ra") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtTercera,
                              title: !isSmallOrMedium ? "Tercera" : "",
                              hint:  isSmallOrMedium ? "Tercera" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionTerceraChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               
                Visibility(
                  visible: _existeSorteoPagosCombinacion("pale"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Pale", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("1-2") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPrimeraSegunda,
                              title: !isSmallOrMedium ? "1ra y 2da" : "",
                              hint:  isSmallOrMedium ? "1ra y 2da" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPrimeraSegundaChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("1-3") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPrimeraTercera,
                              title: !isSmallOrMedium ? "1ra y 3ra" : "",
                              hint: isSmallOrMedium ? "1ra y 3ra" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPrimeraTerceraChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("2-3") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtSegundaTercera,
                              title: !isSmallOrMedium ? "2da y 3ra" : "",
                              hint:  isSmallOrMedium ? "2da y 3ra" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionSegundaTerceraChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               
                Visibility(
                  visible: _existeSorteoPagosCombinacion("tripleta"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Tripleta", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("3#") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtTresNumeros,
                              title: !isSmallOrMedium ? "3 numeros" : "",
                              hint:  isSmallOrMedium ? "3 numeros" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionTresNumerosChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("2#") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtDosNumeros,
                              title: !isSmallOrMedium ? "2 numeros" : "",
                              hint: isSmallOrMedium ? "2 numeros" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionDosNumerosChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               
                Visibility(
                  visible: _existeSorteoPagosCombinacion("super pale"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Super pale", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("1er") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPrimerPago,
                              title: !isSmallOrMedium ? "Primer pago" : "",
                              hint:  isSmallOrMedium ? "Primer pago" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPrimerPagoChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               
                Visibility(
                  visible: _existeSorteoPagosCombinacion("pick 3 straight"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Pick 3 Straight", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("to") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick3TodosEnSecuencia,
                              title: !isSmallOrMedium ? "Todos en secuencia" : "",
                              hint:  isSmallOrMedium ? "Todos en secuencia" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick3TodosEnSecuenciaChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: _existeSorteoPagosCombinacion("pick 3 box"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Pick 3 Box", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("3w") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick33Way,
                              title: !isSmallOrMedium ? "3-way: 2 identicos" : "",
                              hint:  isSmallOrMedium ? "3-way: 2 identicos" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick33WayChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("6w") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick36Way,
                              title: !isSmallOrMedium ? "6-way: 3 unicos" : "",
                              hint:  isSmallOrMedium ? "6-way: 3 unicos" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick36WayChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                 Visibility(
                  visible: _existeSorteoPagosCombinacion("pick 4 straight"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Pick 4 Straight", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("to") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick4TodosEnSecuencia,
                              title: !isSmallOrMedium ? "Todos en secuencia" : "",
                              hint:  isSmallOrMedium ? "Todos en secuencia" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick4TodosEnSecuenciaChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: _existeSorteoPagosCombinacion("pick 4 box"),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 12.0, vertical: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(
                      xlarge: 4,
                      medium: 1,
                      child: Wrap(
                        children: [
                          MyDivider(showOnlyOnSmall: true,),
                          MySubtitle(title: "Pick 4 Box", padding: EdgeInsets.symmetric(vertical: 5),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("4w") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick44Way,
                              title: !isSmallOrMedium ? "4-way: 3 identicos" : "",
                              hint:  isSmallOrMedium ? "4-way: 3 identicos" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick44WayChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("6w") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick46Way,
                              title: !isSmallOrMedium ? "6-way: 2 identicos" : "",
                              hint:  isSmallOrMedium ? "6-way: 2 identicos" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick46WayChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("12w") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick412Way,
                              title: !isSmallOrMedium ? "12-way: 2 identicos" : "",
                              hint:  isSmallOrMedium ? "12-way: 2 identicos" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick412WayChanged,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 6.0),
                            child: MyTextFormField(
                              leading: isSmallOrMedium ? Text("24w") : null,
                              isMoneyFormat: true,
                              isSideTitle: isSmallOrMedium ? false : true,
                              type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                              controller: _txtPick424Way,
                              title: !isSmallOrMedium ? "24-way: 2 identicos" : "",
                              hint:  isSmallOrMedium ? "24-way: 2 identicos" : "",
                              xlargeSide: 6.5,
                              medium: 1,
                              isRequired: selectedLoteriaPagosCombinacion != null ? selectedLoteriaPagosCombinacion.id != 0 : true,
                              onChanged: _pagosCombinacionPick424WayChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               
               
                 
              ],
            ),
          ),
        ),
      );
    }

    

    _showDialogGasto({Gasto gasto}) async {
     

      if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width)){
        var gastoReturned = await Navigator.push(context, MaterialPageRoute(builder: (context) => GastosScreen(listaDia: listaDia, listaFrecuencia: listaFrecuencia, gasto: gasto,)));
        if(gastoReturned == null)
          return;

          var data = _gastos.firstWhere((element) => element == gastoReturned, orElse: () => null);
          if(data == null)
            _gastos.add(gastoReturned);

          //   if(idx == -1)
          //   _gastos.add(gastoReturned);
          // else
          //   _gastos[idx] = gastoReturned;

        _streamControllerGastos.add(_gastos);
      }
      else{
         Frecuencia _frecuencia = gasto != null ? listaFrecuencia.firstWhere((element) => element.id == gasto.frecuencia.id, orElse: () => null) : listaFrecuencia.firstWhere((element) => element.descripcion == "Semanal", orElse: () => null);
      Dia _dia = gasto != null ? listaDia.firstWhere((element) => element.id == gasto.dia.id, orElse: () => null) : listaDia[0];
      String title = "${gasto != null ? 'Editar' : 'Agregar'} gasto";
      _txtDescripcionGasto.text = gasto != null ? gasto.descripcion : '';
      _txtMontoGasto.text = gasto != null ? gasto.monto.toString() : '';


      if(gasto == null)
        gasto = Gasto();

        showDialog(
          context: context, 
          builder: (context){
            return StatefulBuilder(
              builder: (context, setState) {
                
                
                guardar(){
                  if(_formKeyGasto.currentState.validate() == false)
                    return;

                    gasto.descripcion = _txtDescripcionGasto.text;
                    gasto.monto = Utils.toDouble(_txtMontoGasto.text);
                    gasto.frecuencia = _frecuencia;
                    gasto.dia = _dia;
                    var data = _gastos.firstWhere((element) => element == gasto, orElse: () => null);
                    if(data == null)
                      _gastos.add(gasto);

                    _streamControllerGastos.add(_gastos);
                    Navigator.pop(context);
                }

                return MyAlertDialog(
                  title: "$title", 
                  description: "Los gastos automaticos se descontaran cada vez que se cumpla el plazo seleccionado.",
                  xlarge: 3,
                  content: Form(
                    key: _formKeyGasto,
                    child: Wrap(
                      children: [
                        Center(
                          child: MyToggleButtons(
                            items: listaFrecuencia.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
                            selectedItems: _frecuencia != null ? [MyToggleData(value: _frecuencia, child:"${_frecuencia.descripcion}" )] : [],
                            onTap: (data){
                              setState(() => _frecuencia = data);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _frecuencia != null,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${_frecuencia != null ? _frecuencia.observacion : ''}", style: TextStyle(fontSize: 12.5)),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: MyTextFormField(
                            type: MyType.border,
                            controller: _txtDescripcionGasto,
                            title: "Descripcion *",
                            isRequired: true,
                            autofocus: true,
                            medium: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: MyTextFormField(
                            type: MyType.border,
                            controller: _txtMontoGasto,
                            title: "Monto *",
                            isRequired: true,
                            isMoneyFormat: true,
                            medium: 1,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: Duration(microseconds: 300),
                          child: 
                          (_frecuencia != null ? _frecuencia.descripcion == "Semanal" : false) == false
                          ?
                          SizedBox.shrink()
                          :
                          MyDropdownButton(
                            title: "Dias *",
                            type: MyDropdownType.border,
                            padding: EdgeInsets.only(right: 12.0),
                            medium: 1,
                            initialValue: _dia,
                            value: _dia,
                            items: listaDia.map((e) => [e, "${e.descripcion}"]).toList(),
                            onChanged: (data){
                              setState(() => _dia = data);
                            },
                          ),
                        ),
                      ],
                    ),
                  ), 
                  okFunction: guardar
                );
              }
            );
          }
        );
      }
    }

    _showDialogEliminarGasto(Gasto gasto){
      showDialog(
        context: context, 
        builder: (context){
          eliminar(){
            _gastos.removeWhere((element) => element == gasto);
            _streamControllerGastos.add(_gastos);
            Navigator.pop(context);
          }

          return MyAlertDialog(
            title: "Eliminar gasto", 
            content: MyRichText(text: "Seguro desea eliminar el gasto", boldText: "${gasto.descripcion} ?"), 
            isDeleteDialog: true,
            okFunction: eliminar
          );
        }
      );
    }

  _seleccionarBancas(List<Banca> lista){
    if(lista == null)
      return;

    setState(() => _bancas = lista);
  }

  _mostrarBancasSearch() async {
    List<Banca> data = await showSearch(context: context, delegate: BancasMultipleSearch(listaBanca, _bancas));
    _seleccionarBancas(data);
  }

  _bancasWidget(bool isSmallOrMedium){
    return Visibility(
      visible: _esTipoVentanaActualizarMasivamente(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: MyDropdown(
          xlarge: 1.35,
          isSideTitle: !isSmallOrMedium,
          title: isSmallOrMedium ? null : "Bancas afectadas *",
          hint: "${_bancas.length > 0 ? _bancas.map((e) => e.descripcion).toList().join(", ") : 'Seleccionar las bancas...'}",
          // elements: listaBanca.map((e) => [e, "${e.descripcion}"]).toList(),
          helperText: "Bancas que serán afectadas por los cambios",
          onTap: () => _mostrarBancasSearch(),
        ),
      ),
    );
  }


  _obtenerTituloCorrespondienteALTipoDeVentana(){
    String titulo = "";
    switch (widget.parametros.tipoVentana) {
      case TipoVentanaBanca.actualizarMasivamente:
        titulo = "Actualizar masivamente" ;
        break;
      case TipoVentanaBanca.crearMasivamente:
        titulo = "Crear masivamente" ;
        break;
      default:
        titulo = "Agregar banca";
    }

    return titulo;
  }

  _titulo(bool isSmallOrMedium){
    if(isSmallOrMedium)
      return SizedBox.shrink();
    
    return _obtenerTituloCorrespondienteALTipoDeVentana();
  }

  _obtenerSubTituloCorrespondienteALTipoDeVentana(){
    String titulo = "";
    switch (widget.parametros.tipoVentana) {
      case TipoVentanaBanca.actualizarMasivamente:
        titulo = "Los campos que esten llenos serán modificados en todas las bancas seleccionadas" ;
        break;
      case TipoVentanaBanca.crearMasivamente:
        titulo = "Establece las secuencias de bancas a crear" ;
        break;
      default:
        titulo = "Agrega y administra todas tus bancas.";
    }

    return titulo;
  }

  _subtitulo(bool isSmallOrMedium){
    if(isSmallOrMedium)
      return '';
    
    return _obtenerSubTituloCorrespondienteALTipoDeVentana();
  }

  _nombreBancaWidget(bool isSmallOrMedium){
    return Visibility(
      visible: _esTipoVentanaNormal(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
        child: MyTextFormField(
          autofocus: true,
          leading: isSmallOrMedium ? SizedBox.shrink() : null,
          isSideTitle: isSmallOrMedium ? false : true,
          type: isSmallOrMedium ? MyType.noBorder : MyType.border,
          fontSize: isSmallOrMedium ? 28 : null,
          controller: _txtDescripcion,
          title: !isSmallOrMedium ? "Nombre de la banca *" : "",
          hint: "Nombre banca",
          medium: 1,
          isRequired: true,
          helperText: "Este es el nombre que aparecera en todas partes que se haga referencia a esta banca, inclusive encima del ticket impreso.",
        ),
      ),
    );
  }

  _bancasConSecuenciasWidget(bool isSmallOrMedium){
    return Visibility(
      visible: _esTipoVentanaCrearMasivamente(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
        child: MyTextFormField(
          autofocus: true,
          leading: isSmallOrMedium ? Icon(Icons.account_balance_wallet) : null,
          isSideTitle: isSmallOrMedium ? false : true,
          type: isSmallOrMedium ? MyType.noBorder : MyType.border,
          // fontSize: isSmallOrMedium ? 28 : null,
          controller: _txtNombreBancaConSecuencias,
          title: !isSmallOrMedium ? "Nombre de la banca con secuencias *" : "",
          hint: "Nombre banca con secuencias",
          medium: 1,
          isRequired: true,
          helperText: "Ejemplo.: Banca05-10",
        ),
      ),
    );
  }

  _usuariosConSecuenciasWidget(bool isSmallOrMedium){
    return Visibility(
      visible: _esTipoVentanaCrearMasivamente(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
        child: MyTextFormField(
          autofocus: true,
          leading: isSmallOrMedium ? Icon(Icons.person) : null,
          isSideTitle: isSmallOrMedium ? false : true,
          type: isSmallOrMedium ? MyType.noBorder : MyType.border,
          // fontSize: isSmallOrMedium ? 28 : null,
          controller: _txtNombreUsuarioConSecuencias,
          title: !isSmallOrMedium ? "Nombre del usuario con secuencias *" : "",
          hint: "Nombre usuario con secuencias",
          medium: 1,
          isRequired: true,
          helperText: "Ejemplo.: Usuario05-10",
        ),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    _streamControllerGastos = BehaviorSubject();
    _tabController = TabController(length: 7, vsync: this);
    _future = _init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      bancas: true,
      cargando: false,
      cargandoNotify: _cargandoNotify,
      isSliverAppBar: true,
      bottomTap: isSmallOrMedium ? null : _guardar,
      sliverBody: MySliver(
        withScroll: false,
        sliverAppBar: MySliverAppBar(
          title: _titulo(isSmallOrMedium),
          subtitle: _subtitulo(isSmallOrMedium),
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true, cargandoNotifier: _cargandoNotify)
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

            return SliverList(delegate: SliverChildListDelegate([
              MyTabBar(controller: _tabController, tabs: ["Datos", "Config.", "Horarios", "Comisiones", "Premios", "Loterias", "Gastos"], ),
              _bancasWidget(isSmallOrMedium),
                  
                ]));
          }
        ),
       sliverFillRemaining: SliverFillRemaining(
         child: FutureBuilder(
           future: _future,
           builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done)
                  return SizedBox();

             return Form(
               key: _formKey,
               child: TabBarView(
                 controller: _tabController,
                 children: [
                   Align(
                     alignment: Alignment.topLeft,
                     child: MyResizedContainer(
                       xlarge: 1.02,
                       large: 1.02,
                       medium: 1,
                       child: MyScrollbar(
                         child: Wrap(
                           children: [
                             MySubtitle(title: "Datos basicos", showOnlyOnLarge: true,),
                             _nombreBancaWidget(isSmallOrMedium),
                             _bancasConSecuenciasWidget(isSmallOrMedium),
                             _usuariosConSecuenciasWidget(isSmallOrMedium),
                             MyDivider(showOnlyOnSmall: true,),
                             Visibility(
                              visible: _esTipoVentanaNormal(),
                               child: Padding(
                                 padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                                 child: MyTextFormField(
                                   leading: isSmallOrMedium ? Icon(Icons.code,) : null,
                                   isSideTitle: isSmallOrMedium ? false : true,
                                   type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                   controller: _txtCodigo,
                                   title: !isSmallOrMedium ? "Codigo de la banca *" : "",
                                   hint: "Codigo",
                                   medium: 1,
                                   isRequired: true,
                                   helperText: "Codigo unico que le permitira filtrar esta banca",
                                 ),
                               ),
                             ),
                             Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? Icon(Icons.code,) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtDueno,
                                 title: !isSmallOrMedium ? "Dueño" : "",
                                 medium: 1,
                                 hint: "Dueño",
                               ),
                             ),
                             Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? Icon(Icons.code,) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtLocalidad,
                                 title: !isSmallOrMedium ? "Localidad" : "",
                                 medium: 1,
                                 hint: "Localidad",
                               ),
                             ),
                             _statusScreen(isSmallOrMedium),
                             MyDivider(showOnlyOnSmall: true,),
                             Visibility(
                              visible: _esTipoVentanaNormal(),
                               child: Padding(
                                 padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                                 child: MyDropdownButton(
                                   padding: EdgeInsets.all(0),
                                   leading: isSmallOrMedium ? Icon(Icons.person, color: Colors.black,) : null,
                                   isSideTitle: isSmallOrMedium ? false : true,
                                   type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                                   title: !isSmallOrMedium ? "Usuario al que pertenece *" : "",
                                   hint: "Usuario al que pertenece",
                                   value: _usuario,
                                   helperText: "Todos las ventas que este usuario realice se reflerejaran en esta banca.",
                                   items: listaUsuario.map((e) => [e, "${e.usuario}"]).toList(),
                                   onChanged: (data){
                                     setState(() => _usuario = data);
                                   },
                                 ),
                               ),
                             ),
                             Visibility(visible: _esTipoVentanaNormal(), child: MyDivider(showOnlyOnSmall: true,)),
                             Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyDropdownButton(
                                 padding: EdgeInsets.all(0),
                                 leading: isSmallOrMedium ? Icon(Icons.attach_money, color: Colors.black,) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                                 title: !isSmallOrMedium ? "Moneda" : "",
                                 hint: "moneda",
                                 value: _moneda,
                                 helperText: "Ayudara a separar y agrupar sus bancas por moneda",
                                 items: listaMoneda.map((e) => [e, "${e.descripcion}"]).toList(),
                                 onChanged: (data){
                                   setState(() => _moneda = data);
                                 },
                               ),
                             ),
                             MyDivider(showOnlyOnSmall: true,),
                             Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyDropdownButton(
                                 padding: EdgeInsets.all(0),
                                 leading: isSmallOrMedium ? Icon(Icons.group, color: Colors.black,) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                                 title: !isSmallOrMedium ? "Grupo al que pertenece" : "",
                                 hint: "Grupo al que pertenece",
                                 helperText: "Le permitira ordenar sus bancas",
                                 medium: 1,
                                 value: _grupo,
                                 items: listaGrupo.map((e) => [e, "${e.descripcion}"]).toList(),
                                 onChanged: (data){
                                   setState(() => _grupo = data.id != 0 ? data : null);
                                 },
                               ),
                             ),
                            //  MyDivider(showOnlyOnSmall: true,),
                            //  _statusScreen(isSmallOrMedium),
                            //  MyDivider(showOnlyOnSmall: true,),
                            //  Padding(
                            //    padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                            //    child: MyTextFormField(
                            //      leading: isSmallOrMedium ? Icon(Icons.code,) : null,
                            //      isSideTitle: isSmallOrMedium ? false : true,
                            //      type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            //      controller: _txtDueno,
                            //      title: !isSmallOrMedium ? "Dueño" : "",
                            //      hint: "Dueño",
                            //      isRequired: true,
                            //    ),
                            //  ),
                            //  MyDivider(showOnlyOnSmall: true,),
                            //  Padding(
                            //    padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                            //    child: MyTextFormField(
                            //      leading: isSmallOrMedium ? Icon(Icons.code,) : null,
                            //      isSideTitle: isSmallOrMedium ? false : true,
                            //      type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            //      controller: _txtLocalidad,
                            //      title: !isSmallOrMedium ? "Localidad" : "",
                            //      hint: "Localidad",
                            //      isRequired: true,
                            //    ),
                            //  ),
                             // MyDivider(showOnlyOnSmall: true,),
                             // _sorteosScreen(isSmallOrMedium),
                            //  MyDivider(showOnlyOnSmall: true,),
                            //  _loteriasButtonsScreen(isSmallOrMedium),
                            //  MyDivider(showOnlyOnSmall: true,),
                             // MyDropdown(
                             //   title: "Estado",
                             //   medium: 1,
                             //   hint: "${_status == 1 ? 'Activado' : 'Desactivado'}",
                             //   elements: [["Activado", "Activado"], ["Desactivado", "Desactivado"]],
                             //   onTap: (data){
                             //     setState(() => _status = (data == 'Activado') ? 1 : 0);
                             //   },
                             // )
                           ],
                         ),
                       ),
                     ),
                   ), 
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyResizedContainer(
                       xlarge: 1.02,
                       large: 1.02,
                       medium: 1,
                      child: MyScrollbar(
                        child: Wrap(
                          children: [
                            MySubtitle(title: "Datos configuracion", showOnlyOnLarge: true,),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 autofocus: true,
                                 leading: isSmallOrMedium ? Icon(Icons.strikethrough_s_sharp) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtLimiteVentasPorDia,
                                 isMoneyFormat: true,
                                 title: !isSmallOrMedium ? "Limite de ventas por dia *" : "",
                                 hint: "Limite de ventas por dia",
                                 medium: 1,
                                 isRequired: true,
                                 helperText: "Cuando la banca alcance este limite el sistema no permitira que se realicen mas ventas.",
                               ),
                             ),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? Icon(Icons.subtitles_off_sharp) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtBalance,
                                 isMoneyFormat: true,
                                 title: !isSmallOrMedium ? "Balance desactivacion *" : "",
                                 hint: "Balance desactivacion",
                                 medium: 1,
                                 helperText: "Cuando la banca alcance este balance el sistema no permitira que se realicen mas ventas.",
                               ),
                             ),
                             MyDivider(showOnlyOnSmall: true,),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? Icon(Icons.download_rounded) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtDescontar,
                                 isMoneyFormat: true,
                                 title: !isSmallOrMedium ? "Descontar *" : "",
                                 hint: "Descontar",
                                 medium: 1,
                                 helperText: "Este es el monto que se va a descontar cuando un ticket iguale o supere el valor del campo DE CADA.",
                               ),
                             ),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? Icon(Icons.money) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtDeCada,
                                 isMoneyFormat: true,
                                 title: !isSmallOrMedium ? "De cada" : "",
                                 hint: "De cada",
                                 medium: 1,
                                 helperText: "Cuando un ticket iguale o supere esta cantidad se descontara el valor del campo DESCONTAR.",
                               ),
                             ),
                             MyDivider(showOnlyOnSmall: true,),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? Icon(Icons.timer) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtMinutosParaCancelarTicket,
                                 isDigitOnly: true,
                                 title: !isSmallOrMedium ? "Minutos para cancelar ticket" : "",
                                 hint: "Minutos para cancelar ticket",
                                 medium: 1,
                                 isRequired: true,
                                 helperText: "Cuando un ticket iguale o supere esta cantidad se descontara el valor del campo DESCONTAR.",
                               ),
                             ),
                              MyDivider(showOnlyOnSmall: true,),
                             _qrScreen(isSmallOrMedium),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? 
                                 Wrap(
                                   children: [
                                     Icon(Icons.textsms,),
                                     Padding(
                                       padding: const EdgeInsets.only(top: 8.0),
                                       child: Text("1", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                                     )
                                   ],
                                 ) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtPiePagina1,
                                //  isDigitOnly: true,
                                 title: !isSmallOrMedium ? "Pie de pagina 1" : "",
                                 hint: "Pie de pagina 1",
                                 medium: 1,
                                 helperText: "Este valor aparecera al final del ticket",
                               ),
                             ),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? 
                                 Wrap(
                                   children: [
                                     Icon(Icons.textsms,),
                                     Padding(
                                       padding: const EdgeInsets.only(top: 8.0),
                                       child: Text("2", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                                     )
                                   ],
                                 ) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtPiePagina2,
                                //  isDigitOnly: true,
                                 title: !isSmallOrMedium ? "Pie de pagina 2" : "",
                                 hint: "Pie de pagina 2",
                                 medium: 1,
                               ),
                             ),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? 
                                 Wrap(
                                   children: [
                                     Icon(Icons.textsms,),
                                     Padding(
                                       padding: const EdgeInsets.only(top: 8.0),
                                       child: Text("3", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                                     )
                                   ],
                                 ) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtPiePagina3,
                                //  isDigitOnly: true,
                                 title: !isSmallOrMedium ? "Pie de pagina 3" : "",
                                 hint: "Pie de pagina 3",
                                 medium: 1,
                               ),
                             ),
                            Padding(
                               padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                               child: MyTextFormField(
                                 leading: isSmallOrMedium ? 
                                 Wrap(
                                   children: [
                                     Icon(Icons.textsms,),
                                     Padding(
                                       padding: const EdgeInsets.only(top: 8.0),
                                       child: Text("4", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                                     )
                                   ],
                                 ) : null,
                                 isSideTitle: isSmallOrMedium ? false : true,
                                 type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                 controller: _txtPiePagina4,
                                //  isDigitOnly: true,
                                 title: !isSmallOrMedium ? "Pie de pagina 4" : "",
                                 hint: "Pie de pagina 4",
                                 medium: 1,
                               ),
                             ),
                          ],
                        )
                      ),
                    ),
                  ), 
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyResizedContainer(
                      xlarge: 1.02,
                      large: 1.02,
                      medium: 1,
                      child: _horariosScreen(isSmallOrMedium)
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyResizedContainer(
                      xlarge: 1.02,
                      large: 1.02,
                      medium: 1,
                      child: _comisionesScreen(isSmallOrMedium)
                    ),
                  ),
                  // Center(child: Text("Comisiones")),
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyResizedContainer(
                      xlarge: 1.02,
                      large: 1.02,
                      medium: 1,
                      child: _pagosCombinacionesScreen(isSmallOrMedium)
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyResizedContainer(
                      xlarge: 1.02,
                      large: 1.02,
                      medium: 1,
                      child: SingleChildScrollView(child: _loteriasScreen(isSmallOrMedium)),
                    ),
                  ),
                  

                  StreamBuilder<List<Gasto>>(
                    stream: _streamControllerGastos.stream,
                    builder: (context, snapshot) {
                      if(snapshot.data == null)
                        return Align(alignment: Alignment.center ,child: MyEmpty(title: "No hay gastos", icon: Icons.money_off, titleButton: "Agregar gasto", onTap: _showDialogGasto,));

                      return 
                      Wrap(
                        children: [
                          Align(alignment: Alignment.topRight, child: TextButton(child: Text("Agregar gasto"), onPressed: _showDialogGasto,)),
                          Row(
                            children: [
                              Expanded(
                                child: MyTable(
                                  isScrolled: false,
                                  columns: ["#", "Descripcion", "Monto", "Plazo", "Creado"], 
                                  onTap: (data){_showDialogGasto(gasto: data);},
                                  delete: (data){_showDialogEliminarGasto(data);},
                                  rows: _gastos.asMap().map((key, value) => MapEntry(key, [value, "${key + 1}", "${value.descripcion}", "${value.monto}", "${value.frecuencia != null ? value.frecuencia.descripcion : ''}",  "${value.created_at != null ? Utils.formatDateTime(value.created_at) : '-'}"])).values.toList()
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  )
               ]),
             );
           }
         ),
       ),  
      )
    );
  }
}