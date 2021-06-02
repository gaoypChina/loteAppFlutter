import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/comision.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/frecuencia.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/pagoscombinacion.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/mytogglebuttons.dart';


class BancasAddScreen extends StatefulWidget {
  final Banca data;
  BancasAddScreen({Key key, this.data}) : super(key: key);
  @override
  _BancasAddScreenState createState() => _BancasAddScreenState();
}

class _BancasAddScreenState extends State<BancasAddScreen> with TickerProviderStateMixin{
  var _cargandoNotify = ValueNotifier<bool>(false);
  var _formKey = GlobalKey<FormState>();
  Future _future;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  var _txtDueno = TextEditingController();
  var _txtLocalidad = TextEditingController();

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

  bool _status = true;
  bool _qr = true;
  Banca _data;
  List<Loteria> _loterias;
  List<Loteria> _loteriasComisiones;
  List<Loteria> _loteriasPagosCombinaciones;
  List<Comision> _comisiones;
  List<Pagoscombinacion> _pagosCombinaciones;
  List<Loteria> listaLoteria;
  List<Usuario> listaUsuario;
  List<Moneda> listaMoneda;
  List<Grupo> listaGrupo;
  List<Frecuencia> listaFrecuencia;
  List<Dia> listaDia;
  List<Dia> dias;
  var _tabController;
  Usuario _usuario;
  Moneda _moneda;
  Grupo _grupo;
  Loteria selectedLoteriaComision;
  Loteria selectedLoteriaPagosCombinacion;


  _init() async {
    var parsed = await BancaService.index(context: context, retornarLoterias: true, retornarUsuarios: true, retornarDias: true, retornarGrupos: true, retornarMonedas: true, retornarFrecuencias: true, data: widget.data);
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaUsuario = (parsed["usuarios"] != null) ? parsed["usuarios"].map<Usuario>((json) => Usuario.fromMap(json)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
    listaGrupo = (parsed["grupos"] != null) ? parsed["grupos"].map<Grupo>((json) => Grupo.fromMap(json)).toList() : [];
    listaFrecuencia = (parsed["frecuencias"] != null) ? parsed["frecuencias"].map<Frecuencia>((json) => Frecuencia.fromMap(json)).toList() : [];
    listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    print("_init loterias: ${parsed['data']['loterias']}");
    _setsAllFields(parsed);


    
  }

  _setsAllFields(parsed){
    print("_setsAllFields 1: ${_data == null}");
    _data = parsed["data"] != null ? Banca.fromMap(parsed["data"]) : null;
    print("_setsAllFields 2: ${_data == null}");
    _txtDescripcion.text = (_data != null) ? _data.descripcion : '';
    _txtCodigo.text = (_data != null) ? _data.codigo : '';
    _status = (_data != null) ? _data.status == 1 ? true : false : true;
    print("_setsAllFields 3: ${_data == null}");

    _setsLoterias();
    _setsComisiones();
    _setsPagosCombinaciones();  


    if(_data == null)
      _data = Banca();
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

  _setsComisiones(){
    _setsLoteriasComision();
    if(_data == null){
      for (var item in listaLoteria) {
        _comisiones.add(Comision(idLoteria: item.id));
      } 
      return;
    }else
      _comisiones = _data.comisiones;
  }

  _setsLoteriasComision(){
      if(_loterias == null)
        return [];
      if(_loterias.length == 0)
        return [];

      _loteriasComisiones = [];
      _loteriasComisiones.add(Loteria(id: 0, descripcion: "Copiar a todas"));
      for (var item in _loterias) {
        _loteriasComisiones.add(item);
      }
      selectedLoteriaComision = _loteriasComisiones[0];
      // _loteriasComisiones.insert(0, Loteria(id: 0, descripcion: "Copiar a todas"));
    }

  _setsLoteriasPagosCombinacion(){
      if(_loterias == null)
        return [];
      if(_loterias.length == 0)
        return [];

      _loteriasPagosCombinaciones = [];
      _loteriasPagosCombinaciones.add(Loteria(id: 0, descripcion: "Copiar a todas"));
      for (var item in _loterias) {
        _loteriasPagosCombinaciones.add(item);
      }
      selectedLoteriaPagosCombinacion = _loteriasPagosCombinaciones[1];
      // _loteriasComisiones.insert(0, Loteria(id: 0, descripcion: "Copiar a todas"));
    }

  _setsPagosCombinaciones(){
    _setsLoteriasPagosCombinacion();
    if(_data == null){
      for (var item in listaLoteria) {
        _pagosCombinaciones.add(Pagoscombinacion(idLoteria: item.id));
      } 
      return;
    }else
      _pagosCombinaciones = _data.pagosCombinaciones;
  }

  _setsLoterias(){
    _loterias = [];
    if(_data == null){
      setState(() => _loterias = List.from(listaLoteria));
      return;
    }



    if(_data.loterias == null){
      setState(() => _loterias = List.from(listaLoteria));
      return;
    }

    if(_data.loterias.length == 0){
      setState(() => _loterias = List.from(listaLoteria));
      return;
    }

    List<Loteria> loterias = [];
    print("_setsLoterias loteriasSeleccionadas:");
    for (var loteria in _data.loterias) {
      var l = listaLoteria.firstWhere((element) => element.descripcion == loteria.descripcion, orElse: () => null);
      if(l != null)
        _loterias.add(l);
      print("_setsLoterias loteriasSeleccionadas: ${l != null} : ${l != null ? l.descripcion : ''}");
    }
  }

  _guardar() async {
      try {
        if(!_formKey.currentState.validate())
          return;

        _data.descripcion = _txtDescripcion.text;
        _data.codigo = _txtCodigo.text;
        _data.status = _status ? 1 : 0;
        _data.loterias = _loterias;
        _cargandoNotify.value = true;
        var parsed = await BancaService.guardar(context: context, data: _data);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        _back(parsed);
      } on Exception catch (e) {
        print("_showDialogGuardar _erroor: $e");
        _cargandoNotify.value = false;
      }
    }

    _back(Map<String, dynamic> parsed){
      Loteria data;
      if(parsed["data"] != null)
        data = Loteria.fromMap(parsed["data"]);

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
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Mostrar codigo qr", value: _status, onChanged: _qrChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(color: Colors.green[100], textColor: Colors.green, title: "Mostrar codigo QR", hint: "${_qr ? 'Si' : 'No'}", isSideTitle: true, xlarge: 1.35, elements: [[true, "Si"], [false, "No"]], onTap: _qrChanged,),
      );
    }

    _statusChanged(data){
      setState(() => _status = data);
    }

    _qrChanged(data){
      setState(() => _qr = data);
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
     setState(() => dia.horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
     print("_horaAperturaChanged: ${t.format(context)}");
    }

    _horaCierreChanged(Dia dia) async {
     TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(dia.horaCierre));
      final now = new DateTime.now();
     setState(() => dia.horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
     print("_horaCierreChanged: ${t.format(context)}");
    }

    _horaAperturaTodosChanged() async {
      TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(Utils.dateTimeToDate(DateTime.now(), "01:00"))));
      final now = new DateTime.now();
      listaDia.forEach((element) {
        setState(() => element.horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
      });
    }

    _horaCierreTodosChanged() async {
      TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(Utils.dateTimeToDate(DateTime.now(), "23:00"))));
      final now = new DateTime.now();
      listaDia.forEach((element) {
        setState(() => element.horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
      });
    }

    _horariosColumnChildren(){
      var children = listaDia.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              children: [
                MyResizedContainer( xlarge: 8, child: Text("${e.descripcion}")), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: MyResizedContainer(medium: 7, large: 6, xlarge: 9, child: Container(child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(child: Center(child: Text("${TimeOfDay.fromDateTime(e.horaApertura).format(context)}", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))), onTap: (){_horaAperturaChanged(e);},),
                  ))),
                ), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: MyResizedContainer(medium: 7,  xlarge: 9, child: Container(
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
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              children: [
                MyResizedContainer( xlarge: 8, child: Text("Cambiar todos", style: TextStyle(fontWeight: FontWeight.bold),)), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: MyResizedContainer(medium: 7, large: 6, xlarge: 9, child: Container(child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(child: Center(child: Text("Todos", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))), onTap: (){_horaAperturaTodosChanged();},),
                  ))),
                ), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: MyResizedContainer(medium: 7,  xlarge: 9, child: Container(
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

    _horariosScreen(){
      return MyScrollbar(
          child: MyResizedContainer(
          xlarge: 2,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: _horariosColumnChildren(),
          ),
        ),
      );
      // return MyTable(
      //   columns: [Center(child: Text("Dias")), Center(child: Text("Apertura")), Center(child: Text("Cierre"))], 
      //   rows: listaDia.map((e) => [e, "${e.descripcion}", InkWell(child: Text("${TimeOfDay.fromDateTime(e.horaApertura).format(context)}"), onTap: (){_horaAperturaChanged(e);},), InkWell(child: Text("${TimeOfDay.fromDateTime(e.horaCierre).format(context)}"), onTap: (){_horaCierreChanged(e);},)]).toList()
      // );
    }

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

    _loteriasScreen(){
      return Wrap(
        children: listaLoteria.map((e) => MyCheckBox(xlarge: 4, title: "${e.descripcion}", value: _loteriaIsSelected(e), onChanged: (value){_ckbLoteriasChanged(value, e);},)).toList(),
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
                      title: !isSmallOrMedium ? "Quiniela" : "",
                      hint: "Quiniela",
                      medium: 1,
                      isRequired: true,
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
                ),
              ),
            ),
             
          ],
        ),
      );
    }

    _pagosCombinacionPrimeraChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].primera = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.primera = double.tryParse(data);});
      }
    }

    _pagosCombinacionSegundaChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].segunda = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.segunda = double.tryParse(data);});
      }
    }

    _pagosCombinacionTerceraChanged(data){
      if(selectedLoteriaPagosCombinacion == null)
        return;

      if(selectedLoteriaComision.id != 0){
        var index = _pagosCombinaciones.indexWhere((element) => element.idLoteria == selectedLoteriaPagosCombinacion.id);

        if(index == -1)
          return;

        _pagosCombinaciones[index].tercera = double.tryParse(data) != null ? double.tryParse(data) : null;
      }else{
        _pagosCombinaciones.forEach((element) {element.tercera = double.tryParse(data);});
      }
    }

    _existeSorteoPagosCombinacion(String sorteo){
      if(selectedLoteriaComision == null)
        return false;
      if(selectedLoteriaComision.id == 0)
        return true;

        print("_existeSorteoPagosCombinacion: ${selectedLoteriaComision.descripcion} - ${selectedLoteriaComision.sorteos.length}");

      return selectedLoteriaComision.sorteos.indexWhere((element) => element.descripcion.toLowerCase() == sorteo) != -1;
    }

    _pagosCombinacionesScreen(bool isSmallOrMedium){
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
            Visibility(
              visible: selectedLoteriaComision != null ? selectedLoteriaComision.id == 0 : false,
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
              child: MyResizedContainer(
                xlarge: 5,
                child: Wrap(
                  children: [
                    MyDivider(showOnlyOnSmall: true,),
                    MySubtitle(title: "Quiniela", padding: EdgeInsets.symmetric(vertical: 5),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("1ra") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                        controller: _txtPrimera,
                        title: !isSmallOrMedium ? "Primera" : "",
                        // hint: "Primera",
                        xlargeSide: 6.5,
                        isRequired: true,
                        onChanged: _pagosCombinacionPrimeraChanged,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("2da") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                        controller: _txtSegunda,
                        title: !isSmallOrMedium ? "Segunda" : "",
                        hint: "Segunda",
                        medium: 1,
                        xlargeSide: 6.5,
                        isRequired: true,
                        onChanged: _pagosCombinacionSegundaChanged,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                      child: MyTextFormField(
                        leading: isSmallOrMedium ? Text("3ra") : null,
                        isSideTitle: isSmallOrMedium ? false : true,
                        type: isSmallOrMedium ? MyType.noBorder : MyType.normal,
                        controller: _txtTercera,
                        title: !isSmallOrMedium ? "Tercera" : "",
                        hint: "Tercera",
                        medium: 1,
                        xlargeSide: 6.5,
                        isRequired: true,
                        onChanged: _pagosCombinacionTerceraChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
           
           
             
          ],
        ),
      );
    }





  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 6, vsync: this);
    _future = _init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      inicio: true,
      cargando: false,
      cargandoNotify: _cargandoNotify,
      isSliverAppBar: true,
      bottomTap: isSmallOrMedium ? null : _guardar,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: 
          isSmallOrMedium ? 
          SizedBox.shrink() 
          : "Agregar loteria",
          subtitle: isSmallOrMedium ? '' : "Agrega y administra todas tus loterias.",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true,)
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

            return SliverList(delegate: SliverChildListDelegate([
              MyTabBar(controller: _tabController, tabs: ["Datos", "Config.", "Horarios", "Comisiones", "Premios", "Loterias"], ),
                  
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
                   MyScrollbar(
                     child: Wrap(
                       children: [
                         MySubtitle(title: "Datos basicos", showOnlyOnLarge: true,),
                         Padding(
                           padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                           child: MyTextFormField(
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
                         MyDivider(showOnlyOnSmall: true,),
                         Padding(
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
                             isRequired: true,
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
                             isRequired: true,
                           ),
                         ),
                         _statusScreen(isSmallOrMedium),
                         MyDivider(showOnlyOnSmall: true,),
                         Padding(
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
                         MyDivider(showOnlyOnSmall: true,),
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
                               setState(() => _grupo = data);
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
                         MyDivider(showOnlyOnSmall: true,),
                         _loteriasButtonsScreen(isSmallOrMedium),
                         MyDivider(showOnlyOnSmall: true,),
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
                  MyScrollbar(
                    child: Wrap(
                      children: [
                        MySubtitle(title: "Datos configuracion", showOnlyOnLarge: true,),
                        Padding(
                           padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                           child: MyTextFormField(
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
                             isRequired: true,
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
                             isRequired: true,
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
                             isRequired: true,
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
                             isDigitOnly: true,
                             title: !isSmallOrMedium ? "Minutos para cancelar ticket" : "",
                             hint: "Minutos para cancelar ticket",
                             medium: 1,
                             isRequired: true,
                             helperText: "Cuando un ticket iguale o supere esta cantidad se descontara el valor del campo DESCONTAR.",
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
                             isDigitOnly: true,
                             title: !isSmallOrMedium ? "Minutos para cancelar ticket" : "",
                             hint: "Minutos para cancelar ticket",
                             medium: 1,
                             isRequired: true,
                             helperText: "Cuando un ticket iguale o supere esta cantidad se descontara el valor del campo DESCONTAR.",
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
                             isDigitOnly: true,
                             title: !isSmallOrMedium ? "Minutos para cancelar ticket" : "",
                             hint: "Minutos para cancelar ticket",
                             medium: 1,
                             isRequired: true,
                             helperText: "Cuando un ticket iguale o supere esta cantidad se descontara el valor del campo DESCONTAR.",
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
                             isDigitOnly: true,
                             title: !isSmallOrMedium ? "Minutos para cancelar ticket" : "",
                             hint: "Minutos para cancelar ticket",
                             medium: 1,
                             isRequired: true,
                             helperText: "Cuando un ticket iguale o supere esta cantidad se descontara el valor del campo DESCONTAR.",
                           ),
                         ),
                      ],
                    )
                  ), 
                  _horariosScreen(),
                  _comisionesScreen(isSmallOrMedium),
                  // Center(child: Text("Comisiones")),
                  _pagosCombinacionesScreen(isSmallOrMedium),
                  _loteriasScreen()
               ]),
             );
           }
         ),
       ),  
      )
    );
  }
}