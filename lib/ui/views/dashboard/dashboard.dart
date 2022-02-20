import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/graficaventas.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/loteriasventas.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/dashboardservice.dart';
import 'package:loterias/ui/views/dashboard/grafica.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/mybarchart.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytogglebuttons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ValueNotifier _valueNotifyDrawer;
  ValueNotifier<bool> _valueNotifyCargandoLoteria;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Moneda>> _streamControllerMonedas;
  StreamController<List<GraficaVentas>> _streamControllerGrafica;
  StreamController<List> _streamControllerJugadasPorLoteria;
  List<Moneda> listaMoneda = [];
  List<Grupo> listaGrupo = [];
  List<GraficaVentas> listaVentasGrafica;
  List<LoteriasVentas> listaLoteria = [];
  double _totalVentasLoterias = 0;
  double _totalPremiosLoterias = 0;
  List listaLoteriasJugadasDashboard = [];
  List listaJugada = [];
  List listaSorteo = [];
  int _indexMoneda = 0;
  int _indexLoteriaJugadas = 0;
  int _indexSorteo = 0;
  bool _cargando = false;
  bool _onCreate = true;
  var _fecha = DateTime.now();
  DateTimeRange _date;
  ScrollController _scrollController;
  int bancasSinVentas = 0;
  int bancasConVentas = 0;
  double promedioVentas = 0;
  double promedioPremios = 0;
  Moneda _moneda;
  Grupo _grupo;
  Timer _timer;

  @override
  initState(){
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) => listaLoteriasJugadasDashboard.length > 0 ? _loteriaChanged(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]) : null);
    _valueNotifyCargandoLoteria = ValueNotifier<bool>(false);
    _scrollController = ScrollController();
    _streamControllerMonedas = BehaviorSubject();
    _streamControllerGrafica = BehaviorSubject();
    _streamControllerJugadasPorLoteria = BehaviorSubject();
    _date = MyDate.getTodayDateRange();
    _dashboard();
    super.initState();
  }

  _dashboard() async {
    try{
      // setState(() => _cargando = true);
      _streamControllerGrafica.add(null);
      var datos = await DashboardService.dashboard(scaffoldKey: _scaffoldKey, fecha: _date.start, idMoneda: _moneda != null ? _moneda.id : null, idGrupo: _grupo != null ? _grupo.id : null);
      if(_onCreate){
        listaMoneda = datos["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList();
        listaGrupo = datos["grupos"].map<Grupo>((json) => Grupo.fromMap(json)).toList();
        listaGrupo.insert(0, Grupo(id: 0, descripcion: "Todos los grupos"));
        _grupo = listaGrupo[0];

        if(listaMoneda != null){
          if(listaMoneda.length > 0)
            _moneda = listaMoneda[0];
        }
        _streamControllerMonedas.add(listaMoneda);
        setState(() => _onCreate = false);
      }

      listaVentasGrafica = datos["ventasGrafica"] != null ? datos["ventasGrafica"].map<GraficaVentas>((e) => GraficaVentas.fromMap(e)).toList() : [];
      listaLoteria = datos["loterias"] != null ? datos["loterias"].map<LoteriasVentas>((e) => LoteriasVentas.fromMap(e)).toList() : [];
      _totalVentasLoterias = Utils.toDouble(datos["totalVentasLoterias"].toString());
      _totalPremiosLoterias = Utils.toDouble(datos["totalPremiosLoterias"].toString());
      listaLoteriasJugadasDashboard = (datos["loteriasJugadasDashboard"] != null) ? List.from(datos["loteriasJugadasDashboard"]) : [];
      listaSorteo = List.from(datos["sorteos"]);
      bancasConVentas = datos["bancasConVentas"];
      bancasSinVentas = datos["bancasSinVentas"];

      if(listaSorteo != null){
        // _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
        _loteriaChanged(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]);
      }

      // if(listaSorteo != null)
      //   _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);

      promedioVentas = listaVentasGrafica != null ? listaVentasGrafica.length > 0 ? listaVentasGrafica.map((e) => e.total).toList().reduce((value, element) => value + element) / listaVentasGrafica.length : 0 : 0;
      promedioPremios = listaVentasGrafica != null ? listaVentasGrafica.length > 0 ? listaVentasGrafica.map((e) => e.premios).toList().reduce((value, element) => value + element) / listaVentasGrafica.length : 0 : 0;
      
      _streamControllerGrafica.add(listaVentasGrafica);
      setState(() => _cargando = false);
    } on Exception catch(e){
      _streamControllerGrafica.add([]);
      setState(() => _cargando = false);
    }
  }

  _dashboardMoneda() async {
    try{
      setState(() => _cargando = true);
      var datos = await DashboardService.dashboard(scaffoldKey: _scaffoldKey, fecha: _fecha, idMoneda: listaMoneda[_indexMoneda].id, idGrupo: _grupo != null ? _grupo.id : null);
      // if(_onCreate){
      //   listaMoneda = datos["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList();
      //   _streamControllerMonedas.add(listaMoneda);
      //   setState(() => _onCreate = false);
      // }

      listaVentasGrafica = datos["ventasGrafica"] != null ? datos["ventasGrafica"].map<GraficaVentas>((e) => GraficaVentas.fromMap(e)).toList() : [];
      listaLoteria = List.from(datos["loterias"]);
      _totalVentasLoterias = Utils.toDouble(datos["totalVentasLoterias"].toString());
      _totalPremiosLoterias = Utils.toDouble(datos["totalPremiosLoterias"].toString());
      listaLoteriasJugadasDashboard = (datos["loteriasJugadasDashboard"] != null) ? List.from(datos["loteriasJugadasDashboard"]) : List();
      listaSorteo = List.from(datos["sorteos"]);
      
      _streamControllerGrafica.add(listaVentasGrafica);
      setState(() => _cargando = false);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _loteriaChanged(var loteria) async {
    if(!_date.start.isSameDate(DateTime.now()))
      return;

    try {
      _valueNotifyCargandoLoteria.value = true;
      _streamControllerJugadasPorLoteria.add(null);
      var datos = await DashboardService.getJugadasPorLoteria(scaffoldKey: _scaffoldKey, fecha: _fecha, idLoteria: loteria["id"], idMoneda: _moneda != null ? _moneda.id : null, idGrupo: _grupo.id != 0 ? _grupo.id : null);
      print("Dashboard _loteriaChanged: $datos");
      _valueNotifyCargandoLoteria.value = false;
      listaLoteriasJugadasDashboard[_indexLoteriaJugadas] = datos["loteria"];
      _streamControllerJugadasPorLoteria.add([]);
      _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
    } on Exception catch (e) {
      // TODO
      _valueNotifyCargandoLoteria.value = false;
    }
    // _valueNotifyIsLoteriaSearchingJugadas.value = false;
    // _streamControllerJugadasPorLoteria.add(datos["loteria"][]);
  }

  _cambiarValorListaJugada(String sorteo){
    if(listaLoteriasJugadasDashboard.length == 0)
      return;
    List sorteosLoteriasJugadas = List.from(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["sorteos"]);
    if(sorteosLoteriasJugadas != null){
      Map<String, dynamic> sort = sorteosLoteriasJugadas.firstWhere((s) => s["descripcion"] == sorteo);
      if(sort != null){
        listaJugada = sort["jugadas"] != null ? List.from(sort["jugadas"]) : [];
        _streamControllerJugadasPorLoteria.add(listaJugada);
        // if(sort["jugadas"] != null)
        //   setState(() => listaJugada = List.from(sort["jugadas"]));
      }
    }
  }

  _dateChanged(var date){
    print("Hola");
    if(date == null)
      return;

    if(date != null && date is DateTime)
      setState(() {
        _date = DateTimeRange(
          start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
          end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
        );
        _dashboard();
      });
    else
     setState((){
        _date = date;
        _dashboard();
     });

      _streamControllerJugadasPorLoteria.add([]);

  }

   _dateDialog() async {
    var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));
    _dateChanged(date);
    
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
              MyFilter(
                filterTitle: '',
                filterLeading: SizedBox.shrink(),
                leading: SizedBox.shrink(),
                value: _date, 
                onChanged: _dateChanged,
                showListNormalCortaLarga: 2,
              ),
              // _mysearch()
            ]
          ),
        )
        
          
        ,
      ),
    )
    :
    SizedBox();
  }

  Widget myCard({@required title, @required subtitle, @required Widget leading, Color iconColor, double small = 2, double medium = 2.3, double large = 4, double xlarge = 4, bool isSmallOrMedium}){
  return MyResizedContainer(
    small: small,
    medium: medium,
    large: large,
    xlarge: xlarge,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          leading,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            title is Widget  ? title : MyDescripcon(title: title, fontSize: isSmallOrMedium ? 11 : 13,),
            subtitle is Widget ? subtitle : MySubtitle(title: subtitle, padding: EdgeInsets.only(bottom: 5, top: 5), fontSize: isSmallOrMedium ? 16 : 20,)
          ],)
        ],),
      ),
    ),
  );
  
          
}



_showBottomSheetMoneda() async {
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
        _back({Moneda moneda}){
              Navigator.pop(context, moneda);
            }
            monedaChanged(moneda){
              _back(moneda: moneda);
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
                      itemCount: listaMoneda.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _moneda == listaMoneda[index],
                          // value: true,
                          onChanged: (data){
                            monedaChanged(listaMoneda[index]);
                          },
                          title: Text("${listaMoneda[index].descripcion}",),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        
      
      }
  );
    if(data != null)
      setState((){
        _moneda = data;
        _dashboard();
      });
  }

  _grupoChanged(Grupo data){
    _grupo = data;
    _dashboard();
  }

  _monedaChanged(Moneda data){
    _moneda = data;
    _dashboard();
  }

  _monedaScreen(bool isSmallOrMedium){
    return MySliverButton(
      onTap: isSmallOrMedium ? _showBottomSheetMoneda : null,
      title: StreamBuilder<List<Moneda>>(
        stream: _streamControllerMonedas.stream,
        builder: (context, snapshot) {
          if(isSmallOrMedium)
            return TextButton(onPressed: _showBottomSheetMoneda, child: Text("${_moneda != null ? _moneda.abreviatura : ''}", style: TextStyle(color: (_moneda != null) ? Utils.fromHex(_moneda.color) : Utils.colorPrimary)));
        
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

  @override
  void dispose() {
    // TODO: implement dispose
    _streamControllerMonedas.close();
    _streamControllerJugadasPorLoteria.close();
    _streamControllerGrafica.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      dashboard: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Dashboard",
          subtitle: _subtitle(isSmallOrMedium),
          showDivider: false,
          expandedHeight: isSmallOrMedium ? 105 : 0,
          actions: [
            
            _monedaScreen(isSmallOrMedium),
              
            MySliverButton(
              title: "", 
              iconWhenSmallScreen: Icons.date_range,
              showOnlyOnSmall: true,
              onTap: _dateDialog,
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: MyDropdown(
                    title: null,
                    textColor: Colors.grey[600],
                    color: Colors.grey[600],
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                    isFlat: true,
                    hint: "${_grupo != null ? _grupo.descripcion : 'Selec. grupo'}",
                    elements: listaGrupo.map((e) => [e, e.descripcion]).toList(),
                    onTap: _grupoChanged,
                  ),
                ),
              ), 
              onTap: null
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: MyDropdown(title: null, 
                        leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        hint: "${MyDate.dateRangeToNameOrString(_date)}",
                        onTap: _dateDialog,
                      ),
                    );
                  }
                ),
              ), 
              onTap: (){}
              )
            //  MySliverButton(
            //   // showOnlyOnLarge: true,
            //   showOnlyOnSmall: true,
            //   title: Container(
            //     width: 120,
            //     // width: 140,
            //   height: 37,
            //   padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
            //   decoration: BoxDecoration(
            //   color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(10)
            //   ),
            //     child: Builder(
            //       builder: (context) {
            //         return InkWell(
            //         onTap: _dateDialog,
            //         child: Container(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //             Icon(Icons.date_range),
            //             Expanded(child: Center(child: Text("${MyDate.dateRangeToNameOrString(_date)}", style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,))),
            //             Icon(Icons.arrow_drop_down, color: Colors.black)
            //           ],),
            //         ),
            //       );
            //       }
            //     ),
            //   ), 
            //   onTap: (){}
            //   ),
          ],
        ), 
        sliver: 
        // SliverFillRemaining(
        //   child: Center(
        //     child: Container(
        //                 height: 400,
        //                 child: MyBarchar(
        //                   xlarge: 2,
        //                   large: 2,
        //                   medium: 1,
        //                   small: 1,
        //                   leftLabelDivider: 3,
        //                   listOfBottomLabel: [Text("Lunes"), Text("martes"), Text("Mierco"), Text("Jueves"), Text("Viern"), Text("Sab"), Text("Dom.")],
        //                   listOfData: [
        //                     [MyBar(value: 20, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))), MyBar(value: 10, color: Colors.green,)],
        //                     [MyBar(value: 25, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))), MyBar(value: -10, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
        //                     [MyBar(value: 50, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: 40, color: Colors.green,)],
        //                     [MyBar(value: 70, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: 10, color: Colors.green,)],
        //                     [MyBar(value: 150, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: -50, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
        //                     [MyBar(value: 90, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: -70, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
        //                     [MyBar(value: 78, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: -87, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
        //                   ],
        //                 ),
        //               ),
        //   ),
        // )

        StreamBuilder<Object>(
          stream: _streamControllerGrafica.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            var widgets = [
                Wrap(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        myCard(title: "Promedio ventas", subtitle: "${Utils.toCurrency(promedioVentas)}", isSmallOrMedium: isSmallOrMedium, 
                        leading: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.attach_money, size: 32, color: Colors.green,),
                            ),
                          ],
                        )),
                        myCard(title: "Promedio premios", subtitle: "${Utils.toCurrency(promedioPremios)}", isSmallOrMedium: isSmallOrMedium, 
                        leading: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.money_off, size: 32, color: Colors.pink,),
                            ),
                          ],
                        )),
                        myCard(title: "Bancas con ventas", subtitle: "$bancasConVentas", isSmallOrMedium: isSmallOrMedium, leading: Icon(Icons.bookmark_added, size: 32, color: Colors.blue[700],)),
                        myCard(title: "Bancas sin ventas", subtitle: "$bancasSinVentas", isSmallOrMedium: isSmallOrMedium, leading: Icon(Icons.bookmark_remove, size: 32, color: Colors.orange[700],)),
                      ],
                    ),
                    // MyResizedContainer(
                    //   xlarge: 2,
                    //   large: 2,
                    //   child: Card(elevation: 5, child: Container( height: isSmallOrMedium ? 200 : 400, child: GroupedStackedBarChart(datosGrafica(snapshot.data)),))
                    // ),
                    MyResizedContainer(
                      xlarge: 2,
                      large: 2,
                      medium: 1,
                      small: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MySubtitle(title: "Grafica de ventas", padding: EdgeInsets.only(top: 12.0, bottom: 12.0),),
                          MyDescripcon(title: "Aqui se muestra el total vendido y el total neto de los ultimos 7 dias"),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: 
                             Container( height: isSmallOrMedium ? 200 : 400, child: GroupedStackedBarChart(datosGrafica(snapshot.data, isSmallOrMedium: isSmallOrMedium)),),
                            // Container(
                            //     height: 400,
                            //     child: MyBarchar(
                            //       xlarge: 1,
                            //       large: 1,
                            //       medium: 1,
                            //       small: 1,
                            //       leftLabelDivider: 3,
                            //       listOfBottomLabel: listaVentasGrafica.map<Text>((e) => Text("${e.dia}")).toList(),
                            //       listOfData: listaVentasGrafica.map((e) => [MyBar(value: e.total, color: Colors.green[100], text: "Total", borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),), MyBar(text: "Neto", value: e.neto, color: e.neto >= 0 ? Colors.green : Colors.pink, borderRadius: e.neto < 0 ? BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)) : null)]).toList()
                            //       // [
                            //       //   [MyBar(value: 20, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))), MyBar(value: 10, color: Colors.green,)],
                            //       //   [MyBar(value: 25, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))), MyBar(value: -10, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
                            //       //   [MyBar(value: 50, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: 40, color: Colors.green,)],
                            //       //   [MyBar(value: 70, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: 10, color: Colors.green,)],
                            //       //   [MyBar(value: 150, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: -50, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
                            //       //   [MyBar(value: 90, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: -70, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
                            //       //   [MyBar(value: 78, color: Colors.green[100], borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), border: Border(left: BorderSide(color: Colors.green[50], width: 2.0), right: BorderSide(color: Colors.green[50], width: 2.0), top: BorderSide(color: Colors.green[50], width: 2.0))),  MyBar(value: -87, color: Colors.pink[500], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),)],
                            //       // ],
                            //     ),
                            //   ),
                          ),
                        ],
                      ),
                    ),
                      // Container( 
                      //   height: 200, 
                      //   child: MyBarchar(
                      //     medium: 1,
                      //     listOfBottomLabel: snapshot.data.map((e) => Text(e.dia)).toList(),
                      //     leftLabelDivider: 5,
                      //     listOfData: snapshot.data.map((e) => [MyBar(value: e.total, color: Colors.grey[50]), MyBar(value: e.neto, color: e.neto >= 0 ? Colors.green : Colors.pink)]).toList(),
                      //   ),
                      // ),
                      MyResizedContainer(
                        xlarge: 2,
                        large: 2,
                        medium: 1,
                        small: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MySubtitle(title: "totales por loteria", padding: EdgeInsets.only(top: 12.0, bottom: 12.0),),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: MyDescripcon(title: "Aqui se mostraran las ventas y premios totales de cada loteria"),
                            ),
                            // Padding(
                            //     padding: const EdgeInsets.only(top: 20, bottom: 15),
                            //     child: Center(child: Text("Totales por loteria", style: TextStyle(fontSize: 25),),),
                            //   ),
                              isSmallOrMedium
                              ?
                            _buildTableVentasPorLoteria(listaLoteria)
                            :
                            Container(
                              height: isSmallOrMedium ? null : 400,

                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0, top: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MyTable(
                                        showColorWhenImpar: true,
                                        type: MyTableType.custom,
                                        // isScrolled: false,
                                        bottom: ["Totales", "${listaLoteria != null ? Utils.toCurrency(listaLoteria.map((e) => e.ventas).toList().reduce((value, element) => value + element)) : Utils.toCurrency("0")}", "0"],
                                        columns: [Center(child: Text("Loteria", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), Center(child: Text("Ventas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), Center(child: Text("Premios", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))], 
                                        rows: listaLoteria.map((e) => [e, e.descripcion, "${Utils.toCurrency(e.ventas)}", "${Utils.toCurrency(e.premios)}"]).toList()
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            
                          ],
                        ),
                      ),
                  ],
                ),
                  _buildJugadasRealizadas(isSmallOrMedium)
              ];
            
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index){
                  return widgets[index];
                },
                childCount: widgets.length
              ));

            return SliverFillRemaining(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widgets.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: index == 0 ? 0 : 14.0),
                    child: widgets[index],
                  );
                }
              )
            );
          }
        )
      
      )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Ventas", style: TextStyle(color: Colors.black),),
        leading: BackButton(
          color: Utils.colorPrimary,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Visibility(
                    visible: _cargando,
                    child: Theme(
                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Wrap(
              spacing: 12,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: RaisedButton(
                      elevation: 0, 
                      color: Colors.transparent, 
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                      child: Text("${_fecha.year}-${_fecha.month}-${_fecha.day}", style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                        setState((){ 
                          _fecha = (fecha != null) ? fecha : _fecha;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: StreamBuilder<List<Moneda>>(
                    stream: _streamControllerMonedas.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return DropdownButton<Moneda>(
                          isExpanded: true,
                          value: snapshot.data[_indexMoneda],
                          items: snapshot.data.map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.abreviatura, style: TextStyle(color: Utils.fromHex(m.color)),),
                          )).toList(), 
                          onChanged: (Moneda moneda){
                            int idx = snapshot.data.indexWhere((m) => m.id == moneda.id);
                            setState(() {
                              _indexMoneda = idx;
                            });
                          }
                        );
                      }

                      return DropdownButton(
                        value: "No hay datos",
                        items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], 
                        onChanged: (data){}
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: RaisedButton(
                    elevation: 0,
                    color: Utils.fromHex("#e4e6e8"),
                    child: Icon(Icons.search, color: Utils.colorPrimary,),
                    onPressed: (){
                      _dashboardMoneda();
                    },
                  ),
                ),
              ],
            ),
            StreamBuilder<List<GraficaVentas>>(
              stream: _streamControllerGrafica.stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.isEmpty)
                    return Center(child: Text("No hay datos"));
                  return Column(
                    children: <Widget>[
                      // Container( height: 200, child: GroupedStackedBarChart(datosGrafica(snapshot.data)),),
                      // Container( 
                      //   height: 200, 
                      //   child: MyBarchar(
                      //     medium: 1,
                      //     listOfBottomLabel: snapshot.data.map((e) => Text(e.dia)).toList(),
                      //     leftLabelDivider: 5,
                      //     listOfData: snapshot.data.map((e) => [MyBar(value: e.total, color: Colors.grey[50]), MyBar(value: e.neto, color: e.neto >= 0 ? Colors.green : Colors.pink)]).toList(),
                      //   ),
                      // ),
                      Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Center(child: Text("Totales por loteria", style: TextStyle(fontSize: 25),),),
                        ),
                      _buildTableVentasPorLoteria(listaLoteria),
                       _buildJugadasRealizadas(false)
                    ],
                  );
                }

                return Center(child: Text("No hay datos"));
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _myEmpty(){
    return Center(child: MyEmpty(title: "No hay jugadas", titleButton: "No hay jugadas; actualizar", icon: Icons.blur_circular_outlined,),);
  }

  Widget _playsScreen(List data, bool isSmallOrMedium){
    //  Map<String, dynamic> sort = sorteosLoteriasJugadas.firstWhere((s) => s["descripcion"] == sorteo);
    //   if(sort != null)
    //     setState(() => listaJugada = List.from(sort["jugadas"]));
    if(isSmallOrMedium){
      if(data == null)
         return Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
          child: Center(child: CircularProgressIndicator(),),
        );
      if(data.isEmpty)
        return _myEmpty();

        return _buildTableLoteriasJugadasDashboard(data);
    }

    List sorteosLoteriasJugadas = List.from(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["sorteos"]);
    // List sorteosLoteriasJugadas = data != null ? data : [];
        return Wrap(
          children: sorteosLoteriasJugadas.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: MyResizedContainer(
                xlarge: 4.3,
                large: 4.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: 250,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("${e["descripcion"]}"),
                          ),
                        ),
                        Expanded(
                          child: MyTable(
                            showColorWhenImpar: true,
                            type: MyTableType.custom,
                            columns: ["LOT", "NUM", "MONT"], 
                            rows: e["jugadas"] != null ?  List.from(e["jugadas"]).map<List<dynamic>>((j) => [j, "${isSmallOrMedium ? j["descripcion"] : e['descripcion'] != Draws.superPale ? j["abreviatura"] : j["abreviatura"] + '/' + j["abreviaturaLoteriaSuperpale"]}", "${j["jugada"]}", "${j["monto"] != null ? Utils.toCurrency(j["monto"]) : '0'}"]).toList() : [[]]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )).toList(),
        );
      
  
  }

  int _countPlaysByDraw(Map<String, dynamic> draw){
    int count = 0;
    if(listaLoteriasJugadasDashboard == null)
      return count;
    if(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["sorteos"] == null)
      return count;

     List sorteos = List.from(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["sorteos"]);

     if(sorteos.length == 0)
      return count;

      

    var sorteo = sorteos.firstWhere((element) => element["descripcion"] == draw["descripcion"], orElse: () => null);
    if(sorteo == null)
      return count;

    return sorteo["jugadas"] != null ? List.from(sorteo["jugadas"]).length : count;
  }

  

  Widget _drawsScreen(bool isSmallOrMedium){
    if(isSmallOrMedium)
      return  MyToggleButtons(
          onTap: (sorteo){
            // var d = _loteriasComisiones.firstWhere((element) => element.id == data, orElse: () => null);
            int idx = listaSorteo.indexWhere((s) => s["descripcion"] == sorteo);
            if(idx != -1){
              setState(() => _indexSorteo = idx);
              print("Changed sorteos: ${listaSorteo[_indexSorteo]}");
              _cambiarValorListaJugada(sorteo);
            }
          },
          // items: _loterias.map((e) => MyToggleData(value: e, child: e.descripcion)).toList(),
          items: listaSorteo.map<MyToggleData>((e) => MyToggleData(value: e["descripcion"], child: Text("${e["descripcion"]} (${_countPlaysByDraw(e)})"))).toList(),
          selectedItems: listaLoteriasJugadasDashboard != null ? [MyToggleData(value: listaSorteo[_indexSorteo]["descripcion"], child: "${listaSorteo[_indexSorteo]['descripcion']}")] : [],
        );

    return SizedBox.shrink();
  }

  Widget _buildJugadasRealizadas(bool isSmallOrMedium)
  {
    if(listaLoteriasJugadasDashboard == null)
      return SizedBox();
    if(listaLoteriasJugadasDashboard.length == 0)
      return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MySubtitle(title: "Jugadas realizadas", padding: EdgeInsets.only(top: 15, bottom: 12.0),),
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: MyDescripcon(title: "Aqui se muestran las jugadas en tiempo real para cada loteria ordenadas por monto jugado de manera descendente, las jugadas se actualizan cada 3 segundos."),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 20, bottom: 15),
        //   child: Center(child: Text("Jugadas realizadas", style: TextStyle(fontSize: 25),),),
        // ),
        // DropdownButton<String>(
        //   value: listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["descripcion"],
        //   items: listaLoteriasJugadasDashboard.map((l) => DropdownMenuItem<String>(
        //     value: l["descripcion"],
        //     child: Text(l["descripcion"])
        //   )).toList(), 
        //   onChanged: (String loteria){
        //     int idx = listaLoteriasJugadasDashboard.indexWhere((s) => s["descripcion"] == loteria);
        //     setState(() => _indexLoteriaJugadas = idx);
        //     _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
        //   }
        // ),
        
        // DropdownButton<String>(
        //   value: listaSorteo[_indexSorteo]["descripcion"],
        //   items: listaSorteo.map((s) => DropdownMenuItem<String>(
        //     value: s["descripcion"],
        //     child: Text(s["descripcion"])
        //   )).toList(), 
        //   onChanged: (String sorteo){
        //     int idx = listaSorteo.indexWhere((s) => s["descripcion"] == sorteo);
        //     if(idx != -1){
        //       setState(() => _indexSorteo = idx);
        //       print("Changed sorteos: ${listaSorteo[_indexSorteo]}");
        //       _cambiarValorListaJugada(sorteo);
        //     }
        //   }
        // ),
        // _buildTableLoteriasJugadasDashboard()
        MyToggleButtons(
          onTap: (loteria){
            // var d = _loteriasComisiones.firstWhere((element) => element.id == data, orElse: () => null);
            setState(() {
              int idx = listaLoteriasJugadasDashboard.indexWhere((s) => s["descripcion"] == loteria);
              setState(() => _indexLoteriaJugadas = idx);
              // _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
              _loteriaChanged(listaLoteriasJugadasDashboard[idx]);
            });
          },
          // items: _loterias.map((e) => MyToggleData(value: e, child: e.descripcion)).toList(),
          items: listaLoteriasJugadasDashboard.map<MyToggleData>((e) => MyToggleData(value: e["descripcion"], child: Row(
            children: [
              Text(e["descripcion"]),
              ValueListenableBuilder<bool>(
                valueListenable: _valueNotifyCargandoLoteria,
                builder: (context, value, __) {
                  return Visibility(
                    visible: value && e["descripcion"] == listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["descripcion"], 
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.white)),
                    )
                  );
                }
              )
            ],
          ))).toList(),
          selectedItems: listaLoteriasJugadasDashboard != null ? [MyToggleData(value: listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["descripcion"], child: Text("${listaLoteriasJugadasDashboard[_indexLoteriaJugadas]['descripcion']}"))] : [],
        ),
       StreamBuilder<List>(
         stream: _streamControllerJugadasPorLoteria.stream,
         builder: (context, snapshot) {
          //  if(snapshot.data == null)
               
                // return Center(child: MyEmpty(title: "No hay jugadas", titleButton: "No hay jugadas; actualizar", icon: Icons.blur_circular_outlined,),);

           return Column(
             children: [
               _drawsScreen(isSmallOrMedium),
               _playsScreen(snapshot.data, isSmallOrMedium)
             ],
           );
         }
       ),
      ],
    );
  }

static List<charts.Series<OrdinalSales, String>> datosGrafica(List<GraficaVentas> listaVentasGrafica, {bool isSmallOrMedium = false}) {

  final desktopSalesDataA = listaVentasGrafica.map((v) => OrdinalSales(v.dia, Utils.toDouble(v.total.toString()))).toList();
  final tableSalesDataA = listaVentasGrafica.map((v) => OrdinalSales(v.dia.toString(), Utils.toDouble(v.neto.toString()))).toList();
    

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataA,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales.toString(),
        insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: 30);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: isSmallOrMedium ? 7 : 11);
        },
        colorFn: (OrdinalSales sales, _) => charts.Color.fromHex(code: "#95999e"),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataA,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales.toString(),
        insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: 30);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: isSmallOrMedium ? 7 : 11);
        },
        colorFn: (OrdinalSales sales, _) => sales.sales > 0 ? charts.Color.fromHex(code: "#75b281") : charts.Color.fromHex(code: "#dc2365"),
      ),
    ];
  }


  Widget _buildTableVentasPorLoteria(List<LoteriasVentas> map){
   var tam = (map != null) ? map.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
   }else{
     rows = map.asMap().map((idx, b)
          => MapEntry(
            idx,
            TableRow(
              
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx),
                  child: Center(
                    child: InkWell(onTap: (){}, child: Text(b.descripcion, style: TextStyle(fontSize: 16)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b.ventas == null ? Utils.toCurrency('0') : Utils.toCurrency(b.ventas)}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b.premios == null ? Utils.toCurrency('0') : Utils.toCurrency(b.premios)}", style: TextStyle(fontSize: 16)))
                ),
              ],
            )
          )
        
        ).values.toList();
        
    rows.insert(0, 
              TableRow(
                decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Loteria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Premios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );

              rows.add( 
              TableRow(
                // decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Totales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${Utils.toCurrency(_totalVentasLoterias)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${Utils.toCurrency(_totalPremiosLoterias)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                ]
              )
              );
        
   }

   return Table(
       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
       columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
       children: rows,
      );

  return Flexible(
      child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        ),
      ],
    ),
  );
  
 }

  // Widget _buildJugadasRealizadas()
  // {
  //   if(listaLoteriasJugadasDashboard == null)
  //     return SizedBox();
  //   if(listaLoteriasJugadasDashboard.length == 0)
  //     return SizedBox();

  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(top: 20, bottom: 15),
  //         child: Center(child: Text("Jugadas realizadas", style: TextStyle(fontSize: 25),),),
  //       ),
  //       DropdownButton<String>(
  //         value: listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["descripcion"],
  //         items: listaLoteriasJugadasDashboard.map((l) => DropdownMenuItem<String>(
  //           value: l["descripcion"],
  //           child: Text(l["descripcion"])
  //         )).toList(), 
  //         onChanged: (String loteria){
  //           int idx = listaLoteriasJugadasDashboard.indexWhere((s) => s["descripcion"] == loteria);
  //           setState(() => _indexLoteriaJugadas = idx);
  //           _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
  //         }
  //       ),
  //       DropdownButton<String>(
  //         value: listaSorteo[_indexSorteo]["descripcion"],
  //         items: listaSorteo.map((s) => DropdownMenuItem<String>(
  //           value: s["descripcion"],
  //           child: Text(s["descripcion"])
  //         )).toList(), 
  //         onChanged: (String sorteo){
  //           int idx = listaSorteo.indexWhere((s) => s["descripcion"] == sorteo);
  //           if(idx != -1){
  //             setState(() => _indexSorteo = idx);
  //             print("Changed sorteos: ${listaSorteo[_indexSorteo]}");
  //             _cambiarValorListaJugada(sorteo);
  //           }
  //         }
  //       ),
  //       _buildTableLoteriasJugadasDashboard()
  //     ],
  //   );
  // }

  Widget _buildTableLoteriasJugadasDashboard(List data){
   var tam = (data != null) ? data.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
   }else{
     rows = data.asMap().map((idx, b)
          => MapEntry(
            idx,
            TableRow(
              
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx),
                  child: Center(
                    child: InkWell(onTap: (){}, child: Text(b["descripcion"], style: TextStyle(fontSize: 16)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["jugada"] == null ? '0' : b["jugada"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["monto"] == null ? '0' : b["monto"]}", style: TextStyle(fontSize: 16)))
                ),
              ],
            )
          )
        
        ).values.toList();
        
    rows.insert(0, 
              TableRow(
                decoration: BoxDecoration(color: Utils.colorInfo),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Loteria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Jugada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Monto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );
        
   }

   return (rows.length == 0)
   ? Text("No hay datos", style: TextStyle(fontSize: 20),)
   :
   Table(
     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
     columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
     children: rows,
    );

  return Flexible(
      child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        ),
      ],
    ),
  );
  
 }

}

class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}