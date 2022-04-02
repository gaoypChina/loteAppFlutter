import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/models/branchreport.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/widgets/mycirclebutton.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/mymobiledrawer.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/classes/databasesingleton.dart';
import '../../../core/classes/mydate.dart';
import '../../../core/classes/principal.dart';
import '../../../core/classes/utils.dart';
import '../../../core/services/bancaservice.dart';
import '../../widgets/myalertdialog.dart';
import '../../widgets/mybottomsheet2.dart';
import '../../widgets/mycollapsechanged.dart';
import '../../widgets/mydaterangedialog.dart';
import '../../widgets/myfilterv2.dart';
import '../../widgets/myrich.dart';
import '../../widgets/mysearch.dart';
import '../../widgets/showmymodalbottomsheet.dart';
import '../../widgets/showmyoverlayentry.dart';

class ReporteGeneralScreen extends StatefulWidget {
  final bool showDrawer;
  const ReporteGeneralScreen({ Key key, this.showDrawer = true }) : super(key: key);

  @override
  State<ReporteGeneralScreen> createState() => _ReporteGeneralScreenState();
}

class _ReporteGeneralScreenState extends State<ReporteGeneralScreen> {
  ValueNotifier<bool> _valueNotifierCargandoFiltroBanca = ValueNotifier(false);
  StreamController<Map<String, dynamic>> _streamControllerData;
  StreamController<List<Branchreport>> _streamControllerBanca;
  int idGrupo;
  double ventas = 0;
  List<Grupo> listaGrupo = [];
  List<Moneda> listaMoneda = [];
  List<Branchreport> listaBanca = [];
  List<String> listaFiltro = ["Todas", "Con perdidas", "Con ganancias"];
  Moneda _moneda;
  Grupo _grupo;
  String _filtro;
  Future _future;
  DateTimeRange _date;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _txtSearch = TextEditingController();


  _init() async {
    idGrupo = await Db.idGrupo();
    var parsed = await ReporteService.general(context: context, idGrupo: idGrupo, retornarVentasPremiosComisionesDescuentos: true, retornarGrupos: true, retornarMonedas: true);
    print("ReportegeneralsScreen _init parsed: $parsed");
    listaGrupo = Grupo.fromMapList(parsed["grupos"]);
    listaGrupo.insert(0, Grupo.getGrupoNinguno);
    listaMoneda = Moneda.fromMapList(parsed["monedas"]);
    listaBanca = Branchreport.fromMapList(parsed["bancas"]);
    _filtro = listaFiltro[0];

    if(listaMoneda.length > 0)
      _moneda = listaMoneda[0];

    if(idGrupo != null){
      _grupo = listaGrupo.firstWhere((element) => element.id == idGrupo, orElse: () => null);
    }

    _streamControllerData.add(parsed);
    _streamControllerBanca.add(listaBanca);
  }

  _general([bool soloFiltroBanca = false]) async {
    try {
      if(!soloFiltroBanca)
        _streamControllerData.add(null);
      else
        _valueNotifierCargandoFiltroBanca.value = true;

      var parsed = await ReporteService.general(context: context, moneda: _moneda, idGrupo: idGrupo != null ? idGrupo : _grupo != null ? _grupo.id : null, fechaFinal: _date.start, fechaInicial: _date.end, retornarVentasPremiosComisionesDescuentos: !soloFiltroBanca, filtro: _filtro);
      listaBanca = Branchreport.fromMapList(parsed["bancas"]);
      _streamControllerBanca.add(listaBanca);

      if(!soloFiltroBanca){
        _streamControllerData.add(parsed);
      }
      else
        _valueNotifierCargandoFiltroBanca.value = false;


    } on Exception catch (e) {
      // TODO
       if(!soloFiltroBanca)
        _streamControllerData.add(null);
      else
      _valueNotifierCargandoFiltroBanca.value = false;
    }
  }

  _grupoChanged(Grupo data){
    setState((){_grupo = data; _general();});
    // _dashboard();
  }

  _monedaChanged(Moneda data){
    setState(() {_moneda = data; _general();});
    // _dashboard();
  }

  _dateChanged(DateTimeRange value){
    setState(() {_date = value; _general();});
  }

  _filtroChanged(data){
    setState((){
        _filtro = data;
        _general(true);
     });
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: MyDropdown(
                        title: null, 
                        leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
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
                      ),
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
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SizedBox.shrink();

            return Row(
              children: [
                _dateWidget(isSmallOrMedium),
                Expanded(
                  child: MyFilterV2(
                    item: [
                      MyFilterItem(
                        hint: "${_moneda != null ? 'Moneda: ' + _moneda.abreviatura: 'Moneda...'}", 
                        data: listaMoneda.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _monedaChanged(value);
                        }
                      ),
                      MyFilterItem(
                        enabled: idGrupo == null,
                        hint: "${_grupo != null ? 'Grupo: ' + _grupo.descripcion: 'Grupo...'}", 
                        data: listaGrupo.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _grupoChanged(value);
                        }
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        )
      ),
    )
    :
    "Verifique las ventas resumidas del día seleccionado y maneje sus bancas";
  }



  Widget _roundedWidget({Icon icon, Widget title, String subtitle, bool isSmallOrMedium}){
    return Container(
      padding: EdgeInsets.symmetric(vertical:isSmallOrMedium ? 4.0 : 12.0, horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(children: [
        icon,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              Text(subtitle, style: TextStyle(color: Colors.grey))
            ],
          ),
        )
      ],)
      // ListTile(
      //   // minVerticalPadding: 0.0,
      //   minLeadingWidth: 30,
      //   leading: icon,
      //   title: title,
      //   subtitle: subtitle != null ? Text("$subtitle") : null,
      // ),
    );
  }

  _showDialogDesactivar({Branchreport data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Desactivar", content: MyRichText(text: "Seguro que desea desactivar la banca ", boldText: "${data.descripcion}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  var parsed = await BancaService.desactivar(context: context, id: data.idBanca);
                  
                  setState(() => cargando = false);
                  Navigator.pop(context);
                } on Exception catch (e) {
                  print("_showDialogDesactivar error: $e");
                  setState(() => cargando = false);
                }
              }
            );
          }
        );
      }
    );
  }

  _drawerWidget(){
    return MyMobileDrawer(
      showVender: true,
      scaffoldKey: _scaffoldKey, 
      onTapCerrarSesion: () async {
        // socket.close();
        // socket.dispose();
        await Principal.cerrarSesion(context);
      }
    );
  }

  _monedaScreen(bool isSmallOrMedium){
    return MySliverButton(
      showOnlyOnLarge: true,
      onTap: null,
      title: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // if(isSmallOrMedium)
          //   return TextButton(onPressed: _showBottomSheetMoneda, child: Text("${_moneda != null ? _moneda.abreviatura : ''}", style: TextStyle(color: (_moneda != null) ? Utils.fromHex(_moneda.color) : Utils.colorPrimary)));
        
          if(snapshot.connectionState !=  ConnectionState.done)
            return SizedBox();

          return Container(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: MyDropdown(
                maxLengthToEllipsis: 10,
                title: null,
                textColor: Colors.grey[600],
                color: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                isFlat: true,
                hint: "${_moneda != null ? _moneda.descripcion : 'Selec. moneda'}",
                elements: listaMoneda.map((e) => [e, e.descripcion]).toList(),
                onTap: _monedaChanged,
              ),
            ),
          );
        }
      ),
    );
  }

  _search(String data){
    // _txtSearch
    _streamControllerBanca.add(listaBanca.where((element) => element.descripcion.toLowerCase().indexOf(data.toLowerCase()) != -1 || element.codigo.indexOf(data.toLowerCase()) != -1).toList());
  }

  _columns(bool isSmallOrMedium){
    return isSmallOrMedium ? ["Banca", "Ventas netas", "Opciones"] : ["Banca", "Venta", "Premio", "Comision", "Descuento", "Venta neta", "Opciones"];
  }

  _totalNetoWidget(bool isSmallOrMedium, Branchreport data){
    return Column(
      // mainAxisAlignment: isSmallOrMedium ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: isSmallOrMedium ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text("${Utils.toCurrency(data.totalNeto)}", style: TextStyle(fontWeight: FontWeight.bold, color: data.totalNeto == 0 ? Colors.grey : data.totalNeto > 0 ? Colors.black : Colors.pink)),
        Row(
          mainAxisAlignment: isSmallOrMedium ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(Icons.trending_up, color: data.totalNetoPorcentaje == 0 ? Colors.grey : data.totalNetoPorcentaje > 0 ? Colors.green : Colors.pink, size: 18,),
            Text("${Utils.toCurrency(data.totalNetoPorcentaje)}%", style: TextStyle(color: data.totalNetoPorcentaje == 0 ? Colors.grey : data.totalNetoPorcentaje > 0 ? Colors.green : Colors.pink, fontSize: 11),),
          ],
        )
      ],
    );
  }

  _opcionWidget(bool isSmallOrMedium, Branchreport data){
    var widget = PopupMenuButton(
      child: Icon(Icons.more_vert, color: Colors.grey[700] ),
      onSelected: (String value) async {
        if(value == "reporte"){
          Navigator.pushNamed(context, "/ventas", arguments: data.idBanca);
        }
        else if(value == "desactivar"){
          _showDialogDesactivar(data: data);
        }
        else if(value == "editar"){
          try{
            Navigator.pushNamed(context, '/bancas/agregar', arguments: data.idBanca);
          } on Exception catch(e){
            // setState(() => _cargando = false);
          }
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: "reporte",
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.insert_chart, size: 20),
              ),
              Text("Ver reporte", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
        PopupMenuItem(
          value: "desactivar",
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.domain_disabled_sharp, size: 20),
              ),
              Text("Desactivar banca", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          )
        ),
        PopupMenuItem(
          value: "editar",
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.edit, size: 20),
              ),
              Text("Editar banca", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          )
        ),
      ],
    );
    if(isSmallOrMedium)
      Center(child: widget,);

    return widget;
  }

  _rows(bool isSmallOrMedium, List<Branchreport> data){
    if(data == null)
      return [[]];


   return
    isSmallOrMedium
    ?
    data.map((e) => [e, e.descripcion, _totalNetoWidget(isSmallOrMedium, e), _opcionWidget(isSmallOrMedium, e)]).toList()
    :
    data.map((e) => [e, e.descripcion, "${Utils.toCurrency(e.ventas)}", "${Utils.toCurrency(e.premios)}", "${e.comisiones}", "${e.descuentos}", _totalNetoWidget(isSmallOrMedium, e), _opcionWidget(isSmallOrMedium, e)]).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerData = BehaviorSubject();
    _streamControllerBanca = BehaviorSubject();
    _future =  _init();
    _date = MyDate.getTodayDateRange();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);

    return myScaffold(
      key: _scaffoldKey,
      drawer: widget.showDrawer == null ? null : !widget.showDrawer ? null : isSmallOrMedium ? _drawerWidget() : null,
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      general: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "General",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 85,
          actions: [
            _monedaScreen(isSmallOrMedium),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FutureBuilder<Object>(
                    future: _future,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState != ConnectionState.done)
                        return SizedBox.shrink();

                      
                      return MyDropdown(
                        title: null,
                        textColor: Colors.grey[600],
                        color: Colors.grey[600],
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                        isFlat: true,
                        hint: "${_grupo != null ? 'Grupo: ' + _grupo.descripcion : 'Selec. grupo'}",
                        elements: listaGrupo.map((e) => [e, e.descripcion]).toList(),
                        onTap: _grupoChanged,
                      );
                    }
                  ),
                ),
              ), 
              onTap: null
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: _dateWidget(isSmallOrMedium),
              onTap: (){}
              )
          ],
        ), 
        sliver: StreamBuilder<Map<String, dynamic>>(
          stream: _streamControllerData.stream,
          builder: (context, snapshot) {
            print("ReportesGeneralScreen streambuilder: ${snapshot.data}");
            if(snapshot.hasError)
              return SliverFillRemaining(child: MyEmpty(title: "Ha ocurrido un error", titleButton: "Cargar nuevamente",),);

            if(snapshot.data == null)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            return SliverList(delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${Utils.toCurrency(snapshot.data["totalNeto"], false, false)}", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: snapshot.data["totalNeto"] >= 0 ? Colors.black : Colors.pink)),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Icon(Icons.trending_up, color: snapshot.data["totalNeto"] == 0 ? Colors.grey : snapshot.data["totalNeto"] > 0 ? Colors.green : Colors.pink, size: 18,),
                            ),
                            Text("${snapshot.data['totalNetoPorcentaje']}%", style: TextStyle(color: snapshot.data["totalNeto"] == 0 ? Colors.grey : snapshot.data["totalNeto"] > 0 ? Colors.green : Colors.pink, fontSize: 13),)
                          ],
                        )
                      ],
                    ),
                    MyDescripcon(title: "${snapshot.data["totalNeto"] >= 0 ? 'Ganancia' : 'Perdida'}")
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    children: [
                      MyResizedContainer(
                        small: 2, 
                        medium: 2,
                        large: 4,
                        xlarge: 4,
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _roundedWidget(isSmallOrMedium: isSmallOrMedium, icon: Icon(Icons.attach_money, color: Colors.green,), title: Text("${Utils.toCurrency(snapshot.data["ventas"], false, true)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallOrMedium ? 14 : 16)), subtitle: "Ventas"),
                      )),
                      MyResizedContainer(
                        small: 2, 
                        medium: 2,
                        large: 4,
                        xlarge: 4,
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _roundedWidget(isSmallOrMedium: isSmallOrMedium, icon: Icon(Icons.money_off, color: Colors.pink,), title: Text("${Utils.toCurrency(snapshot.data["premios"], false, true)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallOrMedium ? 14 : 16)), subtitle: "Premios"),
                      )),
                      MyResizedContainer(
                        small: 2, 
                        medium: 2,
                        large: 4,
                        xlarge: 4,
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _roundedWidget(isSmallOrMedium: isSmallOrMedium, icon: Icon(Icons.currency_exchange_rounded, color: Colors.orange,), title: Text("${Utils.toCurrency(snapshot.data["comisiones"], false, true)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallOrMedium ? 14 : 16)), subtitle: "Comision"),
                      )),
                      MyResizedContainer(
                        small: 2, 
                        medium: 2,
                        large: 4,
                        xlarge: 4,
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _roundedWidget(isSmallOrMedium: isSmallOrMedium, icon: Icon(Icons.discount, color: Colors.orange,), title: Text("${Utils.toCurrency(snapshot.data["descuentos"], false, true)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallOrMedium ? 14 : 16)), subtitle: "Descuentos"),
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: MySubtitle(title: "Bancas", fontWeight: FontWeight.bold,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _valueNotifierCargandoFiltroBanca,
                      builder: (context, value, __) {
                        return MyDropdown(
                          title: null,
                          small: 2,
                          medium: 2,
                          leading: Icon(Icons.filter_alt, color: Colors.black),
                          color: Colors.grey[200],
                          textColor: Colors.black,
                          hint: value ? Center(child: SizedBox(child: CircularProgressIndicator(), width: 10, height: 10,)) : "Filtro: $_filtro",
                          elements: listaFiltro.map((e) => [e, e]).toList(),
                          onTap: _filtroChanged,
                        );
                      }
                    ),
                    Container(
                      width: !isSmallOrMedium ? MediaQuery.of(context).size.width / 3 : null,
                      child: Padding(
                        padding: EdgeInsets.only(right: isSmallOrMedium ? 0 : 15.0, top: 0.0, bottom: !isSmallOrMedium ? 20 : 0),
                        child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", small: 2.6, medium: 2.6, xlarge: 2.6, contentPadding: isSmallOrMedium ? EdgeInsets.only(bottom: 10, top: 10) : EdgeInsets.only(bottom: 15, top: 15),),
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StreamBuilder<List<Branchreport>>(
                  stream: _streamControllerBanca.stream,
                  builder: (context, snapshot) {
                    return MyTable(
                      isScrolled: false,
                      headerColor: Theme.of(context).primaryColor,
                      headerTitleColor: Colors.white,
                      columns: _columns(isSmallOrMedium),
                      rows: _rows(isSmallOrMedium, snapshot.data)
                    );
                  }
                ),
              )
            ]));
          }
        )
      )
    );
  }
}