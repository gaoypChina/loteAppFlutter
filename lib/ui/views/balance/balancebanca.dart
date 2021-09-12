import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/services/balanceservice.dart';
import 'package:loterias/ui/views/balance/balancebancassearch.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:rxdart/rxdart.dart';

class BalanceBancaScreen extends StatefulWidget {
  @override
  _BalanceBancaScreenState createState() => _BalanceBancaScreenState();
}

class _BalanceBancaScreenState extends State<BalanceBancaScreen> {
  var _txtSearch = TextEditingController();
  GlobalKey<MyFilter2State> _myFilterKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Banca>> _streamControllerBancas;
  StreamController<List<Banca>> _streamControllerTabla;
  List<Banca> listaBanca = [];
  List<Banca> listaDinamicaBanca = [];
  int _indexBanca = 0;
  bool _cargando = false;
  bool _onCreate = true;
  DateTime _fechaHasta = DateTime.now();
  List<MyFilterSubData2> _selectedFilter = [];
  List<MyFilterData2> listaFiltros = [];
  DateTimeRange _date;
  MyDate _fecha = MyDate.hoy;
  int _idGrupoDeEsteUsuario;
  List<Grupo> listaGrupo = [];
  List<Grupo> _grupos = [];
  List<Banca> _bancas = [];

  

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerBancas = BehaviorSubject();
    _streamControllerTabla = BehaviorSubject();
    _date = MyDate.getTodayDateRange();
    _getBancas();
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft,
    // ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _streamControllerBancas.close();
    _streamControllerTabla.close();
    super.dispose();

  }

  _getBancas() async {
    try{
      // setState(() => _cargando = true);
      if(!_onCreate){
        _streamControllerTabla.add(null);
      }
      if(_onCreate){
        _idGrupoDeEsteUsuario = await Db.idGrupo();
      }

      var parsed = await BalanceService.bancas(fechaHasta: _fechaHasta, scaffoldKey: _scaffoldKey, idGrupos: _idGrupoDeEsteUsuario != null ? [_idGrupoDeEsteUsuario] : _grupos.map((e) => e.id).toList());
        print("BalanceBancas _GetBancas parsed: ${parsed}");
      if(_onCreate && parsed != null){
        listaBanca = parsed["bancas"] != null ? parsed["bancas"].map<Banca>((e) => Banca.fromMap(e)).toList() : [];
        // listaBanca.forEach((element) {print("BalanceBancas bancasBalance: ${element.codigo} ${element.balance}");});
        // for (var item in listaBanca) {
        //   print("BalanceBanca _getBanca bancasBalance: ${item.descripcion} ${item.balance}");
        // }
        listaGrupo = parsed["grupos"] != null ? parsed["grupos"].map<Grupo>((e) => Grupo.fromMap(e)).toList() : [];
        // listaBanca.insert(0, Banca(id: 0, descripcion: "Todas las bancas"));
        _streamControllerBancas.add(listaBanca);
        _streamControllerTabla.add(listaBanca);
        _onCreate = false;

        
        if(listaGrupo.length > 0){
          var filtroGrupo = MyFilterData2(child: "Grupo", isMultiple: true, fixed: _idGrupoDeEsteUsuario != null, enabled: _idGrupoDeEsteUsuario == null, data: listaGrupo.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList());
          listaFiltros.add(filtroGrupo);
          if(_idGrupoDeEsteUsuario != null){
            setState(() {
              _selectedFilter.add(filtroGrupo.data.firstWhere((element) => element.value.id == _idGrupoDeEsteUsuario, orElse: () => null));
            });
            _grupos = listaGrupo.where((element) => element.id == _idGrupoDeEsteUsuario).toList();
          }
        }
      }else{
        listaDinamicaBanca = parsed["bancas"] != null ? parsed["bancas"].map<Banca>((e) => Banca.fromMap(e)).toList() : [];
        // listaDinamicaBanca = List<Banca>.from(listaBanca);
        _streamControllerTabla.add(listaDinamicaBanca);
        // _filterTable();
      }
      
      // setState(() => _cargando = false);
    }on Exception catch(e){
      // setState(() => _cargando = false);
        _streamControllerTabla.add([]);

    }
  }

  _filterTable(){
    if(listaBanca[_indexBanca].descripcion == "Todas las bancas")
      _streamControllerTabla.add(listaDinamicaBanca);
    else
      _streamControllerTabla.add(listaDinamicaBanca.where((b) => b.descripcion == listaBanca[_indexBanca].descripcion).toList());
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _getBancas();
    });
  }

  _myFilterWidget(bool isSmallOrMedium){
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
            _selectedFilter.length == 0
            ?
            SizedBox.shrink()
            :
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

                  if(date != null)
                    setState(() {
                      _date = DateTimeRange(
                        start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
                        end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
                      );
                      _getBancas();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue[900]),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
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
                showListNormalCortaLarga: 2,
              ),
            ),
            onChanged: (data){
              
              if(data.length == 0){
                setState(() {
                  _selectedFilter = [];
                  _bancas = [];
                  _grupos = [];
                  _getBancas();
                });
                return;
              }

              _grupos = [];
              _bancas = [];
              setState(() {
                _selectedFilter = data;
                for (MyFilterSubData2 myFilterSubData2 in data) {
                  print("HistoricoVentas Filter2 for subData: ${myFilterSubData2.type} value: ${myFilterSubData2.value}");
                  if(myFilterSubData2.type == "Banca")
                    _bancas.add(myFilterSubData2.value);
                  if(myFilterSubData2.type == "Grupo")
                    _grupos.add(myFilterSubData2.value);
                }
                _getBancas();
              });
              
            },
            onDelete: (data){
              setState(() {
                if(data.child == "Banca")
                  _bancas = [];
                if(data.child == "Grupo")
                  _grupos = [];
                for (var element in data.data) {
                  _selectedFilter.remove(element);
                }
                _getBancas();
              });
            },
            onDeleteAll: (values){
              setState((){
                // _selectedFilter = [];
                for (var item in values) {
                  _selectedFilter.removeWhere((element) => element.type == item.child);
                  if(item.child == "Banca")
                  _bancas = [];
                  if(item.child == "Grupo")
                    _grupos = [];
                }
                _getBancas();
              });
            },
            data: listaFiltros,
            values: _selectedFilter
          );
  
  }


  Widget _buildTableBancas(List<Banca> map, bool isSmallOrMedium){
   var tam = (map != null) ? map.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
   }else{
    //  rows = map.asMap().map((idx, b)
    //       => MapEntry(
    //         idx,
    //         TableRow(
              
    //           children: [
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx),
    //               child: Center(
    //                 child: InkWell(onTap: (){}, child: Text(b.descripcion, style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)))
    //               ),
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("${b.usuario.usuario}", style: TextStyle(fontSize: 16)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("${b.dueno}", style: TextStyle(fontSize: 16)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: (b.balance >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
    //               child: Center(child: Text("${Utils.toCurrency(b.balance)}", style: TextStyle(fontSize: 16)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("0", style: TextStyle(fontSize: 16)))
    //             ),
                
    //           ],
    //         )
    //       )
        
    //     ).values.toList();
        
    // rows.insert(0, 
    //           TableRow(
    //             decoration: BoxDecoration(color: Utils.colorPrimary),
    //             children: [
    //               // buildContainer(Colors.blue, 50.0),
    //               // buildContainer(Colors.red, 50.0),
    //               // buildContainer(Colors.blue, 50.0),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Dueño', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Prestamo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               // Padding(
    //               //   padding: const EdgeInsets.all(8.0),
    //               //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               // ),
    //             ]
    //           )
    //           );

    // var total = map.map((e) => e.balance).toList().reduce((value, element) => value + element);
    // rows.add(
    //           TableRow(
    //             // decoration: BoxDecoration(color: Utils.colorPrimary),
    //             children: [
    //               // buildContainer(Colors.blue, 50.0),
    //               // buildContainer(Colors.red, 50.0),
    //               // buildContainer(Colors.blue, 50.0),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Totales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('${Utils.toCurrency(total)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: total >= 0 ? Utils.colorPrimary : Colors.pink)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('${Utils.toCurrency(0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
    //               ),
    //               // Padding(
    //               //   padding: const EdgeInsets.all(8.0),
    //               //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               // ),
    //             ]
    //           )
    //           );
        
   }

  //  return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Table(
  //             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //             columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
  //             children: rows,
  //            ),
  //       );

  if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: 
          map.asMap().map((key, e){
            var valueNotify = ValueNotifier<bool>(false);
            return MapEntry(
              key,
              key == 0
              ?
              Column(
                children: [
                  Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // color: Colors.amber,
                          color: Colors.yellow[100],
                          child: ListTile(
                            leading: Text('ID'),
                            title: Text('Banca'),
                            trailing: Text('Balance'),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Text("${key + 1}"),
                      title: Text("${e.descripcion}"),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${e.dueno}"),
                          Text("${e.usuario != null ? e.usuario.usuario : ''}"),
                        ],
                      ),
                      // onTap: (){_agregarOEditar(data: e);},
                      trailing: Text("${Utils.toCurrency(e.balance)}"),
                    ),
                  ),
                ],
              )
              
              :
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Text("${key + 1}"),
                  title: Text("${e.descripcion}"),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${e.dueno}"),
                      Text("${e.usuario != null ? e.usuario.usuario : ''}"),
                    ],
                  ),
                  // onTap: (){_agregarOEditar(data: e);},
                  trailing: Text("${Utils.toCurrency(e.balance)}"),
                ),
              )
            );
          }).values.toList()
          // snapshot.data.map((e) => ListTile(
          //   leading: _avatarScreen(e),
          //   title: Text("${e.descripcion}"),
          //   isThreeLine: true,
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("${e.abreviatura}"),
          //       // Text("${e.sorteos}"),
          //     ],
          //   ),
          //   onTap: (){_agregarOEditar(data: e);},
          //   trailing: Row(
          //     children: [
          //       ValueListenableBuilder<bool>(
          //         valueListenable: valueNotify,
          //         builder: (context, value, __) {
          //           return Row(
          //             children: [
          //               Checkbox(value: e.pordefecto == 1, onChanged: (value) async {
          //                 try {
          //                   valueNotify.value = !valueNotify.value;
          //                   var parsed = await MonedasService.pordefecto(context: context, data: e);
          //                   listaData = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
          //                   valueNotify.value = false;
          //                   _streamController.add(listaData);
          //                 } on Exception catch (e) {
          //                   valueNotify.value = false;
          //                 }
          //               }),
          //               Visibility(visible: value, child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator()))
          //             ],
          //           );
          //         }
          //       ),
          //       IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          //     ],
          //   ),
          // )).toList(),
        ),
      );
    }

  return MyTable(
    showColorWhenImpar: true,
      bottom: ["", "",
        Center(child: Text("Totales", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
        Center(child: Text(Utils.toCurrency(map.map((e) => e.balance).toList().reduce((value, element) => (value != null ? value : 0) + (element != null ? element : 0)).toString()), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
        // Center(child: Text(Utils.toCurrency("0"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
      ],
      columns: [
        Center(child: Text("Banca", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
        Center(child: Text("Usuario", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
        Center(child: Text("Dueño", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
        Center(child: Text("Balance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
        // Center(child: Text("Prestamo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), 
      ], 
      rows: map.map((e) => [
        e, 
        e.descripcion, 
        e.usuario != null ? e.usuario.usuario : '', 
        e.dueno, 
        MyTableCell(
          value: e,
          color: (Utils.toDouble(e.balance.toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
          child: Center(child: Text("${Utils.toCurrency(e.balance.toString())}", style: TextStyle(fontWeight: FontWeight.bold))),
          // padding: EdgeInsets.symmetric(vertical: 5),
        ),  
        // '0'
      ]).toList()
    );

  return Flexible(
      child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{2 : FractionColumnWidth(.27)},
              children: rows,
             ),
        ),
      ],
    ),
  );
  
 }

Widget _mysearch(){
    return GestureDetector(
      onTap: () async {
          Banca data = await showSearch(context: context, delegate: BalanceBancasSearch(listaBanca));
          if(data == null)
            return;
    
          // _showDialogGuardar(data: data);
        },
      child: MySearchField(
        controller: _txtSearch, 
        enabled: false,
        hint: "", 
        medium: 1, 
        xlarge: 2.6, 
        padding: EdgeInsets.all(0), 
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  } 

 _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    SingleChildScrollView(
      child: MyCollapseChanged(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _myFilterWidget(isSmallOrMedium),
              // _mysearch()
            ]
          ),
        )
        
          
        ,
      ),
    )
    :
    "Filtre y agrupe todas las ventas por fecha.";
  }

_search(String data){
    print("SucursalesSCreen _search: $data");
    if(data.isEmpty)
      _streamControllerTabla.add(listaBanca);
    else
      {
        listaDinamicaBanca = listaBanca.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${listaDinamicaBanca.length}");
        _streamControllerTabla.add(listaDinamicaBanca);
      }
  }

  _gruposString(){
    if(_idGrupoDeEsteUsuario != null){
      Grupo grupo = listaGrupo != null ? listaGrupo.length > 0 ? listaGrupo.firstWhere((element) => element.id == _idGrupoDeEsteUsuario, orElse: () => null) : null : null;
      if(grupo != null)
        return "${grupo.descripcion}";
      else
        return "Seleccionar grupo...";
    }

    return _grupos.length > 0 ? _grupos.map((e) => e.descripcion).toList().join(", ") : "Seleccionar grupo...";
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Balance bancas",
          expandedHeight: isSmallOrMedium ? 105 : 85,
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            MySliverButton(
              title: "", 
              iconWhenSmallScreen: Icons.date_range,
              showOnlyOnSmall: true,
              onTap: () async {
                var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

              if(date != null)
                setState(() {
                  _date = DateTimeRange(
                    start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
                    end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
                  );
                  _getBancas();
                });
              },
            ),
            MySliverButton(
              title: "Buscar", 
              iconWhenSmallScreen: Icons.search_rounded,
              showOnlyOnSmall: true,
              onTap: () async {
                if(isSmallOrMedium){
                  Banca data = await showSearch(context: context, delegate: BalanceBancasSearch(listaBanca));
                  if(data == null)
                    return;
                }
              }
            ),
            MySliverButton(
              title: "title", 
              iconWhenSmallScreen: Icons.filter_alt_rounded,
              showOnlyOnSmall: true,
              onTap: () async {
                if(isSmallOrMedium){
                  _myFilterKey.currentState.openFilter(context);
                }
              }
            ),
          ],
        ),
        sliver: StreamBuilder<List<Banca>>(
                  stream: _streamControllerTabla.stream,
                  builder: (context, snapshot){
                    if(!snapshot.hasData)
                      return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);
                    if(!snapshot.hasData)
                      return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.account_balance_rounded,)),);

                    if(isSmallOrMedium)
                      return SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: _buildTableBancas(snapshot.data, isSmallOrMedium),
                        )
                      );

                    return SliverList(delegate: SliverChildListDelegate([
                      MySubtitle(title: "${snapshot.data.length} Bancas", showOnlyOnLarge: true,),
                      Padding(
                        padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0.0 : 25.0),
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // _mydropdown(),
                            MyDropdown(
                              showOnlyOnLarge: true,
                              title: "Filtrar por grupo",
                              medium: 2.5,
                              hint: "${_gruposString()}",
                              // elements: [["Activado", "Activado"], ["Desactivado", "Desactivado"]],
                              onTap: () async {
                                if(_idGrupoDeEsteUsuario != null)
                                  return;

                                List<Grupo> grupos = await showDialog<List<Grupo>>(
                                  context: context, 
                                  builder: (context){
                                    return MyMultiselect<Grupo>(
                                      title: "Seleccionar grupos",
                                      items: listaGrupo.map((e) => MyValue<Grupo>(child: e.descripcion, value: e)).toList(),
                                      initialSelectedItems: _grupos != null ? _grupos.map((e) => MyValue<Grupo>(value: e, child: e.descripcion)).toList() : [],
                                    );
                                  }
                                );

                                if(grupos == null)
                                  return;

                                if(grupos.length == 0)
                                  setState((){
                                    _grupos = [];
                                    _getBancas();
                                  });

                                setState((){
                                  _grupos = grupos;
                                  _getBancas();
                                });
                                // setState(() => _status = (data == 'Activado') ? 1 : 0);
                              },
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0, top: 18.0),
                                child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
                              ))
                          ],
                        ),
                      ),
                      _buildTableBancas(snapshot.data, isSmallOrMedium)
                    ]));
                  },
                ),
      )
    );
    // return Scaffold(
    //   key: _scaffoldKey,
    //   appBar: AppBar(
    //     title: Text("Balance bancas", style: TextStyle(color: Colors.black),),
    //     leading: BackButton(
    //       color: Utils.colorPrimary,
    //     ),
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     actions: <Widget>[
    //       Column(

    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: SizedBox(
    //               width: 30,
    //               height: 30,
    //               child: Visibility(
    //                 visible: _cargando,
    //                 child: Theme(
    //                   data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
    //                   child: new CircularProgressIndicator(),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   body: SafeArea(
    //     child: Column(
    //       children: <Widget>[
    //         Row(
    //           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: <Widget>[
    //             Expanded(
    //               flex: 2,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: <Widget>[
    //                   Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text("Desde", style: TextStyle(fontSize: 20),),
    //                   ),
    //                   RaisedButton(
    //                     elevation: 0, 
    //                     color: Colors.transparent, 
    //                     shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
    //                     child: Text("${_fechaHasta.year}-${_fechaHasta.month}-${_fechaHasta.day}", style: TextStyle(fontSize: 16)),
    //                     onPressed: () async {
    //                       DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    //                       setState(() => _fechaHasta = (fecha != null) ? fecha : _fechaHasta);
    //                     },
    //                   ),
    //                   RaisedButton(
    //                     elevation: 0,
    //                     color: Utils.fromHex("#e4e6e8"),
    //                     child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
    //                     onPressed: (){
    //                       // _ventas();
    //                       _getBancas();
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //               flex: 1,
    //               child: StreamBuilder<List<Banca>>(
    //                 stream: _streamControllerBancas.stream,
    //                 builder: (context, snapshot){
    //                   if(snapshot.hasData){
    //                     return DropdownButton<Banca>(
    //                       isExpanded: true,
    //                       value: listaBanca[_indexBanca],
    //                       items: listaBanca.map((b) => DropdownMenuItem(
    //                         value: b,
    //                         child: Text("${b.descripcion}"),
    //                       )).toList(),
    //                       onChanged: (Banca banca){
    //                         print("Bancas changed: ${banca.descripcion} - ${banca.id}");
    //                         setState(() {
    //                           _indexBanca = listaBanca.indexWhere((b) => b.descripcion == banca.descripcion);
    //                           if(_indexBanca != -1){
    //                             _filterTable();
    //                           }
    //                         });
    //                       },
    //                     );
    //                   }

    //                   return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
    //                 },
    //               ),
    //             ),
                
    //           ],
    //         ),
    //         StreamBuilder<List>(
    //               stream: _streamControllerTabla.stream,
    //               builder: (context, snapshot){
    //                 if(snapshot.hasData){
    //                   return _buildTableBancas(snapshot.data);
    //                 }
    //                 return Center(child: Text("No hay datos", style: TextStyle(fontSize: 25),));
    //               },
    //             ),
    //       ],
    //     ),
    //   ),
    // );
  
  }
}