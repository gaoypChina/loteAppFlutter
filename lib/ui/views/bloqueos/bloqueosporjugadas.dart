import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/extensions/groupByIterableExtension.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/core/services/sorteoservice.dart';
import 'package:loterias/ui/views/bancas/bancasmultiplesearch.dart';
import 'package:loterias/ui/views/bloqueos/dialogbloquearquinielasenotrossorteos.dart';
import 'package:loterias/ui/views/loterias/loteriasmultisearch.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/myresizedcheckbox.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/myhelper.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytable.dart';
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
  var _jugadaFocusNode = FocusNode();
  var _montoFocusNode = FocusNode();
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
  List<Grupo> listaGrupo = [];
  bool _descontarDelBloqueoGeneral = true;
  bool _ignorarDemasBloqueos = false;
  var _cargandoNotify = ValueNotifier<bool>(false);
  bool _jugadaOmonto = true;
  bool _txtMontoPrimerCaracter = true;
  List<MyFilterSubData2> _selectedFilter = [];
  List<MyFilterData2> listaFiltros = [];
  List<Grupo> _grupos = [];
  List<Jugada> _jugadas = [];
  bool _isSmallOrMedium = false;
  static String _opcionBloquearQuinielasEnOtrosSorteos = "BloquearQuinielasEnOtrosSorteos";
  List<Draws> _sorteosSeleccionadosParaBloquearQuinielas = [];


  _init() async {
    // _date = MyDate.getTodayDateRange();
    var parsed = await BloqueosService.index(context: context);
    listaBanca = (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((json) => Draws.fromMap(json)).toList() : [];
    listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
    listaGrupo = Grupo.fromMapList(parsed["grupos"]);

    // if(listaMoneda.length > 0)
    //   _selectedMoneda = listaMoneda[0];

    if(listaDia.length > 0)
      _dias = List.from(listaDia);

    _streamControllerMoneda.add(listaMoneda);

    print("BloqueosPorJugadasScreen: ${listaSorteo.length}");
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

    if(_txtJugada.text.length != 4 && _txtJugada.text.length != 2)
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
    if(caracter == '/' || caracter == 'ENTER'){
      seleccionarSiguienteLoteria(caracter);
      cambiarFocoOAgregarJugada(caracter);
    }else{
      if(focoEstaEnCampoJugada())
        manejarCaracteresJugada(caracter);
      else
        manejarCaracteresMonto(caracter);
    }
  }

  seleccionarSiguienteLoteria(String caracter){
    if(caracter == '/')
      _seleccionarSiguienteLoteria();
  }

  cambiarFocoOAgregarJugada(String caracter){
    if(caracter != 'ENTER') return;
    if(focoEstaEnCampoJugada())
      cambiarFocoEIndicarEsPrimerCaracter();
    else
      agregarOCombinarJugada();
  }

  cambiarFocoEIndicarEsPrimerCaracter(){
    setState((){
      _cambiarFocusJugadaMonto();
      _txtMontoPrimerCaracter = true;
    });
  }

  agregarOCombinarJugada() async {
    if(_txtJugada.text.indexOf(".") != -1){
      _combinarJugadas();
      setState(() => _jugadaOmonto = !_jugadaOmonto);
    }
    else{
      if(_sorteosSeleccionadosParaBloquearQuinielas.length > 0){
        for(var sorteo in _sorteosSeleccionadosParaBloquearQuinielas)
          await addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), monto: _txtMonto.text, sorteoPaleTripletaOSuperpaleParaBloquearQuiniela: sorteo);
      }
      await addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), monto: _txtMonto.text);
      cambiarFocoEIndicarEsPrimerCaracter();
    }
  }

  focoEstaEnCampoJugada(){
   return _jugadaOmonto; 
  }

  manejarCaracteresJugada(String caracter){
    if(caracter == 'backspace')
        eliminarUltimoCaracter(jugada: true);
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
  }

  manejarCaracteresMonto(String caracter){
    if(caracter == 'backspace')
      eliminarUltimoCaracter(jugada: false);
    else if(_txtMonto.text.length < 6){
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

  eliminarUltimoCaracter({bool jugada}){
    if(jugada)
      setState(() => _txtJugada.text = (_txtJugada.text.length > 0) ? _txtJugada.text.substring(0, (_txtJugada.text).length - 1) : _txtJugada.text);
    else
      setState(() => _txtMonto.text = (_txtMonto.text.length > 0) ? _txtMonto.text.substring(0, (_txtMonto.text).length - 1) : _txtMonto.text);
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



   

  Future<void> addJugada({String jugada, String monto, Draws sorteoPaleTripletaOSuperpaleParaBloquearQuiniela = null}) async {
    try {
      validarLoteriasSeleccionadas();
      jugada = Utils.ordenarMenorAMayor(jugada);
      List<Jugada> jugadasTmp = List.from(_jugadas);
      for (var loteria in _loterias) {
        print("BloqueosPorJugadas addJugada jugada: $jugada");
        Draws sorteo;
        if(sorteoPaleTripletaOSuperpaleParaBloquearQuiniela != null)
          sorteo = sorteoPaleTripletaOSuperpaleParaBloquearQuiniela;
        else
          sorteo = await obtenerYValidarSorteo(jugada);
        if(sorteoPerteneceALoteria(loteria, sorteo))
          await insertarOActualizarJugada(loteria: loteria, sorteo: sorteo, monto: monto, jugada: jugada);
        // _jugadas = List.from(jugadasTmp);
        _streamControllerJugada.add(_jugadas);
        if(sorteoPaleTripletaOSuperpaleParaBloquearQuiniela == null)
          _txtJugada.text = "";
      // setState(() => _jugadaOmonto = !_jugadaOmonto);
      }
    } on Exception catch (e) {
      Utils.showAlertDialog(context: context, title: "Error", content: "$e");
    }

      

      

  }

  validarLoteriasSeleccionadas(){
    if(_noHayLoteriasSeleccionadas()){
      throw new Exception("No hay loterias seleccionadas");
      // Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
      // return;
    }
  }

  _noHayLoteriasSeleccionadas(){
    return _loterias.length == 0;
  }

  Future<Draws> obtenerYValidarSorteo(String jugada) async {
    Draws sorteo = await SorteoService.getSorteo(jugada);
    if(sorteo == null){
      throw Exception("El sorteo no existe");
    }
    return sorteo;
  }

  bool sorteoPerteneceALoteria(Loteria loteria, Draws sorteo){
    if(loteria.sorteos.indexWhere((element) => element.id == sorteo.id) == -1){
      String mensajeSorteo = sorteo != null ? "El sorteo ${sorteo.descripcion}" : "Este sorteo";
      // throw Exception("$mensajeSorteo no pertenece a la loteria ${loteria.descripcion}");
      return false;
    }
    return true;
  }

  Future<void> insertarOActualizarJugada({Loteria loteria, Draws sorteo, String jugada, String monto}) async {
    if(jugadaExiste(loteria, sorteo, jugada))
      await actualizarJugadas(loteria: loteria, sorteo: sorteo, jugada: jugada, monto: monto);
    else
      _jugadas.add(Jugada(loteria: loteria, idLoteria: loteria.id, sorteo: sorteo.descripcion, idSorteo: sorteo.id, jugada: jugada, monto: Utils.toDouble(monto)));
  }

  jugadaExiste(Loteria loteria, Draws sorteo, String jugada){
    int indexSorteo = _jugadas.indexWhere((element) => element.loteria.id == loteria.id && element.jugada == jugada && element.idSorteo == sorteo.id);
    print("BloqueosPorJugadas.dart jugadaExiste: ${indexSorteo}");
    return indexSorteo != -1;
  }

  Future<void> actualizarJugadas({Loteria loteria, Draws sorteo, String jugada, String monto}) async {
    if(await usuarioDeseaActualizar(loteria, jugada)){
      int index = _jugadas.indexWhere((element) => element.loteria.id == loteria.id && element.jugada == jugada);
      _jugadas[index].monto += Utils.toDouble(monto);
    }
  }

  Future<bool> usuarioDeseaActualizar(Loteria loteria, String jugada) async {
    return await showDialog(
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
                TextSpan(text: "${loteria.descripcion}, ", style: TextStyle(fontWeight: FontWeight.w800)),
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
  }

  _bancasChanged() async {
    if(_selectedMoneda == null){
      Utils.showAlertDialog(context: context, title: "Advertencia", content: "Debe seleccionar una moneda");
      return;
    }
    var listaBancaTmp = listaBanca.where((element) => element.idMoneda == _selectedMoneda.id).toList();
    if(listaBancaTmp.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay bancas");
      return;
    }

    List<Banca> dataRetornada = [];
    if(_esVentanaPequena())
      dataRetornada = await showSearch(context: context, delegate: BancasMultipleSearch(listaBancaTmp, _bancas, listaGrupo, []));
    else
      dataRetornada = await showDialog(
        context: context, 
        builder: (context){
          return MyMultiselect(
            title: "Agregar bancas",
            items: listaBancaTmp.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
            initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
          );
        }
      );

    if(dataRetornada != null){
      List<Banca> bancasSeleccionadas = List<Banca>.from(dataRetornada);
      setState(() => _bancas = Banca.unicas(listaBanca, bancasSeleccionadas));
    }
  }

  _monedaChanged(Moneda data){
    setState((){
      _selectedMoneda = data;
      _bancas = _bancas.where((element) => element.idMoneda == _selectedMoneda.id).toList();
    });
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

  Widget _tipoReglaScreen(){
    return 
    _esPantallaGrande()
    ?
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: MyDropdownButton(
        // largeSide: 1.2,
        // isSideTitle: true,
        xlarge: 6,
        large: 6,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11.0),
        type: MyDropdownType.border,
        title: "Tipo bloqueo *",
        // helperText: "${_selectedTipo == 'General' ? 'Todas las bancas tendrán el mismo limite y se descontarán del mismo' : 'Cada banca tendrá su propio limite aparte de las demas'} ",
        value: _selectedTipo,
        items: listaTipo.map((e) => [e, "$e"]).toList(),
        onChanged: (data){
          _tipoChanged(data);
        }
      ),
    )
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

  Widget _monedaScreen(){
    return 
    _esPantallaGrande()
    ?
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: StreamBuilder<List<Moneda>>(
        stream: _streamControllerMoneda.stream,
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return SizedBox.shrink();

          return MyDropdownButton(
            // largeSide: 1.2,
            // isSideTitle: true,
            xlarge: 6,
            large: 6,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11.0),
            type: MyDropdownType.border,
            title: "Moneda*",
            hint: "Selec. moneda",
            // helperText: "Solo afectará a las bancas que tengan asignadas esta moneda",
            value: _selectedMoneda,
            items: listaMoneda.map((e) => [e, "${e.descripcion}"]).toList(),
            onChanged: (data){
              _monedaChanged(data);
            }
          );
        }
      ),
    )
    :
    Container(
              width: 110,
              height: 37,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
              decoration: BoxDecoration(
              color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child: StreamBuilder<List<Moneda>>(
                stream: _streamControllerMoneda.stream,
                builder: (context, snapshot) {
                  if(snapshot.data == null)
                    return SizedBox.shrink();
    
                  return InkWell(
                    onTap: (){
                      
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Icon(Icons.attach_money),
                        Expanded(child: Center(child: 
                        StreamBuilder<List<Moneda>>(
                          stream: _streamControllerMoneda.stream,
                          builder: (context, snapshot) {
                            if(snapshot.data == null)
                              return SizedBox.shrink();

                            return InkWell(
                              onTap: _showMonedas,
                              child: Text("${_selectedMoneda != null ? _selectedMoneda.abreviatura : 'Moneda'}", style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,),
                            );
                          }
                        )
                      )
                      ),
                        Icon(Icons.arrow_drop_down, color: Colors.black)
                      ],),
                    ),
                  );
                }
              ),
            );
          
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 62,
        // color: Colors.grey[200],
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
    );
  }

  Widget _bancaScreen(){
    if(_esPantallaGrande())
      return Visibility(
        visible: _selectedTipo == "Por banca",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
          child: MyDropdown(
            // xlarge: 1.35,
            // large: 1.2,
            // medium: 1.35,
            // small: 1,
            // isSideTitle: true,
            onlyBorder: true,
            xlarge: 6,
            large: 6,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7.0),
            textColor: Colors.black,
            title: "Bancas *",
            helperText: "Seran las bancas afectadas por el bloqueo deseado",
            hint: "${_bancas.length > 0 ? _bancas.map((e) => e.descripcion).toList().join(", ") : 'Seleccionar las bancas...'}",
            onTap: _bancasChanged,
          ),
        ),
      );

    return Visibility(
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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child: MyResizedContainer(
                small: 1,
                medium: 1,
                child: Center(child: Text("${_bancas.length > 0 ? _bancas.length != listaBanca.length ? _bancas.length == 1 ? 'Banca: ' + _bancas[0].descripcion : 'Bancas: [' + _bancas.length.toString() + ']' : 'Banca: Todas' : 'Seleccionar bancas...'}", style: TextStyle(fontSize: 16))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fechaScreen(){
    if(_esPantallaGrande())
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Builder(
          builder: (context) {
            return MyDropdown(
              // xlarge: 1.35,
              // large: 1.2,
              // medium: 1.35,
              // small: 1,
              // isSideTitle: true,
              xlarge: 6,
              large: 6,
              title: "Fecha *", 
              helperText: "Hasta cuando será valido el bloqueo",
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              hint: "${MyDate.dateRangeToNameOrString(_date, 'Fecha')}",
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
      );

    
    return MyDropdown(
      title: null, 
      hint: "${MyDate.dateRangeToNameOrString(_date, 'Fecha')}",
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

  Widget _ignorarDemasBloqueosScreen(){
    return Visibility(
      visible: _selectedTipo == "General",
      child: 
      _esPantallaGrande()
      ?
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 8.0),
        child: Wrap(
          children: [
            MyCheckBox(
              title: "Ignorar demas bloqueos",
              value: _ignorarDemasBloqueos,
              onChanged: (value) => setState(() => _ignorarDemasBloqueos = value),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 8.0),
              child: MyHelper(mensaje: "Se ignorarán todos los bloqueos que existen y estos se van a establecer por encima de ellos.",),
            )
          ],
        ),
      )
      :
      CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text("Ignorar demas bloqueos", style: TextStyle(fontSize: 12)),
        value: _ignorarDemasBloqueos,
        onChanged: (value) => setState(() => _ignorarDemasBloqueos = value),
      )
    );
  }

  Widget _descontarBloqueoGeneralScreen(){
    return Visibility(
      visible: _selectedTipo == "Por banca",
      child: 
      _esPantallaGrande()
      ?
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 8.0),
        child: Wrap(
          children: [
            MyCheckBox(
              title: "Descontar del bloqueo general",
              value: _descontarDelBloqueoGeneral,
              onChanged: (value) => setState(() => _descontarDelBloqueoGeneral = value)
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 8.0),
              child: MyHelper(mensaje: "Se descontará del bloqueo general, de lo contrario las bancas tendrán su propio limite y estaran fuera del bloqueo general",),
            )
          ],
        ),
      )
      // Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      //   child: MyResizedCheckBox(
      //     // xlarge: 1.33,
      //     // large: 1.2,
      //     // medium: 1.35,
      //     // small: 1,
      //     // isSideTitle: true,
      //     xlarge: 6,
      //     large: 6,
      //     title: "Descontar del bloqueo general",
      //     titleSideCheckBox: "Descontar",
      //     helperText: "Se descontará del bloqueo general, de lo contrario las bancas estan tendrán su propio limite y estaran fuera del bloqueo general",
      //     value: _descontarDelBloqueoGeneral,
      //     onChanged: (value) => setState(() => _descontarDelBloqueoGeneral = value),
      //   ),
      // )
      :
      CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text("Descontar del bloqueo general", style: TextStyle(fontSize: 12)),
        value: _descontarDelBloqueoGeneral,
        onChanged: (value) => setState(() => _descontarDelBloqueoGeneral = value),
      )
    );
  }

  Widget _loteriaScreen(){
    if(_esPantallaGrande())
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: MyDropdown(
          // xlarge: 1.35,
          // large: 1.2,
          // medium: 1.35,
          // small: 1,
          // isSideTitle: true,
          // onlyBorder: true,
          xlarge: 4,
          large: 4,
          medium: 3.3,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
          // textColor: Colors.black,
          title: "Loterias *",
          helperText: "Seran las loterias afectadas por el bloqueo deseado",
          // hint: "${_loterias.length > 0 ? _loterias.length != listaLoteria.length ? _loterias.map((e) => e.descripcion).toList().join(", ") : 'Todas las loterias' : 'Seleccionar loterias...'}",
          hint: _getDescripcionLoteriasSeleccionadas(),
          onTap: _loteriasChanged,
        ),
      );

    return GestureDetector(
      onTap: _loteriasChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)
          ),
          child: MyResizedContainer(
            small: 1,
            medium: 1,
            child: Center(child: Text(_getDescripcionLoteriasSeleccionadas(), style: TextStyle(fontSize: 16))),
          ),
        ),
      ),
    );
  }

  _loteriasChanged() async {
    var dataRetornada;
    if(_esVentanaPequena())
      dataRetornada = await showSearch(context: context, delegate: LoteriasMultipleSearch(listaLoteria, _loterias));
    else
      dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar loterias",
          items: listaLoteria.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: _loterias.length == 0 ? [] : _loterias.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    if(dataRetornada != null){
       List<Loteria> loteriasSeleccionadas = List<Loteria>.from(dataRetornada);
      setState(() => _loterias = Loteria.unicas(listaLoteria, loteriasSeleccionadas));
    }
  }

  _getDescripcionLoteriasSeleccionadas(){
    String loteriasSeleccionadas = "Seleccionar loterias...";
    if(_loterias.length > 0 && _loterias.length != listaLoteria.length)
      loteriasSeleccionadas = _loterias.map((e) => e.descripcion).toList().join(", ");
    else if(_loterias.length > 0 && _loterias.length == listaLoteria.length)
      loteriasSeleccionadas = "Todas las loterias";
    // loteriasSeleccionadas = "${  : 'Todas las loterias' : 'Seleccionar loterias...'}";
    if(loteriasSeleccionadas.length >= 100)
      loteriasSeleccionadas = "Loterias: [${_loterias.length}]";
    return loteriasSeleccionadas;
  }

  _cambiarFocusJugadaMonto(){
    if(_esPantallaGrande()){
      _jugadaOmonto = !_jugadaFocusNode.hasFocus;
      if(_jugadaOmonto)
        _jugadaFocusNode.requestFocus();
      else
        _montoFocusNode.requestFocus();

      return;
    }


    setState((){
      _jugadaOmonto = !_jugadaOmonto;
      // print("PrincipalView _cambiarFocusJugadaMonto: $_jugadaOmonto");
    });
  }

  Widget _jugadaTextField(){
    return Column(
      children: [
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) { 
            // print("Event runtimeType is ${event.runtimeType}");
            if(event.runtimeType.toString() != 'RawKeyUpEvent')
              return;
            print("PrincipalView _jugadaTextField onChanged ${event.data.keyLabel}");
            if(event.logicalKey == LogicalKeyboardKey.backspace)
              return;

            if(event.data.keyLabel.isEmpty)
              return;

            
            // _txtJugada.text = _txtJugada.text.substring(0, _txtJugada.text.length - 1);
            if(event.data.keyLabel.indexOf(RegExp("[\+\-\/sS\.]")) != -1)
              _escribir(event.data.keyLabel);
            // Future.delayed(Duration(milliseconds: 500), (){_escribir(event.data.keyLabel);});
            
          },
          child: TextField(
            controller: _txtJugada,
            focusNode: _jugadaFocusNode,
            autofocus: _esPantallaGrande(),
            enabled: _esPantallaGrande(),
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              isDense: _esPantallaGrande() ? false : true,
              // alignLabelWithHint: true,
              border: _esPantallaGrande() ? null : InputBorder.none,
              hintText: _esPantallaGrande() ? null : 'Jugada',
              labelText: _esPantallaGrande() ? 'Jugada' : null,
              fillColor: Colors.transparent,
              // filled: true,
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            textAlign: _esPantallaGrande() ? TextAlign.left : TextAlign.center,
            inputFormatters: _esPantallaGrande() ? [] : [
              LengthLimitingTextInputFormatter(6),

              // WhitelistingTextInputFormatter.digitsOnly,
              // FilteringTextInputFormatter.digitsOnly
              // FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}(\+|\d[\+\-sS]|\d\d\d|\d)?$'))
              FilteringTextInputFormatter.allow(RegExp(r'^\d{1,2}(\d|\-)*(\+|\d[\+\-sS]|\d\d\d|\d)?$'))
            ],
            onSubmitted: (data){
              _cambiarFocusJugadaMonto();
            }
            // onChanged: (String data){
            //   print("PrincipalView _jugadaTextField onChanged: $data");
            //   // _escribir(data);
            // },
            // expands: false,
          ),
        ),
        _sorteoWidget(),
      ],
    );
  }

  _sorteoWidget(){
    return Padding(
          padding: _esPantallaGrande() ? EdgeInsets.only(top: 8.0) : EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: listaSorteo.where((element) => Draws.esIdPaleTripletaOSuperpale(element.id)).toList().asMap().map((index, sorteo) => MapEntry(index, _sorteoItemWidget(sorteo, index))).values.toList()
          )
    );
  }

  Widget _sorteoItemWidget(Draws sorteo, int index){
    bool esPrimerElemento = index == 0;
    return Padding(
      padding: EdgeInsets.only(left: esPrimerElemento ? 0.0 : 6.0, right: 6.0),
      child: InkWell(
        onTap: () => _seleccionarSorteo(sorteo),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
          decoration: BoxDecoration(
            color: _estaSeleccionado(sorteo) ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text(sorteo.descripcion, style: TextStyle(color: _estaSeleccionado(sorteo) ? Colors.white : null, fontSize: 11, fontWeight: FontWeight.w700),),
        ),
      ),
    );
  }

  void _seleccionarSorteo(Draws sorteo){
    if(_estaSeleccionado(sorteo))
      setState(() => _sorteosSeleccionadosParaBloquearQuinielas.removeWhere((element) => element.id == sorteo.id));
    else
      setState(() => _sorteosSeleccionadosParaBloquearQuinielas.add(sorteo));
  }

  bool _estaSeleccionado(Draws sorteo){
    Draws sorteoEncontrado = _sorteosSeleccionadosParaBloquearQuinielas.firstWhere((element) => element.id == sorteo.id, orElse: () => null);
    bool estaSeleccionado = sorteoEncontrado != null;
    return estaSeleccionado;
  }

  TextField _montoTextField(){
    return TextField(
      controller: _txtMonto,
      focusNode: _montoFocusNode,
      enabled: _esPantallaGrande(),
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        isDense: _esPantallaGrande() ? false : true,
        border: _esPantallaGrande() ? null : InputBorder.none,
        hintText: _esPantallaGrande() ? null : 'Monto',
        labelText: _esPantallaGrande() ? 'Monto' : null,
        fillColor: Colors.transparent,
        // filled: true,
        hintStyle: TextStyle(fontWeight: FontWeight.bold)
      ),
      textAlign: _esPantallaGrande() ? TextAlign.left : TextAlign.center,
      onSubmitted: (data) async {
        _escribir("ENTER");
        // await addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), montoDisponible: _txtMontoDisponible.text, monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
      },
    );
  }
 
  _title(){
    return
    _esVentanaPequena()
    ?
    _tipoReglaScreen()
    :
    "Limite por jugadas";
  }

  _subtitle(){
    return _esPantallaGrande()
    ?
    "Aqui puede limitar jugadas especificas de manera general, por bancas y loterias."
    :
    MyCollapseChanged(
      actionWhenCollapse: MyCollapseAction.hide,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
          Container(
              width: 140,
              height: 37,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
              decoration: BoxDecoration(
              color: Colors.grey[200],
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
                        Expanded(child: Center(child: Text("${MyDate.dateRangeToNameOrString(_date, 'Fecha')}", style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,))),
                        Icon(Icons.arrow_drop_down, color: Colors.black)
                      ],),
                    ),
                  );
                }
              ),
            ), 
          
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _monedaScreen(),
          )
    
          ],
        ),
      ),
    );
                            
  }

  _tipoReglaWidget(bool isSmallOrMedium){

  }

  _buildRichOrTextAndConvertJugadaToLegible({Jugada jugada, bool isSmallOrMedium = true}){
   if(jugada.jugada.length == 4 && jugada.jugada.indexOf('+') == -1 && jugada.jugada.indexOf('-') == -1){
     return Text(jugada.jugada.substring(0, 2) + '-' + jugada.jugada.substring(2, 4), style: TextStyle(fontSize: 16));
   }
   else if(jugada.jugada.length == 3){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.jugada.substring(0, 3)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.jugada.length == 4 && jugada.jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.jugada.substring(0, 3)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.jugada.length == 5 && jugada.jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.jugada.substring(0, 4)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.jugada.length == 5 && jugada.jugada.indexOf('-') != -1){
    if(Draws.esDirecto(jugada.sorteo))
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(jugada.jugada, style: TextStyle(fontSize: 16)),
          Text("Rango", style: TextStyle(fontSize: 13, color: Colors.blue[700])),
        ],
      );
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.jugada.substring(0, 4)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
  else if(jugada.jugada.length == 6){
     return Text(jugada.jugada.substring(0, 2) + '-' + jugada.jugada.substring(2, 4) + '-' + jugada.jugada.substring(4, 6), style: TextStyle(fontSize: !isSmallOrMedium ? 12.5 : 15, letterSpacing: -1.5));
  }

  if(Draws.esIdPaleTripletaOSuperpale(jugada.idSorteo))
   return Column(
     children: [
       Text(jugada.jugada, style: TextStyle(fontSize: 16)),
       Text(jugada.sorteo, style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 0.2)),
     ],
   );

   return Text(jugada.jugada, style: TextStyle(fontSize: 16));
 }

 Widget _jugadaDirectoEntreRangosWidget(Jugada jugada){
  List<String> jugadas = SorteoService.dividirPorGuion(jugada.jugada);
  return RichText(
       text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: jugadas[0]),
          TextSpan(text: '-', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          TextSpan(text: jugadas[1]),
        ]
      ),
    );
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
              Center(child: _buildRichOrTextAndConvertJugadaToLegible(jugada: j)),
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

 _guardar() async {
  if(_cargandoNotify.value)
    return;

   if(_selectedMoneda == null){
     Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar una moneda");
     return;
   }
   if(_date == null){
     Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar una fecha");
     return;
   }

   if(_jugadas.length == 0){
     Utils.showAlertDialog(context: context, title: "Error", content: "No hay jugadas realizadas");
     return;
   }
   if(_loterias.length == 0){
     Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
     return;
   }
   if(_bancas.length == 0 && _selectedTipo == "Por banca"){
     Utils.showAlertDialog(context: context, title: "Error", content: "No hay bancas seleccionadas");
     return;
   }

   List<Jugada> jugadasAGuardar = [];

   Map<dynamic, List<Jugada>> jugadasAgrupadasPorIdLoteria = _jugadas.map((e) => Jugada.clone(e)).groupBy((jugada) => jugada.loteria.id);

   for (MapEntry<dynamic, List<Jugada>> jugadasAgrupadasPorLoteria in jugadasAgrupadasPorIdLoteria.entries) {
     for (MapEntry<dynamic, List<Jugada>> jugadasAgrupadasPorMonto in jugadasAgrupadasPorLoteria.value.groupBy((jugada) => jugada.monto).entries) {
       for (MapEntry<dynamic, List<Jugada>> jugadasAgrupadasPorSorteo in jugadasAgrupadasPorMonto.value.groupBy((jugada) => jugada.idSorteo).entries) {
        Jugada jugada = jugadasAgrupadasPorSorteo.value.first;
        String jugadasAgrupadasPorLoteriaSorteoYMontoSeparadasPorComa = jugadasAgrupadasPorSorteo.value.map((e) => e.jugada).join(",");
        jugada.jugada = jugadasAgrupadasPorLoteriaSorteoYMontoSeparadasPorComa;
        jugadasAGuardar.add(jugada);
      }
     }
   }

  // for (var jugada in jugadasAGuardar) {
  //   print("BloqueoPorJugada _guardar idLoteria: ${jugada.loteria.id} jugada: ${jugada.jugada}");
  // }

  // for (var jugada in _jugadas) {
  //   print("BloqueoPorJugada _guardar _jugadas idLoteria: ${jugada.loteria.id} jugada: ${jugada.jugada}");
  // }

  //  return;

   try {
      _cargandoNotify.value = true;
      var parsed;
      List<Loteria> loteriasTomadasDesdeJugadas = jugadasAgrupadasPorIdLoteria.entries.map<Loteria>((e) => e.value[0].loteria).toList();
       if(_selectedTipo == "Por banca")
        parsed = await BloqueosService.guardarJugadas(context: context, bancas: _bancas, loterias: loteriasTomadasDesdeJugadas, jugadas: jugadasAGuardar, moneda: _selectedMoneda, ignorarDemasBloqueos: _ignorarDemasBloqueos, date: _date, descontarDelBloqueoGeneral: _descontarDelBloqueoGeneral);
      else
        parsed = await BloqueosService.guardarJugadasGeneral(context: context, loterias: loteriasTomadasDesdeJugadas, jugadas: jugadasAGuardar, moneda: _selectedMoneda, ignorarDemasBloqueos: _ignorarDemasBloqueos, date: _date);

      print("BloqueosPorJugadas _guardar parsed: $parsed");
      setState(() {
        _bancas = [];
        _loterias = [];
        _jugadas = [];
        _dias = List.from(listaDia);
        for (var sorteo in listaSorteo) {
          sorteo.monto = null;
        }
        _streamControllerJugada.add([]);
      });
      Utils.showAlertDialog(context: context, title: "Correctamente", content: "Se ha guardado correctamente");
      _cargandoNotify.value = false;
    } on Exception catch (e) {
      _cargandoNotify.value = false;
    }
 }


 _iconButtonDeletePlay(Jugada jugada, {double size: 18}){
    return InkWell(
      child: Icon(Icons.delete, size: size), 
      onTap: (){
      _jugadas.remove(jugada);
      _streamControllerJugada.add(_jugadas);
    },);
  }

  _directoPaleTripletaScreen(double width){
    if(ScreenSize.isXLarge(width) || ScreenSize.isLarge(width))
      return Wrap(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     elevation: 7,
          //     child: MyResizedContainer(
          //       xlarge: 4.19,
          //       large: 3.2,
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0),
          //         child: Container(
          //           height: 270,
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(bottom: 8.0),
          //                   child: Text("Directo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600])),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: MyTable(
          //                   type: MyTableType.custom,
          //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
          //                   rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo == 'Directo').toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
          //                   delete: (){}
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     elevation: 7,
          //     child: MyResizedContainer(
          //       xlarge: 4.19,
          //       large: 3.2,
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0),
          //         child: Container(
          //           height: 270,
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(bottom: 8.0),
          //                   child: Text("Pale y Tripleta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
          //                 ),
          //               ),
          //               Expanded(
          //                 child: MyTable(
          //                   type: MyTableType.custom,
          //                   columns: ["LOT", "NUM.", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 17))], 
          //                   rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pale") != -1 || element.sorteo == 'Tripleta').toList().map<List<dynamic>>((e) => [e, Center(child: Text("${e.loteria.abreviatura}", style: TextStyle(fontSize: 13))), Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada, isSmallOrMedium: isSmallOrMedium)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e, size: 17)]).toList() : [[]],
          //                   delete: (){}
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          _jugadaWidget(jugadas: _jugadas != null ? _jugadas.where((element) => element.sorteo == 'Directo').toList() : null, titulo: "Directo"),          
          _jugadaWidget(jugadas: _jugadas != null ? _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pale") != -1 || element.sorteo == 'Tripleta').toList() : null, titulo: "Pale y Tripleta"),          
        ]
      );
  
    // return Padding(
    //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0),
    //   child: Card(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     elevation: 7,
    //     child: MyResizedContainer(
    //       xlarge: 4.19,
    //       large: 3.2,
    //       medium: 2.09,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 12.0),
    //         child: Container(
    //           height: 270,
    //           child: Column(
    //             children: [
    //               Center(
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(bottom: 8.0),
    //                   child: Text("Directo-Pale-Tripleta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600])),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: MyTable(
    //                   type: MyTableType.custom,
    //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
    //                   rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo == 'Directo' || element.sorteo == 'pale' || element.sorteo == 'Tripleta').toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
    //                   delete: (){}
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return _jugadaWidget(jugadas: _jugadas != null ? _jugadas.where((element) => element.sorteo == 'Directo' || element.sorteo == 'pale' || element.sorteo == 'Tripleta').toList() : null, titulo: "Directo-Pale-Tripleta", medium: 2.09);          
          
  }

  _pick34Screen(double width){
    print("BloqueosPorJugadas _pick34Screen: isXlarge: ${ScreenSize.isXLarge(width)} width: $width large: ${ScreenSize.lg} xlarge: ${ScreenSize.xlg}");
    if(ScreenSize.isXLarge(width))
      return Wrap(
        children: [      
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     elevation: 7,
          //     child: MyResizedContainer(
          //       xlarge: 4.19,
          //       large: 4.3,
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0),
          //         child: Container(
          //           height: 270,
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(bottom: 8.0),
          //                   child: Text("Pick 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
          //                 ),
          //               ),
          //               Expanded(
          //                 child: MyTable(
          //                   type: MyTableType.custom,
          //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
          //                   rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 3") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
          //                   delete: (){}
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     elevation: 7,
          //     child: MyResizedContainer(
          //       xlarge: 4.19,
          //       large: 4.3,
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0),
          //         child: Container(
          //           height: 270,
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(bottom: 8.0),
          //                   child: Text("Pick 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
          //                 ),
          //               ),
          //               Expanded(
          //                 child: MyTable(
          //                   type: MyTableType.custom,
          //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
          //                   rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 4") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
          //                   delete: (){}
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          
          _jugadaWidget(jugadas: _jugadas != null ? _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 3") != -1).toList() : null, titulo: "Pick 3", large: 4.3, medium: 2.09),         
          _jugadaWidget(jugadas: _jugadas != null ? _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 4") != -1).toList() : null, titulo: "Pick 4", large: 4.3, medium: 2.09),   
        ],
      );


    return _jugadaWidget(jugadas: _jugadas != null ? _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick") != -1).toList() : null, titulo: "Pick 3 y 4", large: 3.2, medium: 2.09);       
    // return Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
    //         child: Card(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //           ),
    //           elevation: 7,
    //           child: MyResizedContainer(
    //             large: 3.2,
    //             medium: 2.09,
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(vertical: 12.0),
    //               child: Container(
    //                 height: 270,
    //                 child: Column(
    //                   children: [
    //                     Center(
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(bottom: 8.0),
    //                         child: Text("Pick 3 y 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: MyTable(
    //                         type: MyTableType.custom,
    //                         columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
    //                         rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
    //                         delete: (){}
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
  }


  Widget _jugadaWidget({List<Jugada> jugadas, String titulo, small = 1, medium = 3, xlarge = 4.19, large: 3.2,}){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 7,
        child: MyResizedContainer(
          xlarge: xlarge,
          large: large,
          medium: medium,
          small: small,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              height: 270,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600])),
                    ),
                  ),
                  Expanded(
                    child: MyTable(
                      type: MyTableType.custom,
                      columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                      rows: jugadas!= null ?  jugadas.map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(jugada: e)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                      delete: (){}
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
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
    _isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      bloqueosPorJugadas: true,
      sliverBody: MySliver(
        withScroll: false,
        sliverAppBar: MySliverAppBar(
          title: _title(),
          expandedHeight: _esVentanaPequena() ? 95 : 85,
          subtitle: _subtitle(),
          actions: [
           
              MySliverButton(title: "Guardar", onTap: _guardar, cargandoNotifier: _cargandoNotify,)
            // MySliverButton(
            //   title: Container(
            //     width: 52,
            //     // color: Colors.grey[200],
            //     child: StreamBuilder<List<Moneda>>(
            //       stream: _streamControllerMoneda.stream,
            //       builder: (context, snapshot) {
            //         if(snapshot.data == null)
            //           return SizedBox.shrink();

            //         return InkWell(
            //           onTap: _showMonedas,
            //           child: Row(children: [
            //             Text("${_selectedMoneda != null ? _selectedMoneda.abreviatura : ''}", style: TextStyle(color: _selectedMoneda != null ? Utils.fromHex(_selectedMoneda.color) : Colors.black),),
            //             Icon(Icons.arrow_drop_down, color: Colors.black)
            //           ],),
            //         );
            //       }
            //     ),
            //   ), 
            //   onTap: _showMonedas
            //   ),
            // MySliverButton(
            //   title: Container(
            //     width: 130,
            //     height: 37,
            //     padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
            //     decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //       borderRadius: BorderRadius.circular(10)
            //     ),
            //     child: StreamBuilder<List<Moneda>>(
            //       stream: _streamControllerMoneda.stream,
            //       builder: (context, snapshot) {
            //         if(snapshot.data == null)
            //           return SizedBox.shrink();

            //         return InkWell(
            //           onTap: (){
            //             showMyModalBottomSheet(
            //               context: context,
            //               myBottomSheet2: MyBottomSheet2(
            //                 height: 450,
            //                 child: MyDateRangeDialog(
            //                   date: _date, 
            //                   listaFecha: MyDate.listaFechaFuturo,
            //                   onCancel: () => Navigator.pop(context), 
            //                   onOk: (date){
            //                       print("BloqueoPorJugadasScreen date: ${date}");
            //                       _dateChanged(date); 
            //                       Navigator.pop(context);
            //                       // overlay.remove();
            //                     },
            //                   )
                                  
            //               )
            //             );
            //           },
            //           child: Container(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //               Icon(Icons.date_range),
            //               Expanded(child: Center(child: Text("${MyDate.dateRangeToNameOrString(_date)}", style: TextStyle(color: _selectedMoneda != null ? Utils.fromHex(_selectedMoneda.color) : Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,))),
            //               Icon(Icons.arrow_drop_down, color: Colors.black)
            //             ],),
            //           ),
            //         );
            //       }
            //     ),
            //   ), 
            //   onTap: _showMonedas
            //   ),
          
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
            return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );

            if(_esPantallaGrande()){
              return SliverList(
                delegate: SliverChildListDelegate([
                Wrap(
                  children: [
                    _tipoReglaScreen(),
                    _monedaScreen(),
                    _bancaScreen(),
                    _fechaScreen(),
                    _ignorarDemasBloqueosScreen(),
                    _descontarBloqueoGeneralScreen(),
                    // _loteriaScreen(isSmallOrMedium),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    _loteriaScreen(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                      child: MyResizedContainer(
                        xlarge: 5, 
                        large: 3, 
                        medium: 2.5,
                        child: _jugadaTextField()
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                      child: MyResizedContainer(
                        xlarge: 5, 
                        large: 3, 
                        medium: 5.2,
                        child: _montoTextField()
                      ),
                    ),
                  ],
                ),
                StreamBuilder<List<Jugada>>(
                  stream: _streamControllerJugada.stream,
                  builder: (context, snapshot) {
                    return MyResizedContainer(
                      xlarge: 1,
                      large: 1,
                      medium: 1,
                      small: 1,
                      builder: (context, width) {
                        return Wrap(
                          children: [
                            _directoPaleTripletaScreen(width),
                            _pick34Screen(width)
                            // MyResizedContainer(
                            //   xlarge: 4.19,
                            //   large: 4.3,
                            //   builder: (context, width){
                            //   },
                              // child: Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                              //   child: Container(
                              //     height: 270,
                              //     child: Column(
                              //       children: [
                              //         Center(
                              //           child: Padding(
                              //             padding: const EdgeInsets.only(bottom: 8.0),
                              //             child: Text("Pick 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                              //           ),
                              //         ),
                              //         Expanded(
                              //           child: MyTable(
                              //             type: MyTableType.custom,
                              //             columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                              //             rows: _jugadas!= null ?  _jugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 3") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: _buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                              //             delete: (){}
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            // ),
                            
                          ],
                        );
                      }
                    );
                  }
                ),

                
              ]));
            }

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
                                _bancaScreen(),
                                _loteriaScreen(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: _descontarBloqueoGeneralScreen(),
                                    ),
                                    Flexible(
                                      child: _ignorarDemasBloqueosScreen(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            _sorteoWidget(),
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
                                          color: Colors.grey[200],
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
                                          textAlign: TextAlign.center,
                                          
                                        )
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => setState(() => _jugadaOmonto = false),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
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
                                          textAlign: TextAlign.center,
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
                            ),
                            
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
                                        color: Colors.grey[200],
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
                                                  child: _buildRichOrTextAndConvertJugadaToLegible(jugada: snapshot.data[index])
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
                                              child: _buildRichOrTextAndConvertJugadaToLegible(jugada: snapshot.data[index])
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

  bool _esVentanaPequena(){
    return _isSmallOrMedium;
  }

  _esPantallaGrande(){
    return !_isSmallOrMedium;
  }
  
}