

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bloqueo.dart';
import 'package:loterias/core/models/bloqueodata.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/views/bloqueos/bloqueosdetallascreen.dart';
import 'package:loterias/ui/views/bloqueos/bloqueosverbancasscreen.dart';
import 'package:loterias/ui/widgets/MyPadding.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:rxdart/rxdart.dart';

class BloqueosScreen extends StatefulWidget {
  const BloqueosScreen({Key key}) : super(key: key);

  @override
  State<BloqueosScreen> createState() => _BloqueosScreenState();
}

class _BloqueosScreenState extends State<BloqueosScreen> with TickerProviderStateMixin{
  TabController _tabController;
  StreamController<List<BloqueoData>> _streamBloqueoGeneral;
  StreamController<List<BloqueoData>> _streamBloqueoPorBanca;
  StreamController<List<BloqueoData>> _streamBloqueoJugada;
  StreamController<List<BloqueoData>> _streamBloqueoJugadaPorBanca;
  Future _futureCargo;
  bool _isSmallOrMedium = true;
  List<Moneda> listaMoneda;
  List<BloqueoData> listaBloqueoGeneral;
  List<BloqueoData> listaBloqueoPorBanca;
  List<BloqueoData> listaBloqueoJugadas;
  List<BloqueoData> listaBloqueoJugadasPorBanca;
  TipoBloqueo _tipoBloqueo = TipoBloqueo.general;
  List<Grupo> listaGrupo = [];
  Moneda _moneda;
  Grupo _grupo;
  bool _mostrarFiltroPorGrupos = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _streamBloqueoGeneral = BehaviorSubject();
    _streamBloqueoPorBanca = BehaviorSubject();
    _streamBloqueoJugada = BehaviorSubject();
    _streamBloqueoJugadaPorBanca = BehaviorSubject();
    _futureCargo = _init();
    print("bloqueosscreen init state2: ${_tabController.index}");
    _tabController.addListener(() {
    print("bloqueosscreen init state: ${_tabController.index}");

      // if(_tabController.index == 1){
        _cargarDatosPorBancaSiEsPrimeraVez();
      // }
    });
  }

  _init() async {
    var data = await BloqueosService.buscarIndex(context: context);
    listaBloqueoGeneral = BloqueoData.fromMapList(data["sorteos"]);
    listaMoneda = Moneda.fromMapList(data["monedas"]);
    listaGrupo = Grupo.fromMapList(data["grupos"]);
    listaGrupo.insert(0, Grupo.getGrupoNinguno);
    if(listaMoneda.length > 0)
      _moneda = listaMoneda[0];
    _streamBloqueoGeneral.add(listaBloqueoGeneral);
    print("BloquesScreen _init: $data");
  }

  _cargarDatosPorBancaSiEsPrimeraVez(){
    print("bloqueosscreen _cargarDatosPorBancaSiEsPrimeraVez: ${_getTipoBloqueo()}");
    if(_esBloqueoPorBanca()){
      if(listaBloqueoPorBanca == null)
        _buscarDatos();
    }
    else if(_esBloqueoJugadas()){
      if(listaBloqueoJugadas == null)
        _buscarDatos();
    }
    else if(_esBloqueoJugadasPorBanca()){
      if(listaBloqueoJugadasPorBanca == null)
        _buscarDatos();
    }

    if(_esBloqueoPorBancas())
      setState(() => _mostrarFiltroPorGrupos = true);
    else
      setState(() => _mostrarFiltroPorGrupos = false);

  }

  @override
  Widget build(BuildContext context) {
    _isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Bloqueos",
        ), 
        sliver: SliverList(delegate: SliverChildListDelegate([
                  MyPadding(child: MyTabBar(controller: _tabController, tabs: ["General", "Por banca.", "Jugadas", "Jug. por bancas"], indicator: _lineasTabBarWidget(),)),
                  FutureBuilder<void>(
                    future: _futureCargo,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState != ConnectionState.done)
                        return SizedBox.shrink();

                      return _myFilterWidget();
                    }
                  )
                ])),
        sliverFillRemaining: SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
            _bloqueoGeneralWidget(),
            _bloqueoPorBancaWidget(),
            _bloqueoJugadasWidget(),
            _bloqueoJugadasPorBancaWidget(),
          ]),
        ),
      )
    );
  }

   _lineasTabBarWidget(){
    return UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        // insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
      );
  }

  _myFilterWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 50,
        child: MyFilterV2(
            padding: !_esPantallaPequena() ? EdgeInsets.symmetric(horizontal: 15, vertical: 10) : null,
                        item: [
                          // MyFilterItem(
                          //   // color: Colors.blue[800],
                          //   enabled: _tienePermisoJugarComoCualquierBanca,
                          //   visible: _tienePermisoJugarComoCualquierBanca,
                          //   hint: "${_banca != null ? 'Banca:  ' + _banca.descripcion: 'Banca...'}", 
                          //   data: listaBanca.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                          //   onChanged: (value){
                          //     _bancaChanged(value);
                          //   }
                          // ),
                          MyFilterItem(
                            // color: Colors.green[700],
                            hint: "${_moneda != null ? 'Moneda:  ' + _moneda.descripcion: 'Moneda...'}", 
                            data: listaMoneda.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                            onChanged: (value){
                              _monedaChanged(value);
                            }
                          ),
                          MyFilterItem(
                            // color: Colors.green[700],
                            visible: _mostrarFiltroPorGrupos,
                            hint: "${_grupo != null ? 'Grupo:  ' + _grupo.descripcion: 'Grupo...'}", 
                            data: listaGrupo.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                            onChanged: (value){
                              _grupoChanged(value);
                            }
                          ),
                          // MyFilterItem(
                          //   // color: Colors.orange[700],
                          //   hint: "${_tipoTicket != null ? 'Estado:  ' + _tipoTicket[1] : 'Estados...'}", 
                          //   data: listaTipoTicket.map((e) => MyFilterSubItem(child: e[1], value: e)).toList(),
                          //   onChanged: (value){
                          //     _tipoTicketChanged(value);
                          //   }
                          // ),
                        ],
                      ),
      ),
    );
  }

  _monedaChanged(moneda){
    setState(() {
      _moneda = moneda;
      _buscarDatos();
    });
  }

  _grupoChanged(grupo){
    setState(() {
      _grupo = grupo.id != Grupo.getGrupoNinguno.id ? grupo : null;
      _buscarDatos();
    });
  }

  _buscarDatos([bool cargarEnSilencio = false]) async {
    if(!cargarEnSilencio)
      _asignarValorNuloAStreamController();
    var data = await BloqueosService.buscar(context: context, moneda: _moneda, grupo: _getGrupo(), tipoBloqueo: _getTipoBloqueo());
    // listaBloqueoGeneral = BloqueoData.fromMapList(data["sorteos"]);
    // _streamBloqueoGeneral.add(listaBloqueoGeneral);
    _asingarDatosParaLaVentanaCorrespondiente(data["sorteos"]);
    print("BloquesScreen _buscarDatos: $data");
  }

  _asignarValorNuloAStreamController(){
    switch (_getTipoBloqueo()) {
      case TipoBloqueo.porBancas:
      _streamBloqueoPorBanca.add(null);
        break;
      case TipoBloqueo.jugadas:
      _streamBloqueoJugada.add(null);
        break;
      case TipoBloqueo.jugadasPorBanca:
      _streamBloqueoJugadaPorBanca.add(null);
        break;
      default:
        _streamBloqueoGeneral.add(null);
      break;
    }
  }

  _getGrupo(){
    if(_esBloqueoPorBanca() || _esBloqueoJugadasPorBanca())
      return _grupo;
    return null;
  }

  _asingarDatosParaLaVentanaCorrespondiente(var sorteos){
    switch (_getTipoBloqueo()) {
      case TipoBloqueo.porBancas:
        listaBloqueoPorBanca = BloqueoData.fromMapList(sorteos);
      _streamBloqueoPorBanca.add(listaBloqueoPorBanca);
        break;
      case TipoBloqueo.jugadas:
        listaBloqueoJugadas = BloqueoData.fromMapList(sorteos);
        _streamBloqueoJugada.add(listaBloqueoJugadas);
        break;
      case TipoBloqueo.jugadasPorBanca:
        listaBloqueoJugadasPorBanca = BloqueoData.fromMapList(sorteos);
        _streamBloqueoJugadaPorBanca.add(listaBloqueoJugadasPorBanca);
        break;
      default:
        listaBloqueoGeneral = BloqueoData.fromMapList(sorteos);
        _streamBloqueoGeneral.add(listaBloqueoGeneral);
      break;
    }
  }

  _bloqueoGeneralWidget(){
    return StreamBuilder<List<BloqueoData>>(
      stream: _streamBloqueoGeneral.stream,
      builder: (context, snapshot) => _bloqueosWidget(snapshot)
    );
  }

  _bloqueoPorBancaWidget(){
    return StreamBuilder<List<BloqueoData>>(
      stream: _streamBloqueoPorBanca.stream,
      builder: (context, snapshot) => _bloqueosWidget(snapshot)
    );
  }

  _bloqueoJugadasWidget(){
    return StreamBuilder<List<BloqueoData>>(
      stream: _streamBloqueoJugada.stream,
      builder: (context, snapshot) => _bloqueosWidget(snapshot)
    );
  }

  _bloqueoJugadasPorBancaWidget(){
    return StreamBuilder<List<BloqueoData>>(
      stream: _streamBloqueoJugadaPorBanca.stream,
      builder: (context, snapshot) => _bloqueosWidget(snapshot)
    );
  }

  _bloqueosWidget(AsyncSnapshot<List<BloqueoData>> snapshot){
    if(snapshot.hasError)
      return _errorWidget(snapshot);
    if(!snapshot.hasData)
      return _cargandoWidget();

    if(snapshot.data.length == 0)
      return _noHayDatosWidget();

    return MyPadding(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              Row(
                children: [
                  MySubtitle(title: "${snapshot.data[index].sorteo.descripcion}", fontWeight: FontWeight.bold, padding: EdgeInsets.symmetric(vertical: 20.0),),
                Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Text("${snapshot.data[index].bloqueos.length}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ]
              ),
              Column(
                children: snapshot.data[index].bloqueos.map((e) => _informacionBloqueo(e)).toList(),
              )
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: snapshot.data[index].bloqueos.length,
              //   itemBuilder: (context, indexBloqueo) => _informacionBloqueo(snapshot.data[index].bloqueos[indexBloqueo]),
              // )
            ],
          );
        },
      ),
    );
  }

  Widget _errorWidget(snapshot){
    return Center(child: Text("Error: ${snapshot.error}"));
  }

  Widget _cargandoWidget(){
    return Center(child: CircularProgressIndicator());
  }

  Widget _noHayDatosWidget(){
    return Center(child: Text("No hay datos"));
  }

  Widget _informacionBloqueo(Bloqueo bloqueo){
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: InkWell(
        onTap: () => _irABloqueoDetalle(bloqueo),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Utils.fromHex("#4F4F4F")),
            borderRadius: BorderRadius.circular(10)
          ),
          // child: ListTile(title: MySubtitle(title: "${Utils.toCurrency(bloqueo.monto)}", fontSize: 15,))
          // child: ListTile(title: Text("${Utils.toCurrency(bloqueo.monto)}",), subtitle: Text("${bloqueo.descripcionLoterias}"),),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: MySubtitle(title: "${Utils.toCurrency(bloqueo.monto)}", fontSize: 18, padding: EdgeInsets.all(0), fontWeight: FontWeight.bold,),
                  ),
                  Visibility(visible: _esBloqueoJugadas() || _esBloqueoJugadasPorBanca(), child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(_jugadas(bloqueo), style: TextStyle(color: Colors.black),),
                  )),
                  Visibility(visible: _esBloqueoPorBancas(), child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(_descripcionOCodigoBanca(bloqueo), style: TextStyle(color: Colors.black),),
                  )),
                  Text("${_descripcionLoterias(bloqueo)}", style: TextStyle(color: Utils.fromHex("#5E5858")),),
                ],
              ),
              IconButton(onPressed: () async {
                bool bloqueoEliminado = await BloqueosService.mostrarDialogEliminarBloqueo(context, _getTipoBloqueo(), bloqueo, _moneda);;
                if(bloqueoEliminado == true)
                  _buscarDatos(true);
              }, icon: Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _irABloqueoDetalle(Bloqueo bloqueo) async {
    if(_esPantallaPequena()){
      if(_esBloqueoPorBanca() || _esBloqueoJugadasPorBanca())
      await Navigator.push(context, MaterialPageRoute(builder: (context){
         return BloqueosVerBancasScreen(
           ids: bloqueo.ids, 
           moneda: _moneda,
           tipoBloqueo: _getTipoBloqueo(),
           monto: bloqueo.monto,
          );
       }));
      else
        await Navigator.push(context, MaterialPageRoute(builder: (context){
          return BloqueosDetalleScreen(
            ids: bloqueo.ids, 
            moneda: _moneda,
            tipoBloqueo: _getTipoBloqueo(),
            monto: bloqueo.monto,
            );
        }));
    }
  }

  String _jugadas(Bloqueo bloqueo) {
    if(bloqueo.jugadas == null)
      return '';
    if(bloqueo.jugadas.isEmpty)
      return '';
    if(bloqueo.jugadas.indexOf(",") == -1)
        return bloqueo.jugadas;

      List<String> jugadas = bloqueo.jugadas.split(",");
      int posicionPrimeraComa = 0;
      int posicionUltimaComa = jugadas.length - 1;
      jugadas.remove(posicionPrimeraComa);
      jugadas.remove(jugadas[posicionUltimaComa]);
      String jugadasSeparadasPorComa = jugadas.join(", ");
    if(jugadasSeparadasPorComa.length > 35)
      return jugadasSeparadasPorComa.substring(0, 35)  + "...";
    else 
      return jugadasSeparadasPorComa;
  }

  _descripcionOCodigoBanca(Bloqueo bloqueo){
    return _esBloqueoJugadas() ? _descripcionBancas(bloqueo) : _codigoBancas(bloqueo);
  }

  String _descripcionBancas(Bloqueo bloqueo) {
    if(bloqueo.descripcionBancas == null)
      return '';
    if(bloqueo.descripcionBancas.length > 45)
      return bloqueo.descripcionBancas.substring(0, 45)  + "...";
    else 
      return bloqueo.descripcionBancas;
  }

  String _codigoBancas(Bloqueo bloqueo) {
    if(bloqueo.codigoBancas == null)
      return '';
    if(bloqueo.codigoBancas.length > 45)
      return bloqueo.codigoBancas.substring(0, 45)  + "...";
    else 
      return bloqueo.codigoBancas;
  }
  
  String _descripcionLoterias(Bloqueo bloqueo) {
    if(bloqueo.descripcionLoterias.length > 45)
      return bloqueo.descripcionLoterias.substring(0, 45)  + "...";
    else 
      return bloqueo.descripcionLoterias;
  }

  _esBloqueoPorBancas(){
    return _esBloqueoJugadasPorBanca() || _esBloqueoPorBanca();
  }

  _esBloqueoPorBanca(){
    return _getTipoBloqueo() == TipoBloqueo.porBancas;
  }

  _esBloqueoJugadas(){
    return _getTipoBloqueo() == TipoBloqueo.jugadas;
  }

  _esBloqueoJugadasPorBanca(){
    return _getTipoBloqueo() == TipoBloqueo.jugadasPorBanca;
  }

  _getTipoBloqueo(){
    if(_tabController.index == 1)
      return TipoBloqueo.porBancas;
    if(_tabController.index == 2)
      return TipoBloqueo.jugadas;
    if(_tabController.index == 3)
      return TipoBloqueo.jugadasPorBanca;
    return TipoBloqueo.general;
  }

  bool _esPantallaPequena(){
    return _isSmallOrMedium;
  }

}