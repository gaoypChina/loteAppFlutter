import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';

class BloqueosPorJugadas extends StatefulWidget {
  const BloqueosPorJugadas({ Key key }) : super(key: key);

  @override
  _BloqueosPorJugadasState createState() => _BloqueosPorJugadasState();
}

class _BloqueosPorJugadasState extends State<BloqueosPorJugadas>  with TickerProviderStateMixin {
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

  addJugada({String jugada, String monto}){
    if(_loterias.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
      return;
    }

    String jugadaOrdenada = Utils.ordenarMenorAMayor(jugada);
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

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);

    _future = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Limitar jugadas",
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
                  MyTabBar(controller: _tabController, tabs: ["Bloquear", "Jugadas"], isScrollable: false,),
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
                        Text("Jugadas"),
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