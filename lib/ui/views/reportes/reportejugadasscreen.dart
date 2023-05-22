import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/views/reportes/filtrarreportejugadasscree.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mycontainerradio.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicons/unicons.dart';

import '../../widgets/mycirclebutton.dart';
import '../../widgets/showmyoverlayentry.dart';

class ReporteJugadasScreen extends StatefulWidget {
  @override
  _ReporteJugadasScreenState createState() => _ReporteJugadasScreenState();
}

class _ReporteJugadasScreenState extends State<ReporteJugadasScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _myFilterKey = GlobalKey<MyFilter2State>();
  ValueNotifier<Loteria> groupValue = ValueNotifier<Loteria>(null);
  bool _mostrarFiltro = false;
  bool _isSmallOrMedium = true;

  StreamController<List<Draws>> _streamController;
  StreamController<List<Loteria>> _streamControllerLoteria;
  bool _cargando = false;
  DateTime _fechaActual = DateTime.now();
  DateTime _fechaInicial;
  DateTime _fechaFinal;
  List<Loteria> listaLoteria = [];
  List<Draws> listaSorteo = [];
  List<Moneda> listaMoneda = [];
  List<Jugada> listaJugada = [];
  List<Grupo> listaGrupo = [];
  List<Banca> listaBanca = [];
  Loteria _loteria;
  Draws _sorteo;
  Moneda _moneda;
  Banca _banca;
  Grupo _grupo;
  String _jugada;
  List<int> listaLimite = [20, 30, 50, 100];
  int _limite = 20;
  DateTimeRange _date;
  int _idGrupoDeEsteUsuario;
  List<MyFilterData2> listaFiltro = [];
  List<MyFilterSubData2> _filtros = [];
  List<String> listaOrden = ["Por monto", "Por jugada"];
  String _selectedOrden;
  Future _futureData;
  
 

  _init() async {
    // setState(() => _cargando = true);
    _selectedOrden = listaOrden[0];
    _date = MyDate.getTodayDateRange();
    _idGrupoDeEsteUsuario = await Db.idGrupo();
    var parsed = await ReporteService.jugadas(context: context, scaffoldKey: _scaffoldKey, fechaInicial: _fechaInicial, fechaFinal: _fechaFinal, retornarLoterias: true, retornarSorteos: true, retornarMonedas: true, retornarBancas: true, retornarGrupos: true, idGrupo: _idGrupoDeEsteUsuario);
    print("ReporteJugadasScreen _init: $parsed");
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((e) => Loteria.fromMap(e)).toList() : [];
    listaLoteria.insert(0, Loteria(id: 0, descripcion: 'Todas'));
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((e) => Draws.fromMap(e)).toList() : [];
    listaSorteo.insert(0, Draws(0, 'Todos', null, null, null, null));
    listaJugada = (parsed["data"] != null) ? parsed["data"].map<Jugada>((e) => Jugada.fromMap(e)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((e) => Moneda.fromMap(e)).toList() : [];
    listaGrupo = (parsed["grupos"] != null) ? parsed["grupos"].map<Grupo>((e) => Grupo.fromMap(e)).toList() : [];
    listaGrupo.insert(0, Grupo(id: 0, descripcion: 'Todos'));
    listaBanca = (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((e) => Banca.fromMap(e)).toList() : [];
    listaBanca.insert(0, Banca.getBancaTodas);
    
    _moneda = (listaMoneda.length > 0) ? listaMoneda[0] : null;
    if(_idGrupoDeEsteUsuario != null){
      if(listaGrupo.length > 0)
        _grupo = listaGrupo.firstWhere((element) => element.id == _idGrupoDeEsteUsuario, orElse: () => null);
    }
    
    _streamController.add(listaSorteo);
    _streamControllerLoteria.add(listaLoteria);
    // setState(() => _cargando = false);
  }

 
  _filtrar() async {
    try {
      print("_filtrar fechaInicial: ${_fechaInicial.toString()}");
      print("_filtrar fechaFinal: ${_fechaFinal.toString()}");
      // return;
      _streamController.add(null);
      var parsed = await ReporteService.jugadas(context: context, scaffoldKey: _scaffoldKey, fechaInicial: _date.start, fechaFinal: _date.end, loteria: _loteria, sorteo: _sorteo, jugada: _jugada, moneda: _moneda, banca: _banca, idGrupo: _grupo != null ? _grupo.id : null, limite: _limite);
      listaJugada = (parsed["data"] != null) ? parsed["data"].map<Jugada>((e) => Jugada.fromMap(e)).toList() : [];
      _streamController.add(listaSorteo);
    } on Exception catch (e) {

          // TODO
    }

  }

  _onChanged(data){
    groupValue.value = data;
    // setState(() => groupValue = data);
  }
  
  _bancaChanged(data){
    setState((){
        _banca = data.id != 0 ? data : null;
        _filtrar();
      });
  }

  _loteriaChanged(data){
    setState((){
        _loteria = data.id != 0 ? data : null;
        _filtrar();
      });
  }

  _grupoChanged(data){
    setState((){
        _grupo = data.id != 0 ? data : null;
        _filtrar();
      });
  }

  _monedaChanged(data){
    setState((){
        _moneda = data;
        _filtrar();
      });
  }

 


  _drawsBackground(String sorteo){
    Color color = Utils.colorPrimary;
    // switch (sorteo) {
    //   case "Directo":
    //     color = Colors.green;
    //     break;
    //   case "Pale":
    //     color = Colors.pink;
    //     break;
    //   case "Tripleta":
    //     color = Colors.blue;
    //     break;
    //   default:
    //     color = Colors.blueGrey;
    // }

    return color;
  }

 
  _myFilterWidget(bool isSmallOrMedium){
    return MyFilterV2(
                    item: [
                      MyFilterItem(
                        color: Colors.blue[800],
                        hint: "${_loteria != null ? 'Loteria:  ' + _loteria.descripcion: 'Loteria...'}", 
                        data: listaLoteria.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _loteriaChanged(value);
                        }
                      ),
                      MyFilterItem(
                        color: Colors.blue[800],
                        hint: "${_banca != null ? 'Banca:  ' + _banca.descripcion: 'Banca...'}", 
                        data: listaBanca.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _bancaChanged(value);
                        }
                      ),
                      MyFilterItem(
                        enabled: _idGrupoDeEsteUsuario == null,
                        color: Colors.blue[800],
                        hint: "${_grupo != null ? 'Grupo:  ' + _grupo.descripcion: 'Grupo...'}", 
                        data: listaGrupo.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _grupoChanged(value);
                        }
                      ),
                      MyFilterItem(
                        color: Colors.green[700],
                        hint: "${_moneda != null ? 'Moneda:  ' + _moneda.descripcion: 'Moneda...'}", 
                        data: listaMoneda.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _monedaChanged(value);
                        }
                      ),
                    ],
                  );
    
    return MyFilter2(
            key: _myFilterKey,
            xlarge: 1.1,
            large: 1.1,
            medium: 1,
            small: 1,
            leading: 
            !isSmallOrMedium
            ?
            null
            :
            _filtros.length == 0
            ?
            SizedBox.shrink()
            :
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    _back(){
                      Navigator.pop(context);
                    }
                    showMyModalBottomSheet(
                      context: context, 
                      myBottomSheet2: MyBottomSheet2(
                        child: MyDateRangeDialog(
                          date: _date,
                          onCancel: _back,
                          onOk: (date){
                            _dateChanged(date);
                            _back();
                          },
                        ), 
                      height: 350
                      )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue[900]),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(child: Text(MyDate.dateRangeToNameOrString(_date), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),),
                    ),
                  ),
                ),
                Container(height: 34, width: 1, color: Colors.grey),
              ],
            )
            ,
            widgetWhenNoFilter: Expanded(
              child: MyFilter(
                filterTitle: '',
                filterLeading: SizedBox.shrink(),
                leading: SizedBox.shrink(),
                value: _date,
                paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                onChanged: _dateChanged,
                showListNormalCortaLarga: 3,
              ),
            ),
            onChanged: (data){
              
              if(data.length == 0){
                setState(() {
                  _filtros = [];
                  _banca = null;
                  _moneda = null; 
                  _grupo = null;
                  _loteria = null;
                  _sorteo = null;
                  _filtrar();
                });
                return;
              }

              _grupo = null;
              _banca = null;
              _moneda = null; 
              _loteria = null;
              _sorteo = null;
              setState(() {
                _filtros = data;
                for (MyFilterSubData2 myFilterSubData2 in data) {
                  print("HistoricoVentas Filter2 for subData: ${myFilterSubData2.type} value: ${myFilterSubData2.value}");
                  if(myFilterSubData2.type == "Banca")
                    _banca = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Moneda")
                    _moneda = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Grupo")
                    _grupo = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Loteria")
                    _loteria = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Sorteo")
                    _sorteo = myFilterSubData2.value;
                }
                _filtrar();
              });
              
            },
            onDelete: (data){
              setState(() {
                if(data.child == "Banca")
                  _banca = null;
                if(data.child == "Grupo")
                  _grupo = null;
                if(data.child == "Moneda" )
                  _moneda = null;
                if(data.child == "Loteria" )
                  _loteria = null;
                if(data.child == "Sorteo" )
                  _sorteo = null;
                for (var element in data.data) {
                  _filtros.remove(element);
                }
                _filtrar();
              });
            },
            onDeleteAll: (values){
              setState((){
                // _selectedFilter = [];
                for (var item in values) {
                  _filtros.removeWhere((element) => element.type == item.child);
                  if(item.child == "Banca")
                    _banca = null;
                  if(item.child == "Grupo")
                    _grupo = null;
                  if(item.child == "Moneda" )
                    _moneda = null;
                  if(item.child == "Loteria" )
                    _loteria = null;
                  if(item.child == "Sorteo" )
                    _sorteo = null;
                }
                _filtrar();
              });
            },
            data: listaFiltro,
            values: _filtros
          );
  
  }

  _myWebFilterScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: esPantallaGrande(),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 50,
                child: _myFilterWidget(isSmallOrMedium),
              ),
            ),
          ),
          Visibility(
            visible: esPantallaGrande(),
            child: MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0, top: 5),)
          ),
      ],
    );
    // Padding(
    //   padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0 : 0, top: 5),
    //   child: Wrap(
    //     alignment: WrapAlignment.start,
    //     crossAxisAlignment: WrapCrossAlignment.center,
    //     children: [
    //       // _mydropdown(),
    //       // MyDropdown(
    //       //   large: 5.8,
    //       //   title: "Filtrar",
    //       //   hint: "${_selectedOption != null ? _selectedOption : 'No hay opcion'}",
    //       //   elements: listaOpciones.map((e) => [e, "$e"]).toList(),
    //       //   onTap: (value){
    //       //     _opcionChanged(value);
    //       //   },
    //       // ),
    //       // MyDropdown(
    //       //   large: 5.8,
    //       //   title: "Grupos",
    //       //   hint: "${_grupo != null ? _grupo.descripcion : 'No hay grupo'}",
    //       //   elements: listaGrupo.map((e) => [e, "$e"]).toList(),
    //       //   onTap: (value){
    //       //     _opcionChanged(value);
    //       //   },
    //       // ),
    //      _myFilterWidget(isSmallOrMedium),
    //       // Padding(
    //       //   padding: EdgeInsets.only(right: 15.0, top: 18.0, bottom: !isSmallOrMedium ? 20 : 0),
    //       //   child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
    //       // ),
    //       MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0, top: 5),),
    //     ],
    //   ),
    // );
  }

 dynamic _dateWidget(bool isSmallOrMedium){
    if(isSmallOrMedium)
    return MyCircleButton(
      child: MyDate.dateRangeToNameOrString(_date), 
      onTap: (){
        _back(){
          Navigator.pop(context);
        }
        showMyModalBottomSheet(
          context: context, 
          myBottomSheet2: MyBottomSheet2(
            child: MyDateRangeDialog(
              date: _date,
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
    );


    return Container(
      width: 180,
      child: Builder(
        builder: (context) {
          return MyDropdown(title: null, 
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            hint: "${MyDate.dateRangeToNameOrString(_date)}",
            onTap: (){
              showMyOverlayEntry(
                context: context,
                right: 20,
                builder: (context, overlay){
                  _cancel(){
                    overlay.remove();
                  }
                  return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){_dateChanged(date); overlay.remove();},);
                }
              );
            },
          );
        }
      ),
    );
              

  }


  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: MyCollapseChanged(
        child: FutureBuilder<void>(
            future: _futureData,
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done)
                return SizedBox.shrink();

              return Row(
                children: [
                _dateWidget(isSmallOrMedium),
                  Expanded(child: _myFilterWidget(isSmallOrMedium))
                ],
              );
            }
          )
        
            // _myFilterWidget(isSmallOrMedium)
          
        ,
      ),
    )
    :
    "Filtre y agrupe todas las ventas por fecha.";
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _filtrar();
    });
  }

  _showFilas(){
    showMyModalBottomSheet(
      context: context,
      myBottomSheet2: MyBottomSheet2(
        height: 320,
        child: Column(
          children: listaLimite.map((e) => CheckboxListTile(title: Text("$e filas"), controlAffinity: ListTileControlAffinity.leading, value: _limite == e, onChanged: (value){setState(() => _limite = e); _filtrar(); Navigator.pop(context);},)).toList(),
        ),
      )
    );
  }


  Widget _avatarWidget(Jugada data){
    return CircleAvatar(
      backgroundColor: _drawsBackground(data.descripcion) ,
      child: Text(_loteria != null ? _loteria.descripcion.substring(0, 1) : "T", style: TextStyle(color: Colors.white),),
    );
  }

  Widget _montoYPremioWidget(Jugada data){
    return (data.premio <= 0)
          ?
      Text(Utils.toCurrency(data.monto), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
          :
      Column(
        children: [
          Text(Utils.toCurrency(data.monto), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
          Text(Utils.toCurrency(data.premio), style: TextStyle(color: Colors.pink, fontSize: 16),),
        ],
      );
  }

  Widget _jugadasWidget(List<Jugada> data, Draws draw){
    return Column(
      children: data.asMap().map((key, e){
        Widget listTile = ListTile(
          leading: _avatarWidget(e),
          trailing: _montoYPremioWidget(e),
          title: Text("${Utils.agregarSignoYletrasParaImprimir(e.jugada, draw.descripcion)}", style: TextStyle(fontWeight: FontWeight.w700),),
          subtitle: RichText(text: TextSpan(
              style: TextStyle(color: Colors.grey),
              children: [
                // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
                TextSpan(text: "${e.cantidadVecesQueSeHaJugado != null ? 'Jugado ' + e.cantidadVecesQueSeHaJugado.toString() : ''} ${e.cantidadVecesQueSeHaJugado != null ? e.cantidadVecesQueSeHaJugado == 1 ? 'vez' : 'veces' : ''}"),
                TextSpan(text: "${e.cantidadVecesQueHaSalido != null ? '  |  Salido ' + e.cantidadVecesQueHaSalido.toString() : ''} ${e.cantidadVecesQueHaSalido != null ? e.cantidadVecesQueHaSalido == 1 ? 'vez' : 'veces' : ''}"),
              ]
          )),
        );

        if(key == 0)
          return MapEntry<dynamic, Widget>(key, Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 13),
                // child: MySubtitle(title: draw.descripcion),
                child: Row(
                  children: [
                    Text(draw.descripcion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Text("${data.length}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
              listTile
            ],
          ));

        return MapEntry<dynamic, Widget>(key, listTile);
      }).values.toList(),
    );
  }

  _ordenChanged(orden){
    _selectedOrden = orden;
    _streamController.add(listaSorteo);
  }


  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    _streamController = BehaviorSubject();
    _streamControllerLoteria = BehaviorSubject();
    _fechaInicial = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 00:00");
    _fechaFinal = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 23:59:59");
    _futureData = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    _isSmallOrMedium = isSmallOrMedium;
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      reporteJugadas: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Reporte jugadas",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 80,
          actions: [
            MySliverButton(
              title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                // width: 52,
                // color: Colors.grey[100],
                child: InkWell(
                      onTap: _showFilas,
                      child: Row(children: [
                        Text("${_limite != null ? _limite.toString() + ' filas' : ''}", style: TextStyle(color: Colors.black),),
                        Icon(Icons.arrow_drop_down, color: Colors.black)
                      ],),
                    ),
              ),
            ),
              onTap: (){}
            ),
            MySliverButton(
              showOnlyOnSmall: true,
              title: "Filtro", 
              iconWhenSmallScreen: Icons.filter_alt_rounded, 
              onTap: (){
                _myFilterKey.currentState.openFilter(context);
              }
            )
          ],
        ), 
        sliver: StreamBuilder<List<Draws>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null)
            return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );

            if(listaJugada.length == 0)
                return SliverFillRemaining(child: Column(
                  children: [
                    _myWebFilterScreen(isSmallOrMedium),
                    Center(child: MyEmpty(title: "No hay jugadas realizadas", icon: Icons.format_list_numbered_rounded, titleButton: "No hay jugadas",)),
                  ],
                ));

            return SliverList(delegate: SliverChildBuilderDelegate(
                (context, index){
                  var lista = listaJugada.where((element) => element.idSorteo == snapshot.data[index].id).toList();
                  if(_selectedOrden == "Por monto")
                    lista.sort((b, a) => a.monto.compareTo(b.monto));
                  else
                    lista.sort((element, value) => element.jugada.compareTo(value.jugada));

                  if(index == 0)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _myWebFilterScreen(isSmallOrMedium),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                          child: MyDropdown(
                              small: 1.3,
                              color: Colors.grey[100],
                              textColor: Colors.black,
                              leading: Icon(Icons.low_priority, color: Colors.black),
                              elements: listaOrden.map((e) => [e, e]).toList(),
                              hint: "Ordenado por: ${_selectedOrden ?? ''}",
                              onTap: _ordenChanged
                          ),
                        ),
                        _jugadasWidget(lista, snapshot.data[index]),
                      ],
                    );
                  return _jugadasWidget(lista, snapshot.data[index]);
                },
              childCount: snapshot.data.length
            ));
            return SliverFillRemaining(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  var lista = listaJugada.where((element) => element.idSorteo == snapshot.data[index].id).toList();
                  return Column(
                    children: lista.asMap().map((key, e){
                      Widget listTile = ListTile(
                      leading: _avatarWidget(e),
                      trailing: _montoYPremioWidget(e),
                      title: Text("${Utils.agregarSignoYletrasParaImprimir(e.jugada, snapshot.data[index].descripcion)}", style: TextStyle(fontWeight: FontWeight.w700),),
                      subtitle: RichText(text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        children: [
                          // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
                          TextSpan(text: "${e.cantidadVecesQueSeHaJugado != null ? 'Jugado ' + e.cantidadVecesQueSeHaJugado.toString() : ''} ${e.cantidadVecesQueSeHaJugado != null ? e.cantidadVecesQueSeHaJugado == 1 ? 'vez' : 'veces' : ''}"),
                          TextSpan(text: "${e.cantidadVecesQueHaSalido != null ? '  |  Salido ' + e.cantidadVecesQueHaSalido.toString() : ''} ${e.cantidadVecesQueHaSalido != null ? e.cantidadVecesQueHaSalido == 1 ? 'vez' : 'veces' : ''}"),
                        ]
                      )),
                    );

                    if(key == 0)
                      return MapEntry<dynamic, Widget>(key, Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: MySubtitle(title: snapshot.data[index].descripcion),
                          ),
                          listTile
                        ],
                      ));

                      return MapEntry<dynamic, Widget>(key, listTile);
                    }).values.toList(),
                  );
                }
              ),
            );

            
          }
        )
      )
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // appBar: AppBar(
      //     leading: BackButton(
      //       color: Utils.colorPrimary,
      //     ),
      //     title: Text("Jugadas", style: TextStyle(color: Colors.black)),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     actions: <Widget>[
      //        Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: SizedBox(
      //                 width: 30,
      //                 height: 30,
      //                 child: Visibility(
      //                   visible: _cargando,
      //                   child: Theme(
      //                     data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
      //                     child: new CircularProgressIndicator(),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: _guardar, color: Utils.colorPrimary,),
      //         // ElevatedButton(child: Text("Guardar"), 
      //         // onPressed: _guardar,
      //         // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utils.colorPrimary)),)
      //     ],
      //   ),
      body: SafeArea(child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: StreamBuilder(
              stream: _streamControllerLoteria.stream,
              builder: (context, snapshot){
                return GestureDetector(
                  // onTap: _showBottomSheetLoteria,
                  onTap: (){},
                  child: Row(
                    children: [
                      Flexible(child: Text("${_loteria != null ? _loteria.descripcion : 'No hay loterias'}", softWrap: true, style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_drop_down, color: Colors.black54,)
                    ],
                  ),
                );
               
                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      items: (snapshot.hasData) ? listaLoteria.map((e) => DropdownMenuItem(child: Text(e.descripcion), value: e,)).toList() : []
                    ),
                  ),
                  
                  );
                // return MyDropdownButton(
                //   isExpanded: false,
                //   withScreenSize: false,
                //   items: (snapshot.hasData) ? listaLoteria.map((e) => [e, e.descripcion]).toList() : [],
                //   onChanged: (data){

                //   },
                // );
              },
            ),
            leading: BackButton(
              color: Utils.colorPrimary,
            ),
            backgroundColor: Colors.white,
            actions: [
              // TextButton(onPressed: _showBottomSheetMoneda, child: Text("${_moneda != null ? _moneda.abreviatura : ''}", style: TextStyle(color: (_moneda != null) ? Utils.fromHex(_moneda.color) : Utils.colorPrimary))),
              // IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: _filtroScreen, color: Utils.colorPrimary,),
            ],
            // expandedHeight: (_getListaFiltro().length == 0) ? 150 : 238,
            floating: true,
            pinned: true,
            flexibleSpace: 
            
            FlexibleSpaceBar(
              // alignment: Alignment.bottomRight,
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                  Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
                          child: Icon(Icons.date_range, color: Colors.grey,),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: 
                              Row(
                                children: MyDate.listaFecha.map((e) =>  Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  // child: MyContainerButton(selected: e[0] == _fecha, data: [e[0], e[1]], onTap: (data){
                                  child: MyContainerButton(selected: e[0], data: [e[0], e[1]], onTap: (data){
                                    setState((){
                                      // _fecha = e[0];
                                      _filtrar();
                                    });
                                  },),
                                )).toList(),
                              )
                              // Row(
                              //   children: [
                              //     Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(selected: _fecha, data: ["Hoy", "Hoy"], onTap: (data){
                              //       print("$data");
                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["Esta semana", "Esta semana"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["La semana pasada", "La semana pasada"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   ],
                              // ),
                              
                              // children: [
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                              //       print("$data");
                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  // _getListaFiltro().length == 0
                  0 == 0
                  ?
                  SizedBox()
                  :
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text("No")
                    // MyFilter(title: "Filtros", data: _getListaFiltro(), onDeleteAll: _deleteAllFilter,),
                  ),
                  
                ],
              ),
            
            ),
            
            
            
          ),
          StreamBuilder<List<Draws>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if(snapshot.data == null)
                      return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

              if(listaJugada.length == 0)
                return SliverFillRemaining(child: MyEmpty(title: "No hay jugadas realizadas", icon: Icons.format_list_numbered_rounded, titleButton: "No hay jugadas",));

              return SliverList(delegate: SliverChildBuilderDelegate((context, index){
                var lista = listaJugada.where((element) => element.idSorteo == snapshot.data[index].id).toList();
                return 
                lista.length == 0
                ?
                SizedBox()
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Divider(thickness: 1,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(snapshot.data[index].descripcion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    ),
                    Column(
                      children: lista.map((e) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _drawsBackground(snapshot.data[index].descripcion) ,
                        child: Text(_loteria.descripcion.substring(0, 1), style: TextStyle(color: Colors.white),),
                      ),
                      trailing: 
                      (e.premio <= 0)
                      ?
                      Text(Utils.toCurrency(e.monto), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
                      :
                      Column(
                        children: [
                          Text(Utils.toCurrency(e.monto), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
                          Text(Utils.toCurrency(e.premio), style: TextStyle(color: Colors.pink, fontSize: 16),),
                        ],
                      ),
                      title: Text("${Utils.agregarSignoYletrasParaImprimir(e.jugada, snapshot.data[index].descripcion)}", style: TextStyle(fontWeight: FontWeight.w700),),
                      subtitle: RichText(text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        children: [
                          // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
                          TextSpan(text: "${e.cantidadVecesQueSeHaJugado != null ? 'Jugado ' + e.cantidadVecesQueSeHaJugado.toString() : ''} ${e.cantidadVecesQueSeHaJugado != null ? e.cantidadVecesQueSeHaJugado == 1 ? 'vez' : 'veces' : ''}"),
                          TextSpan(text: "${e.cantidadVecesQueHaSalido != null ? '  |  Salido ' + e.cantidadVecesQueHaSalido.toString() : ''} ${e.cantidadVecesQueHaSalido != null ? e.cantidadVecesQueHaSalido == 1 ? 'vez' : 'veces' : ''}"),
                        ]
                      )),
                    )).toList(),
                    )
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: DataTable(
                    //         columns: [DataColumn(label: Text("Jugada")), DataColumn(label: Text("Monto")), DataColumn(label: Text("Premio"))],
                    //         rows: lista.map((e) => DataRow(cells: [DataCell(Text(e.jugada)), DataCell(Text("RD\$${e.monto}")), DataCell(Text("RD\$${e.premio}"))])).toList(),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    
                    // Expanded(
                    //   flex: 1,
                    //   child: Container(
                    //     height: 100,
                    //     child: SingleChildScrollView(
                    //       child: Column(
                    //         children: lista.map((e) =>  ListTile(
                    //           title: Text(lista[index].jugada),
                    //         )).toList(),
                    //       ),
                    //     )
                    //     // ListView.builder(
                    //     //   shrinkWrap: true,
                    //     //   itemCount: lista.length,
                    //     //   itemBuilder: (context, index){
                    //     //     return ListTile(
                    //     //       title: Text(lista[index].jugada),
                    //     //     );
                    //     //   },
                    //     // ),
                    //   ),
                    // )
                  ],
                );
              }, childCount: snapshot.data.length));
              
              return SliverFillRemaining(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                //   child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700),),
                // ),
                // Row(
                //   children: [
                //     Icon(Icons.date_range, size: 35, color: Colors.grey,),
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 14.0),
                //         child: SingleChildScrollView(
                //           scrollDirection: Axis.horizontal,
                //           child: Row(
                //             children: [
                //               Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                //                 print("$data");
                //               },),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                //                 print("$data");

                //               },),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["Esta semana", "Esta semana"], onTap: (data){
                //                 print("$data");

                //               },),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["La semana pasada", "La semana pasada"], onTap: (data){
                //                 print("$data");

                //               },),
                //             ),
                //             ],
                //           ),
                //           // children: [
                //           //   Padding(
                //           //     padding: const EdgeInsets.all(8.0),
                //           //     child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                //           //       print("$data");
                //           //     },),
                //           //   ),
                //           //   Padding(
                //           //     padding: const EdgeInsets.all(8.0),
                //           //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                //           //       print("$data");

                //           //     },),
                //           //   ),
                //           // ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                //   child: Divider(thickness: 1,),
                // ),
                StreamBuilder<List<Draws>>(
                  stream: _streamController.stream,
                  builder: (context, snapshot){
                    if(snapshot.data == null)
                      return Center(child: CircularProgressIndicator(),);

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            Text(snapshot.data[index].descripcion, style: TextStyle(fontSize: 20),),
                            // ListView.builder(itemBuilder: itemBuilder)
                          ],
                        );
                      },
                    );
                  },
                )
              ],),
        ),
      
              );
            }
          )
        ],
      )),
    );
  }

  bool esPantallaGrande(){
    return !_isSmallOrMedium;
  }
}