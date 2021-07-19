import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class BloqueosPorJugadas extends StatefulWidget {
  const BloqueosPorJugadas({ Key key }) : super(key: key);

  @override
  _BloqueosPorJugadasState createState() => _BloqueosPorJugadasState();
}

class _BloqueosPorJugadasState extends State<BloqueosPorJugadas>  with TickerProviderStateMixin {
  StreamController<List<Moneda>> _streamControllerMoneda;
  StreamController<List<Jugada>> _streamControllerJugada;
  var _txtJugada = TextEditingController();
  var _txtMonto = TextEditingController();
  var _tabController;
  DateTimeRange _date;
  MyDate _fecha;
  Future _future;
  List<Banca> listaBanca = [];
  List<Loteria> listaLoteria = [];
  List<Draws> listaSorteo = [];
  List<Dia> listaDia = [];
  List<Moneda> listaMoneda = [];
  List<String> listaTipo = ["General", "Por banca"];
  String _selectedTipo = "General";
  Moneda _selectedMoneda;
  List<Banca> _bancas = [];
  List<Dia> _dias = [];
  List<Loteria> _loterias = [];
  List<Draws> _sorteos = [];
  bool _descontarDelBloqueoGeneral = true;
  bool _ignorarDemasBloqueos = false;
  var _cargandoNotify = ValueNotifier<bool>(false);
  bool _jugadaOmonto = true;
  bool _txtMontoPrimerCaracter = true;
  List<MyFilterSubData2> _selectedFilter = [];
  List<MyFilterData2> listaFiltros = [];
  List<Grupo> _grupos = [];
  List<Jugada> _jugadas = [];


  _init() async {
    _date = MyDate.getTodayDateRange();
    var parsed = await BloqueosService.index(context: context);
    listaBanca = (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((json) => Draws.fromMap(json)).toList() : [];
    listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];

    if(listaMoneda.length > 0)
      _selectedMoneda = listaMoneda[0];

    if(listaDia.length > 0)
      _dias = List.from(listaDia);

    _streamControllerMoneda.add(listaMoneda);

    print("BloqueosPorJugadasScreen: ${parsed}");
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      // _getData();
    });
  }

  ponerPuntoEnMonto(){
     if(_txtMontoPrimerCaracter){
       _txtMonto.text = '.';
       setState(() => _txtMontoPrimerCaracter = false);
     }
    else{
      if(_txtMonto.text.indexOf('.') == -1){
        _txtMonto.text = _txtMonto.text + '.';
      }
    }
  }

  ponerSignoMas(){
    if(_txtJugada.text.indexOf('+') != -1)
      return;

    if(_txtJugada.text.length != 3 && _txtJugada.text.length != 4)
      return;
    
    _txtJugada.text = _txtJugada.text + '+';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    
  }

  ponerSignoMenos(){
    if(_txtJugada.text.indexOf('-') != -1)
      return;

    if(_txtJugada.text.length != 4)
      return;
    
    _txtJugada.text = _txtJugada.text + '-';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    
  }

  ponerSignoS(){
    if(_txtJugada.text.indexOf('s') != -1)
      return;

    if(_txtJugada.text.length != 4)
      return;
    
    
    _txtJugada.text = _txtJugada.text + 's';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
  }

  ponerPunto() async {
    if(_txtJugada.text.indexOf('.') != -1)
      return;

    if(_txtJugada.text.length != 2 && _txtJugada.text.length != 4 && _txtJugada.text.length != 6)
      return;
    
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    _txtJugada.text = _txtJugada.text + '.';
  }

  bool esCaracterEspecial(String caracter){
    try {
       double.parse(caracter);
       return false;
    } catch (e) {
      return true;
    }
  }

   _seleccionarPrimeraLoteria(){
    if(listaLoteria == null)
      return;

    if(listaLoteria.length == 0)
      return;

    _loterias = [];
    // final selectedValuesMap = listaLoteria.asMap();
    _loterias.add(listaLoteria[0]);
  }

  _seleccionarSiguienteLoteria(){
    if(listaLoteria == null)
      return;

    if(listaLoteria.length == 0)
      return;

    //Validamos que solo haya una loteria seleccionada
    if(_loterias.length > 1)
      return;

    //Si no hay ninguna loteria seleccionada pues seleccionamos la primera
    if(_loterias.length == 0){
      setState(() => _seleccionarPrimeraLoteria());
      return;
    }
      
    int idx = listaLoteria.indexWhere((element) => element.id == _loterias[0].id);
    if(idx != -1){
      //Si es la ultima loteria pues entonces seleccionamos la primera
      if(listaLoteria.length == idx + 1){
        _seleccionarPrimeraLoteria();
        return;
      }

      setState(() {
        _loterias = [];
      // final selectedValuesMap = listaLoteria.asMap();
      _loterias.add(listaLoteria[idx + 1]);
      });

    }
  }

   _combinarJugadas(){
    List<String> combinacionesJugadas = Utils.generarCombinaciones(_txtJugada.text.substring(0, _txtJugada.text.length - 1));
    // print("Combinaciones retornadas: ${combinacionesJugadas.length}");
    double montoJugada = Utils.toDouble(_txtMonto.text);
    for(int i=0; i < combinacionesJugadas.length; i++){
      // print("Combinaciones retornadas for antes: ${combinacionesJugadas[i]}");
      // for(int il=0; il < _selectedLoterias.length; il++){
      //   double montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(combinacionesJugadas[i]), _selectedLoterias[il], await _selectedBanca());
      //   if(montoDisponible < montoJugada){
      //     Utils.showAlertDialog(context: context,title: "No hay disponibilidad",content: "No hay monto disponible para la jugada ${combinacionesJugadas[i]} en la loteria ${_selectedLoterias[il].descripcion}");
      //     return;
      //   }
      // }

      addJugada(jugada: Utils.ordenarMenorAMayor((combinacionesJugadas[i])), monto: _txtMonto.text);
      // print("Combinaciones retornadas for despues: ${combinacionesJugadas[i]}");
    
    }
  }


  Future<void> _escribir(String caracter) async {
    print("Hey: $caracter");
    if(caracter == '.'){
      // if(_txtJugada.text.isEmpty && listaJugadas.length >= 2){
      //   _showLigarDialog();
      //   return;
      // }
    }
    // if(caracter == 'S'){
    //   if(_txtJugada.text.isEmpty && _loterias.length == 2)
    //     _showLigarDialog();
    //   return;
    // }
    if(caracter == '/'){
        _seleccionarSiguienteLoteria();
        return;
    }
    if(caracter == 'ENTER'){
      if(_jugadaOmonto){
        setState((){
          _jugadaOmonto = !_jugadaOmonto;
          _txtMontoPrimerCaracter = true;
        });
      }else{
        if(_txtJugada.text.indexOf(".") != -1){
          _combinarJugadas();
          setState(() => _jugadaOmonto = !_jugadaOmonto);
        }
        else{
          addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), monto: _txtMonto.text);
        }
      }
      return;
    }

    if(_jugadaOmonto){
      if(caracter == 'backspace'){
        setState(() => _txtJugada.text = (_txtJugada.text.length > 0) ? _txtJugada.text.substring(0, (_txtJugada.text).length - 1) : _txtJugada.text);
        return;
      }
      else if(_txtJugada.text.length < 6 || (_txtJugada.text.length == 6 && caracter == ".")){
        if(esCaracterEspecial(caracter) == false)
          _txtJugada.text = _txtJugada.text + caracter;
        else{
          if(caracter == '+'){
            ponerSignoMas();
          }
          if(caracter == '-'){
            ponerSignoMenos();
          }
          if(caracter == 'S'){
            ponerSignoS();
          }
          if(caracter == '.'){
            if(esCaracterEspecial(_txtJugada.text) == false)
              ponerPunto();
          }
        }
      }
    }else{
      if(caracter == 'backspace'){
        setState(() => _txtMonto.text = (_txtMonto.text.length > 0) ? _txtMonto.text.substring(0, (_txtMonto.text).length - 1) : _txtMonto.text);
        return;
      }else if(_txtMonto.text.length < 6){
        if(esCaracterEspecial(caracter) == false){
          if(_txtMontoPrimerCaracter){
            _txtMonto.text = caracter;
            setState(() => _txtMontoPrimerCaracter = false);
          }
          else
            _txtMonto.text = _txtMonto.text + caracter;
        }
        else{
          if(caracter == '.'){
            ponerPuntoEnMonto();
          }
          
        }
      }
    }
  }


  SizedBox _buildButton({@required dynamic widget, @required dynamic value, Color color, Color textColor, @required double height, @required int countWidth, @required int countHeight, double fontSize = 22}){
    return SizedBox(
        width: MediaQuery.of(context).size.width / countWidth,
        height: height / countHeight,
        child: InkWell(
          onTap: (){
            _escribir(value);
          },
          child: Container(color: color != null ? color : Colors.white, child: Center(child: widget is Widget ? widget : Text("$widget", style: TextStyle(fontSize: fontSize, color: textColor != null ? textColor : Colors.black),))),
        ),
      );
  }

  

  addJugada({String jugada, String monto}) async {
    if(_loterias.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
      return;
    }

      jugada = Utils.ordenarMenorAMayor(jugada);
      List<Jugada> jugadasTmp = List.from(_jugadas);
      for (var loteria in _loterias) {
        Draws sorteo = await Utils.getSorteo(jugada);
        if(sorteo == null){
          Utils.showAlertDialog(context: context, title: "Error", content: "El sorteo no existe");
          return;
        }

        if(loteria.sorteos.indexWhere((element) => element.id == sorteo.id) == -1){
          String mensajeSorteo = sorteo != null ? "El sorteo ${sorteo.descripcion}" : "Este sorteo";
          Utils.showAlertDialog(context: context, title: "Error", content: "$mensajeSorteo no pertenece a la loteria ${loteria.descripcion}");
          return;
        }

        if(jugadasTmp.indexWhere((element) => element.loteria.id == loteria.id && element.jugada == jugada) == -1)
          jugadasTmp.add(Jugada(loteria: loteria, sorteo: sorteo.descripcion, idSorteo: sorteo.id, jugada: jugada, monto: Utils.toDouble(monto)));
        else{
          var esSi = await showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text("Jugada existe"),
                content: RichText(
                  
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: "La jugada "),
                    TextSpan(text: "${jugada} ", style: TextStyle(fontWeight: FontWeight.w800)),
                    TextSpan(text: "existe en la loteria "),
                    TextSpan(text: "${loteria.descripcion} ", style: TextStyle(fontWeight: FontWeight.w800)),
                    TextSpan(text: "desea agregar?"),
                  ]
                )),
                actions: [
                  TextButton(onPressed: (){Navigator.pop(context, false);}, child: Text("No")),
                  TextButton(onPressed: (){Navigator.pop(context, true);}, child: Text("Si")),
                ],
              );
            }
          );
          if(esSi){
            int index = jugadasTmp.indexWhere((element) => element.loteria.id == loteria.id && element.jugada == jugada);
            jugadasTmp[index].monto += Utils.toDouble(monto);
          }
          
        }

        
        
      }

      _jugadas = List.from(jugadasTmp);
      _streamControllerJugada.add(_jugadas);
      _txtJugada.text = "";
      setState(() => _jugadaOmonto = !_jugadaOmonto);

  }

  _loteriasChanged() async {
    var dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar loterias",
          items: listaLoteria.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: _loterias.length == 0 ? [] : _loterias.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    if(dataRetornada != null)
      setState(() => _loterias = List.from(dataRetornada));
  }

  _bancasChanged() async {
    var dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar bancas",
          items: listaBanca.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    if(dataRetornada != null)
      setState(() => _bancas = List.from(dataRetornada));
  }

  _monedaChanged(Moneda data){
    setState(() => _selectedMoneda = data);
  }

   
  _showMonedas(){
    showMyModalBottomSheet(
      context: context,
      myBottomSheet2: MyBottomSheet2(
        child: Column(
          children: listaMoneda.map((e) => CheckboxListTile(title: Text(e.descripcion), controlAffinity: ListTileControlAffinity.leading, value: _selectedMoneda == e, onChanged: (value){setState(() => _selectedMoneda = e); _monedaChanged(e); Navigator.pop(context);},)).toList(),
        ),
      )
    );
  }

   _tipoChanged(String data){
    setState(() => _selectedTipo = data);
  }

  _showTipos(){
    showMyModalBottomSheet(
      context: context,
      myBottomSheet2: MyBottomSheet2(
        child: Column(
          children: listaTipo.map((e) => CheckboxListTile(title: Text("$e"), controlAffinity: ListTileControlAffinity.leading, value: _selectedTipo == e, onChanged: (value){setState(() => _selectedTipo = e); _tipoChanged(e); Navigator.pop(context);},)).toList(),
        ),
      )
    );
  }

  _subtitle(bool isSmallOrMedium){
    return !isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Row(
      children: [
        InkWell(
          onTap: _showTipos,
          child: Row(children: [
            Text("${_selectedTipo != null ? _selectedTipo : ''}", style: TextStyle(color: Colors.black),),
            Icon(Icons.arrow_drop_down, color: Colors.black)
          ],),
        )
      ],
    );
  }

  _buildRichOrTextAndConvertJugadaToLegible(String jugada){
   if(jugada.length == 4 && jugada.indexOf('+') == -1 && jugada.indexOf('-') == -1){
     return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4), style: TextStyle(fontSize: 16));
   }
   else if(jugada.length == 3){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 3)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 4 && jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 3)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 5 && jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 4)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 5 && jugada.indexOf('-') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 4)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
  else if(jugada.length == 6){
     return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6), style: TextStyle(fontSize: 16));
  }

   return Text(jugada, style: TextStyle(fontSize: 16));
 }



  Widget _buildTable(List<Jugada> jugadas){
   var tam = jugadas.length;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[
          
        ];
   }else{
     rows = jugadas.map((j)
          => TableRow(
            children: [
              Center(child: Text(Utils.esSuperpale(j.jugada) ? "SP(${j.abreviatura}/${j.abreviaturaSuperpale})" : j.descripcion, style: TextStyle(fontSize: Utils.esSuperpale(j.jugada) ? 14 : 16))),
              Center(child: _buildRichOrTextAndConvertJugadaToLegible(j.jugada)),
              Center(child: Text(j.monto.toString(), style: TextStyle(fontSize: 16))),
              Center(child: IconButton(icon: Icon(Icons.delete, size: 28,), onPressed: () async {
                setState((){
                  _jugadas.remove(j);
                  _streamControllerJugada.add(_jugadas);
                  // await removeEstadisticaJugada(jugada: j.jugada, idLoteria: j.idLoteria);
                });
              },)),
            ],
          )
        
        ).toList();
        
    rows.insert(0, 
              TableRow(
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Center(child: Text('Loteria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  Center(child: Text('Jugada', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                  Center(child: Text('Monto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                  Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                ]
              )
              );
        
   }

  return Flexible(
      child: ListView(
      children: <Widget>[
        Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
            children: rows,
           ),
      ],
    ),
  );
   
 }


  

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    _tabController = TabController(length: 2, vsync: this);
    _streamControllerMoneda = BehaviorSubject();
    _streamControllerJugada = BehaviorSubject();
    _future = _init();
    super.initState();
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
          title: Row(
            children: [
              InkWell(
                onTap: _showTipos,
                child: Row(children: [
                  Text("${_selectedTipo != null ? _selectedTipo : ''}", style: TextStyle(color: Colors.black),),
                  Icon(Icons.arrow_drop_down, color: Colors.black)
                ],),
              )
            ],
          ),
          actions: [
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return MyDropdown(title: null, 
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: (){
                        showMyOverlayEntry(
                          right: 10,
                            context: context,
                            builder: (context, overlay){
                              _cancel(){
                                overlay.remove();
                              }
                              return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
                                _dateChanged(date); 
                                overlay.remove();
                              },);
                            }
                          );
                      },
                    );
                  }
                ),
              ), 
              onTap: (){}
              ),
            MySliverButton(
              title: Container(
                width: 52,
                // color: Colors.grey[100],
                child: StreamBuilder<List<Moneda>>(
                  stream: _streamControllerMoneda.stream,
                  builder: (context, snapshot) {
                    if(snapshot.data == null)
                      return SizedBox.shrink();

                    return InkWell(
                      onTap: _showMonedas,
                      child: Row(children: [
                        Text("${_selectedMoneda != null ? _selectedMoneda.abreviatura : ''}", style: TextStyle(color: _selectedMoneda != null ? Utils.fromHex(_selectedMoneda.color) : Colors.black),),
                        Icon(Icons.arrow_drop_down, color: Colors.black)
                      ],),
                    );
                  }
                ),
              ), 
              onTap: _showMonedas
              ),
            MySliverButton(
              title: Container(
                width: 130,
                height: 37,
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                decoration: BoxDecoration(
                color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: StreamBuilder<List<Moneda>>(
                  stream: _streamControllerMoneda.stream,
                  builder: (context, snapshot) {
                    if(snapshot.data == null)
                      return SizedBox.shrink();

                    return InkWell(
                      onTap: (){
                        showMyModalBottomSheet(
                          context: context,
                          myBottomSheet2: MyBottomSheet2(
                            height: 450,
                            child: MyDateRangeDialog(
                              date: _date, 
                              listaFecha: MyDate.listaFechaFuturo,
                              onCancel: () => Navigator.pop(context), 
                              onOk: (date){
                                  print("BloqueoPorJugadasScreen date: ${date}");
                                  _dateChanged(date); 
                                  Navigator.pop(context);
                                  // overlay.remove();
                                },
                              )
                                  
                          )
                        );
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Icon(Icons.date_range),
                          Expanded(child: Center(child: Text("${MyDate.dateRangeToNameOrString(_date)}", style: TextStyle(color: _selectedMoneda != null ? Utils.fromHex(_selectedMoneda.color) : Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,))),
                          Icon(Icons.arrow_drop_down, color: Colors.black)
                        ],),
                      ),
                    );
                  }
                ),
              ), 
              onTap: _showMonedas
              ),
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
            return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );

            return SliverFillRemaining(
              child: Column(
                // mainAxisAlignment: ,
                children: [
                  MyTabBar(controller: _tabController, tabs: ["Bloquear", "Jugadas [${_jugadas.length}]"], isScrollable: false,),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Visibility(
                                  visible: _selectedTipo == "Por banca",
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: _bancasChanged,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: MyResizedContainer(
                                            small: 1,
                                            medium: 1,
                                            child: Center(child: Text("${_bancas.length > 0 ? _bancas.length != listaBanca.length ? _bancas.length == 1 ? 'Banca: ' + _bancas[0].descripcion : 'Bancas: [' + _bancas.length.toString() + ']' : 'Banca: Todas' : 'Seleccionar loterias...'}", style: TextStyle(fontSize: _bancas.length > 0 ? 16 : 22))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _loteriasChanged,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: MyResizedContainer(
                                        small: 1,
                                        medium: 1,
                                        child: Center(child: Text("${_loterias.length > 0 ? _loterias.length != listaLoteria.length ? _loterias.map((e) => e.descripcion).toList().join(", ") : 'Todas las loterias' : 'Seleccionar loterias...'}", style: TextStyle(fontSize: _loterias.length > 0 ? 16 : 22))),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text("Descontar del bloqueo general", style: TextStyle(fontSize: 12)),
                                        value: _descontarDelBloqueoGeneral,
                                        onChanged: (value) => setState(() => _descontarDelBloqueoGeneral = value),
                                      ),
                                    ),
                                    Flexible(
                                      child: CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text("Ignorar demas bloqueos", style: TextStyle(fontSize: 12)),
                                        value: _descontarDelBloqueoGeneral,
                                        onChanged: (value) => setState(() => _ignorarDemasBloqueos = value),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            MyResizedContainer(
                              small: 1,
                              medium: 1,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => setState(() => _jugadaOmonto = true),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          border: _jugadaOmonto ? Border.all(color: Colors.black, width: 1.5) : null,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: MyTextFormField(
                                          small: 2.5,
                                          medium: 2.5,
                                          type: MyType.noBorder,
                                          enabled: false,
                                          controller: _txtJugada,
                                          fontSize: 23,
                                          hint: "Jugada",
                                          
                                        )
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => setState(() => _jugadaOmonto = false),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(10),
                                          border: !_jugadaOmonto ? Border.all(color: Colors.black, width: 1.5) : null,
                                        ),
                                        child: MyTextFormField(
                                          small: 2.5,
                                          medium: 2.5,
                                          type: MyType.noBorder,
                                          enabled: false,
                                          controller: _txtMonto,
                                          fontSize: 23,
                                          hint: "Monto",
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: LayoutBuilder(
                                builder: (context, boxconstraint) {
                                  double height = boxconstraint.maxHeight > 400 ? 400 : boxconstraint.maxHeight;
                                  return Wrap(
                                    children: [

                                      _buildButton(widget: ".", value: ".", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "S", value: "S", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "D", value: "D", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: Icon(Icons.backspace, color: Theme.of(context).primaryColor,), value: "backspace", height: height, countWidth: 4, countHeight: 5),

                                      _buildButton(widget: "7", value: "7", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "8", value: "8", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "9", value: "9", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "/", value: "/", fontSize: 26, textColor: Theme.of(context).primaryColor, height: height, countWidth: 4, countHeight: 5),

                                      _buildButton(widget: "4", value: "4", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "5", value: "5", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "6", value: "6", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "-", value: "-", fontSize: 26, textColor: Theme.of(context).primaryColor, height: height, countWidth: 4, countHeight: 5),

                                      _buildButton(widget: "1", value: "1", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "2", value: "2", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "3", value: "3", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "+", value: "+", fontSize: 26, textColor: Theme.of(context).primaryColor, height: height, countWidth: 4, countHeight: 5),

                                      _buildButton(widget: "", value: null, height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "0", value: "0", height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(widget: "", value: null, height: height, countWidth: 4, countHeight: 5),
                                      _buildButton(
                                        widget: Material(
                                          elevation: 4,
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.green[100],
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Icon(Icons.check, color: Colors.green[700],),
                                          ),
                                        ), 
                                        value: "ENTER", 
                                        height: height, 
                                        countWidth: 4, 
                                        countHeight: 5
                                      ),
                                      
                                    ],
                                  );
                                }
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                                child: MyResizedContainer(
                                  small: 1,
                                  medium: 1,
                                  child: InkWell(
                                    onTap: (){
                                      setState(() => _jugadas = []);
                                      _streamControllerJugada.add(_jugadas);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(child: Text("Eliminar todas", style: TextStyle(fontSize: 16))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<List<Jugada>>(
                                stream: _streamControllerJugada.stream,
                                builder: (context, snapshot) {
                                  if(snapshot.data == null)
                                    return SizedBox.shrink();
                                  if(snapshot.data.length == 0)
                                    return SizedBox.shrink();

                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index){
                                      if(index == 0)
                                      return Wrap(
                                        children: [
                                          Wrap(
                                            children: [
                                              MyResizedContainer(
                                                small: 3.8,
                                                child: Center(child: Text("Loteria", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                              ),
                                              MyResizedContainer(
                                                small: 4,
                                                child: Center(child: Text("Jugada", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                              ),
                                              MyResizedContainer(
                                                small: 4,
                                                child: Center(child: Text("Monto", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                              ),
                                              MyResizedContainer(
                                                small: 5,
                                                child: Center(child: Text("Borrar", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                              ),
                                            ],
                                          ),
                                          Wrap(
                                            children: [
                                              MyResizedContainer(
                                                small: 3.8,
                                                child: Center(child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                                  child: Text("${snapshot.data[index].loteria.descripcion}", style: TextStyle(fontSize: 16),),
                                                )),
                                              ),
                                              MyResizedContainer(
                                                small: 4,
                                                child: Center(child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                                  child: _buildRichOrTextAndConvertJugadaToLegible(snapshot.data[index].jugada)
                                                )),
                                              ),
                                              MyResizedContainer(
                                                small: 4,
                                                child: Center(child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                                  child: Text("${snapshot.data[index].monto}", style: TextStyle(fontSize: 16),),
                                                )),
                                              ),
                                              MyResizedContainer(
                                                small: 5,
                                                child: Center(child: IconButton(icon: Icon(Icons.delete), onPressed: (){setState((){_jugadas.removeAt(index); _streamControllerJugada.add(_jugadas);});},)),
                                              ),
                                            ],
                                          ),
                                        
                                          // Wrap(
                                          //   children: [
                                          //     MyResizedContainer(
                                          //       small: 3,
                                          //       child: Center(child: Text("Loteria")),
                                          //     ),
                                          //     MyResizedContainer(
                                          //       small: 3,
                                          //       child: Center(child: Text("Jugada")),
                                          //     ),
                                          //     MyResizedContainer(
                                          //       small: 3,
                                          //       child: Center(child: Text("Monto")),
                                          //     ),
                                          //     MyResizedContainer(
                                          //       small: 3,
                                          //       child: Center(child: Text("Borrar")),
                                          //     ),
                                          //   ],
                                          // ),
                                        
                                        ],
                                      );
                              
                                      return Wrap(
                                        children: [
                                          MyResizedContainer(
                                            small: 3.8,
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                                              child: Text("${snapshot.data[index].loteria.descripcion}", style: TextStyle(fontSize: 16),),
                                            )),
                                          ),
                                          MyResizedContainer(
                                            small: 4,
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                                              child: _buildRichOrTextAndConvertJugadaToLegible(snapshot.data[index].jugada)
                                            )),
                                          ),
                                          MyResizedContainer(
                                            small: 4,
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                                              child: Text("${snapshot.data[index].monto}", style: TextStyle(fontSize: 16),),
                                            )),
                                          ),
                                          MyResizedContainer(
                                            small: 5,
                                            child: Center(child: IconButton(icon: Icon(Icons.delete), onPressed: (){_jugadas.removeAt(index); _streamControllerJugada.add(_jugadas);},)),
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                }
                              ),
                            )
                          ],
                        ),
                      ]
                    )
                  )
                ],
              ),
            );
          }
        )
      )
    );
  }
}