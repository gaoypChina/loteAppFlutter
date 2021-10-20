import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/premiosservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:rxdart/rxdart.dart';

class RegistrarPremiosScreen extends StatefulWidget {
  @override
  _RegistrarPremiosScreenState createState() => _RegistrarPremiosScreenState();
}

class _RegistrarPremiosScreenState extends State<RegistrarPremiosScreen> {
  final _txtSearch = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  StreamController<List<Loteria>> _streamControllerLoteria;
  final _txtPrimera = TextEditingController();
  final _txtSegunda = TextEditingController();
  final _txtTercera = TextEditingController();
  final _txtPick3 = TextEditingController();
  final _txtPick4 = TextEditingController();
  FocusNode _txtPrimeraFocusNode;
  FocusNode _txtSegundaFocusNode;
  FocusNode _txtTerceraFocusNode;
  FocusNode _txtPick3FocusNode;
  FocusNode _txtPick4FocusNode;
  List<Loteria> listaLoteria;
  int _indexLoteria = 0;
  bool _cargando = false;
  bool _cargoPorPrimeraVez = false;
  DateTimeRange _date;
  @override
  void initState() {
    // TODO: implement initState
    _streamControllerLoteria = BehaviorSubject();
    _txtPrimeraFocusNode = FocusNode();
    _txtSegundaFocusNode = FocusNode();
    _txtTerceraFocusNode = FocusNode();
    _txtPick3FocusNode = FocusNode();
    _txtPick4FocusNode = FocusNode();
    _date = MyDate.getTodayDateRange();
    _getLoterias();
    super.initState();
  }

  _llenarCampos(){
    _txtPrimera.text = listaLoteria[_indexLoteria].primera;
    _txtSegunda.text = listaLoteria[_indexLoteria].segunda;
    _txtTercera.text = listaLoteria[_indexLoteria].tercera;
    _txtPick3.text = listaLoteria[_indexLoteria].pick3;
    _txtPick4.text = listaLoteria[_indexLoteria].pick4;
    _txtPrimeraFocusNode.requestFocus();
  }

  _getLoterias() async {
    try{
      // setState(() => _cargando = true);
      listaLoteria = await PremiosService.getLoterias(scaffoldKey: _scaffoldKey);
      setState(() => _cargando = false);
      _streamControllerLoteria.add(listaLoteria);
      _llenarCampos();
    } on Exception catch(e){
      // setState(() => _cargando = false);
    }
  }

  _buscar() async {
    try{
      _streamControllerLoteria.add(null);
      listaLoteria = await PremiosService.buscar(context: context, date: _date.start);
      _streamControllerLoteria.add(listaLoteria);
      _llenarCampos();
    } on Exception catch(e){
      _streamControllerLoteria.add([]);
    }
  }

  _search(String text){
    print("TextField chagned: $text");
    var lista = [];
    if(text.isEmpty)
      lista = listaLoteria;
    else
      lista = listaLoteria.where((v) => v.descripcion.toLowerCase().indexOf(text.toLowerCase()) != -1).toList();
    
    _streamControllerLoteria.add(lista);  
  }

  _myWebFilterScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Padding(
      padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0 : 0, top: 5),
      child: Column(
        children: [
          Stack(
            // alignment: WrapAlignment.start,
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
            //  _myFilterWidget(isSmallOrMedium),
            MyDropdown(
              title: "Fecha",
              hint: "${MyDate.dateRangeToNameOrString(_date)}",
              onTap: _dateDialog,
            ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0, top: 18.0, bottom: !isSmallOrMedium ? 20 : 0),
                  child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
                ),
              ),
            ],
          ),
          MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0, top: 5),)
        ],
      ),
    );
  }

  _borrar(Loteria loteria) async {
    if(loteria == null)
      return;

    try{
      setState(() => _cargando = true);
      listaLoteria = await PremiosService.borrar(scaffoldKey: _scaffoldKey, loteria: loteria);
      setState(() => _cargando = false);
      _streamControllerLoteria.add(listaLoteria);
      _llenarCampos();
      Utils.showSnackBar(content: "Se ha borrado correctamente", scaffoldKey: _scaffoldKey);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _showDialogEliminar({Loteria data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar el grupo ", boldText: "${data.descripcion}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  listaLoteria = await PremiosService.borrar(context: context, loteria: data);
                  _streamControllerLoteria.add(listaLoteria);
                  setState(() => cargando = false);
                  Navigator.pop(context);
                } on Exception catch (e) {
                  print("_showDialogEliminar error: $e");
                  setState(() => cargando = false);
                }
              }
            );
          }
        );
      }
    );
  }

  _showForm(Loteria loteria){
    _txtPrimera.text = loteria != null ? loteria.primera != null ? loteria.primera : '' : '';
    _txtSegunda.text = loteria != null ? loteria.segunda != null ? loteria.segunda : '' : '';
    _txtTercera.text = loteria != null ? loteria.tercera != null ? loteria.tercera : '' : '';
    _txtPick3.text = loteria != null ? loteria.pick3 != null ? loteria.pick3 : '' : '';
    _txtPick4.text = loteria != null ? loteria.pick4 != null ? loteria.pick4 : '' : '';
    bool _actualizarTransacciones = false;

    showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {

            _guardar() async {
              if(loteria == null)
                return;

              if(!_formKey.currentState.validate())
                return;

              loteria.primera = _txtPrimera.text;
              loteria.segunda = _txtSegunda.text;
              loteria.tercera = _txtTercera.text;
              loteria.pick3 = _txtPick3.text;
              loteria.pick4 = _txtPick4.text;
              _actualizarTransacciones = MyDate.dateRangeToNameOrString(_date) != "Hoy" ? _actualizarTransacciones : false;

              try{
                setState(() => _cargando = true);
                listaLoteria = await PremiosService.guardar(scaffoldKey: _scaffoldKey, loteria: loteria, date: _date.start, actualizarTransacciones: _actualizarTransacciones);
                setState(() => _cargando = false);
                _streamControllerLoteria.add(listaLoteria);
                Navigator.pop(context);
                // Utils.showSnackBar(content: "Se ha guardado correctamente", scaffoldKey: _scaffoldKey);
              } on Exception catch(e){
                setState(() => _cargando = false);
              }
            }

            

            bool _existeSorteo(String sorteo){
              return loteria != null ? loteria.sorteos.indexWhere((s) => s.descripcion.indexOf(sorteo) != -1) != -1 : false;
            }

             _actualizarTransaccionesChanged(data){
              setState(() => _actualizarTransacciones = data);
            }

            _statusScreen(){
            // if(isSmallOrMedium)
              return Visibility(visible: MyDate.dateRangeToNameOrString(_date) != "Hoy", child: MySwitch( medium: 1, title: "Actualizar transacciones", value: _actualizarTransacciones, onChanged: _actualizarTransaccionesChanged));
            
            // return Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15.0),
            //   child: MyDropdown(title: "Estado", hint: "${_status ? 'Activa' : 'Desactivada'}", isSideTitle: true, xlarge: 1.6, elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _statusChanged,),
            // );
          }

            return MyAlertDialog(
              title: "${loteria.descripcion}", 
              okFunction:  _guardar,
              cargando: _cargando,
              content: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: MyDate.dateRangeToNameOrString(_date) != "Hoy",
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                              child: Text("${MyDate.dateRangeToNameOrString(_date)}", style: TextStyle(color: MyDate.dateRangeToNameOrString(_date) != "Hoy" ? Colors.red : null),),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Visibility(
                                visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta") || _existeSorteo("Super")),
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      autofocus: true,
                                      enabled: _existeSorteo("Pick") == false,
                                      decoration: InputDecoration(labelText: "Primera"),
                                      controller: _txtPrimera,
                                      focusNode: _txtPrimeraFocusNode,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onTap: (){
                                        _txtPrimera.selection = TextSelection(baseOffset:0, extentOffset:_txtPrimera.text.length);
                                      },
                                      onFieldSubmitted: (data){
                                        _txtSegundaFocusNode.requestFocus();
                                      },
                                      validator: (data){
                                        if(data.isEmpty)
                                          return "No debe estar vacio";
                                        return null;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(2),
                                        // WhitelistingTextInputFormatter.digitsOnly,
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (String text){
                                        if(text.length == 2){
                                          _txtSegundaFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta") || _existeSorteo("Super")),
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: "Segunda"),
                                      enabled: _existeSorteo("Pick") == false,
                                      controller: _txtSegunda,
                                      focusNode: _txtSegundaFocusNode,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onTap: (){
                                        _txtSegunda.selection = TextSelection(baseOffset:0, extentOffset:_txtSegunda.text.length);
                                      },
                                      onFieldSubmitted: (data){
                                        _txtTerceraFocusNode.requestFocus();
                                      },
                                      validator: (data){
                                        if(data.isEmpty)
                                          return "No debe estar vacio";
                                        return null;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(2),
                                        // WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (String text){
                                        if(text.length == 2){
                                          _txtTerceraFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta")),
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: "Tercera"),
                                      controller: _txtTercera,
                                      enabled: _existeSorteo("Pick") == false,
                                      focusNode: _txtTerceraFocusNode,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onTap: (){
                                        _txtTercera.selection = TextSelection(baseOffset:0, extentOffset:_txtTercera.text.length);
                                      },
                                      onFieldSubmitted: (data){
                                        _txtPick3FocusNode.requestFocus();
                                      },
                                      validator: (data){
                                        if(data.isEmpty)
                                          return "No debe estar vacio";
                                        return null;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(2),
                                        // WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (String text){
                                        if(text.length == 2){
                                          _txtPick3FocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Visibility(
                                visible: (_existeSorteo("Pick 3 Box") || _existeSorteo("Pick 3 Straight")),
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20, left: 20),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: "Pick 3"),
                                      controller: _txtPick3,
                                      focusNode: _txtPick3FocusNode,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      autofocus: true,
                                      onTap: (){
                                        _txtPick3.selection = TextSelection(baseOffset:0, extentOffset:_txtPick3.text.length);
                                      },
                                      onFieldSubmitted: (data){
                                        _txtPick4FocusNode.requestFocus();
                                      },
                                      validator: (data){
                                        if(data.isEmpty)
                                          return "No debe estar vacio";
                                        return null;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(3),
                                        // WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (String text){
                                        if(text.length <= 1)
                                          _txtPrimera.text = "";
                                        if(text.length > 1){
                                          _txtPrimera.text = text.substring(1, 2);
                                        }
                                        if(text.length == 3){
                                           _txtPrimera.text += text.substring(2, 3);
                                          _txtPick4FocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (_existeSorteo("Pick 4 Box") || _existeSorteo("Pick 4 Straight")),
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20, left: 20),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: "Pick 4"),
                                      controller: _txtPick4,
                                      focusNode: _txtPick4FocusNode,
                                      keyboardType: TextInputType.number,
                                      onTap: (){
                                        _txtPick4.selection = TextSelection(baseOffset:0, extentOffset:_txtPick4.text.length);
                                      },
                                      validator: (data){
                                        if(data.isEmpty)
                                          return "No debe estar vacio";
                                        return null;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4),
                                        // WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (String text){
                                        if(text.length == 0){
                                          _txtSegunda.text = "";
                                          _txtTercera.text = "";
                                        }
                                        if(text.length > 0 && text.length < 3){
                                          _txtTercera.text = "";
                                          _txtSegunda.text = text.substring(0, text.length);
                                        }
                                        else if(text.length > 2 && text.length < 5)
                                          _txtTercera.text = text.substring(2, text.length);
        
                                        // if(text.length == 4){
                                        //   _txtSegundaFocusNode.requestFocus();
                                        // }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _statusScreen(),
                          SizedBox(height: 20,),
                          // AbsorbPointer(
                          //   absorbing: _cargando,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: <Widget>[
                          //       Flexible(
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          //           child: SizedBox(
                          //             width: double.infinity,
                          //             child: ClipRRect(
                          //                 borderRadius: BorderRadius.circular(5),
                          //                 child: RaisedButton(
                          //                   elevation: 0,
                          //                   color: Utils.fromHex("#e4e6e8"),
                          //                   child: Text('Guardar', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
                          //                   onPressed: (){
                          //                     // _connect();
                          //                     if(_formKey.currentState.validate()){
                          //                       _guardar();
                          //                     }
                          //                   },
                          //               ),
                          //             ),
                          //           ),
                          //         )
                          //       ),
                          //         Flexible(
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          //           child: SizedBox(
                          //             width: double.infinity,
                          //             child: ClipRRect(
                          //                 borderRadius: BorderRadius.circular(5),
                          //                 child: RaisedButton(
                          //                   elevation: 0,
                          //                   color: Utils.fromHex("#e4e6e8"),
                          //                   child: Text('Borrar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                          //                   onPressed: () async {
                          //                     // await deletePrinter();
                          //                     _borrar();
                          //                   },
                          //               ),
                          //             ),
                          //           ),
                          //         )
                          //       )
                          //     ],
                          //   ),
                          // ),
                          
                        ],
                      ),
                    ),
               
            );
          }
        );
      }
    );
  }

  _getAvatarColorQuinielaPaleTripleta(String primeraSegundaTercera){
    return primeraSegundaTercera != null ? primeraSegundaTercera.isNotEmpty ? MyDate.dateRangeToNameOrString(_date) == "Hoy" ? Utils.fromHex("#77ca00") : Colors.grey : Colors.grey : Colors.grey;
  }

  Widget _getAvatarWidget(String primeraSegundaTercera){
    return primeraSegundaTercera != null ? primeraSegundaTercera.isNotEmpty ? Text("$primeraSegundaTercera", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),) : Icon(Icons.timer, color: Colors.white) : Icon(Icons.timer, color: Colors.white);
  }

  Widget _waitingDraw(){
    return Row(
        children: [
          Icon(Icons.timer),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Esperando sorteo"),
          )
        ],
      );
  }


  _drawsBalls(Loteria loteria){
    if(loteria.sorteos.indexWhere((element) => element.descripcion.toLowerCase().indexOf("pick") != -1) != -1)
      return SizedBox();


    if(loteria.primera == null)
      return _waitingDraw();
    if(loteria.primera.isEmpty)
      return _waitingDraw();

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: CircleAvatar(
            // radius: 16,
            backgroundColor: _getAvatarColorQuinielaPaleTripleta(loteria.primera),
            child: Center(child: _getAvatarWidget(loteria.primera)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            // radius: 16,
            backgroundColor: _getAvatarColorQuinielaPaleTripleta(loteria.segunda),
            child: Center(child: _getAvatarWidget(loteria.segunda)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            // radius: 16,
            backgroundColor: _getAvatarColorQuinielaPaleTripleta(loteria.tercera),
            child: Center(child: _getAvatarWidget(loteria.tercera)),
          ),
        ),
        
      ],
    );
  }

  _getAvatarColorPick(String pick, [bool isPick4 = false]){
    return 
      isPick4 == false
      ?
      pick != null ? pick.isNotEmpty ? MyDate.dateRangeToNameOrString(_date) == "Hoy" ? Theme.of(context).primaryColor : Colors.grey : Colors.grey : Colors.grey
      :
      pick != null ? pick.isNotEmpty ? MyDate.dateRangeToNameOrString(_date) == "Hoy" ? Colors.purple : Colors.grey : Colors.grey : Colors.grey;
  }

  Widget _getAvatarPickWidget(String pick,){
    return pick != null ? pick.isNotEmpty ? Text("$pick", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),) : Icon(Icons.timer, color: Colors.white) : Icon(Icons.timer, color: Colors.white);
  }

  _drawsBallsPick(Loteria loteria){
    if(loteria.sorteos.indexWhere((element) => element.descripcion.toLowerCase().indexOf("pick") != -1) == -1)
      return SizedBox();

    if(loteria.pick3 == null || loteria.pick4 == null)
      return _waitingDraw();
    
    if(loteria.pick3.isEmpty)
      return _waitingDraw();

    // print("RegistrarPremiosView _drawsBallsPick: ${loteria.pick3} l: ${loteria.pick3 != null ? loteria.pick3.length : 0} s: ${loteria.pick3 != null ? loteria.pick3.isNotEmpty ? loteria.pick3.substring(1, ) : 0}");

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyResizedContainer(
            small: 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick3),
                    child: Center(child: _getAvatarPickWidget(loteria.pick3 != null ? loteria.pick3.isNotEmpty ? loteria.pick3.substring(0, 1) : null : null)),
                  ),
                ),
                Positioned(
                  left: 35,
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick3),
                    child: Center(child: _getAvatarPickWidget(loteria.pick3 != null ? loteria.pick3.isNotEmpty ? loteria.pick3.substring(1, 2) : null : null)),
                  ),
                ),
                Positioned(
                  left: 70,
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick3),
                    child: Center(child: _getAvatarPickWidget(loteria.pick3 != null ? loteria.pick3.isNotEmpty ? loteria.pick3.substring(2, 3) : null : null)),
                  ),
                ),
                
              ],
            ),
          ),
          MyResizedContainer(
            small: 2,
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick4, true),
                    child: Center(child: _getAvatarPickWidget(loteria.pick4 != null ? loteria.pick4.isNotEmpty ? loteria.pick4.substring(0, 1) : null : null)),
                  ),
                ),
                Positioned(
                  left: 35,
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick4, true),
                    child: Center(child: _getAvatarPickWidget(loteria.pick4 != null ? loteria.pick4.isNotEmpty ? loteria.pick4.substring(1, 2) : null : null)),
                  ),
                ),
                Positioned(
                  left: 70,
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick4, true),
                    child: Center(child: _getAvatarPickWidget(loteria.pick4 != null ? loteria.pick4.isNotEmpty ? loteria.pick4.substring(2, 3) : null : null)),
                  ),
                ),
                Positioned(
                  left: 105,
                  child: CircleAvatar(
                    // radius: 16,
                    backgroundColor: _getAvatarColorPick(loteria.pick4, true),
                    child: Center(child: _getAvatarPickWidget(loteria.pick4 != null ? loteria.pick4.isNotEmpty ? loteria.pick4.substring(3, 4) : null : null)),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _screen(List<Loteria> data, bool isSmallOrMedium){

    if(data == null)
      return [Center(child: CircularProgressIndicator(),)];

    return data.map<Widget>((e) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          onTap: (){_showForm(e);},
          isThreeLine: e.sorteos.indexWhere((element) => element.descripcion.toLowerCase().indexOf("directo") != -1) != -1 && e.sorteos.indexWhere((element) => element.descripcion.toLowerCase().indexOf("pick") != -1) != -1,
          title: Text(e.descripcion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _drawsBalls(e),
                _drawsBallsPick(e)
              ],
            ),
          ),
          trailing: IconButton(onPressed: (){_showDialogEliminar(data: e);}, icon: Icon(Icons.delete)),
        ),
      )).toList();

    // return ListView.builder(
    //   itemCount: data.length,
    //   itemBuilder: (context, index){
    //     // return Padding(
    //     //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //     //   child: Card(
    //     //     child: Padding(
    //     //       padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
    //     //       child: Column(
    //     //         crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: [
    //     //           MySubtitle(title: data[index].descripcion),
    //     //           _drawsBalls(data[index]),
    //     //           _drawsBallsPick(data[index])
    //     //         ],
    //     //       ),
    //     //     ),
    //     //   ),
    //     // );
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 8.0),
    //       child: ListTile(
    //         onTap: (){_showForm(data[index]);},
    //         isThreeLine: data[index].sorteos.indexWhere((element) => element.descripcion.toLowerCase().indexOf("directo") != -1) != -1 && data[index].sorteos.indexWhere((element) => element.descripcion.toLowerCase().indexOf("pick") != -1) != -1,
    //         title: Text(data[index].descripcion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    //         subtitle: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               _drawsBalls(data[index]),
    //               _drawsBallsPick(data[index])
    //             ],
    //           ),
    //         ),
    //         trailing: IconButton(onPressed: (){_showDialogEliminar(data: data[index]);}, icon: Icon(Icons.delete)),
    //       ),
    //     );
    //   }
    // );
  
  }


  _dateDialog() async {
    var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

    if(date != null)
      setState(() {
        _date = DateTimeRange(
          start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
          end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
        );
        _buscar();
      });
  }




  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    // return LogoApp();
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      registrarPremios: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Registrar premios",
          subtitle: isSmallOrMedium ? "" : "Filtre por fecha y administre los numeros ganadores de cada loteria.",
          actions: [
            MySliverButton(
              // showOnlyOnLarge: true,
              showOnlyOnSmall: true,
              title: Container(
                width: 120,
                // width: 140,
              height: 37,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
              decoration: BoxDecoration(
              color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
                child: Builder(
                  builder: (context) {
                    return InkWell(
                    onTap: _dateDialog,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Icon(Icons.date_range),
                        Expanded(child: Center(child: Text("${MyDate.dateRangeToNameOrString(_date)}", style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,))),
                        Icon(Icons.arrow_drop_down, color: Colors.black)
                      ],),
                    ),
                  );
                    MyDropdown(title: null, 
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: () async {
                        // showMyOverlayEntry(
                          // right: 10,
                          //   context: context,
                          //   builder: (context, overlay){
                          //     _cancel(){
                          //       overlay.remove();
                          //     }
                          //     return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
                          //       _dateChanged(date); 
                          //       overlay.remove();
                          //     },);
                          //   }
                          // );

                        var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

                      if(date != null)
                        setState(() {
                          _date = DateTimeRange(
                            start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
                            end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
                          );
                          _buscar();
                        });
                      },
                    );
                  
                  }
                ),
              ), 
              onTap: (){}
              ),
          ],
        ), 
        sliver: StreamBuilder<List<Loteria>>(
          stream: _streamControllerLoteria.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null && ( isSmallOrMedium || listaLoteria == null))
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

            // if(snapshot.data == null && isSmallOrMedium == false && snapshot.connectionState == ConnectionState.active)
            //   return SliverFillRemaining(child: Column(
            //     children: [
            //       _myWebFilterScreen(isSmallOrMedium),
            //       Expanded(child: Center(child: CircularProgressIndicator(),)),
            //     ],
            //   ));

            // if(snapshot.data.length == 0 && isSmallOrMedium == false && snapshot.connectionState == ConnectionState.active)
            //   return SliverFillRemaining(child: Column(
            //     children: [
            //       _myWebFilterScreen(isSmallOrMedium),
            //       Expanded(child: Center(child: MyEmpty(title: "No hay bancas $_selectedOption", icon: Icons.home_work_sharp, titleButton: "No hay bancas",),)),
            //     ],
            //   ));

            if(snapshot.hasData && snapshot.data.length == 0 && isSmallOrMedium)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay datos ", icon: Icons.home_work_sharp, titleButton: "No hay datos",),));


            // if(isSmallOrMedium)
            //   return SliverFillRemaining(
            //     child: _screen(snapshot.data, isSmallOrMedium),
            //   );


            var widgets = _screen(snapshot.data, isSmallOrMedium);

            if(!isSmallOrMedium){
              widgets.insert(0, _myWebFilterScreen(isSmallOrMedium));
              widgets.insert(1, MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Loterias", showOnlyOnLarge: true,));
            }

              
            // widgets.addAll(_screen(snapshot.data, isSmallOrMedium));

            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index){
                return widgets[index];
              },
              childCount: widgets.length
            ));


            // return 
            // SliverFillRemaining(child: Column(
            //   children: [
            //   _myWebFilterScreen(isSmallOrMedium),
            //   MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Loterias", showOnlyOnLarge: true,),
              
            //   Expanded(
            //     child: 
            //     !snapshot.hasData || snapshot.data == null
            //     ?
            //     Center(child: CircularProgressIndicator(),)
            //     :
            //     _screen(snapshot.data, isSmallOrMedium)
            //   )
            //   // :
            //   // MyTable(
            //   //   columns: ["Banca", "Pendientes", "Ganadores", "Perdedores", "Tickets", "Ventas", "Comis.", "Desc.", "Premios", "Neto", "Balalance", "Balance + ventas"], 
            //   //   rows: rows
            //   // )
            // ]));
          }
        )
      )
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Registrar premios", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Utils.colorPrimary,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<List<Loteria>>(
                stream: _streamControllerLoteria.stream,
                builder: (context, snapshot){
                  listaLoteria = snapshot.data;
                  if(snapshot.hasData){
                    return FractionallySizedBox(
                      widthFactor: .6,
                      child: DropdownButton<Loteria>(
                        isExpanded: true,
                        hint: Text("Seleccionar loterias..."),
                        value: listaLoteria[_indexLoteria],
                        items: listaLoteria.map((l) => DropdownMenuItem(
                          value: l,
                          child: Text("${l.descripcion}"),
                        )).toList(),
                        onChanged: (Loteria loteria){
                          int idx = listaLoteria.indexWhere((lo) => lo.id == loteria.id);
                          if(idx != -1){
                            setState(() => _indexLoteria = idx);
                            _llenarCampos();
                          }
                        },
                      ),
                    );
                  }

                  return DropdownButton(
                    hint: Text("No hay loterias"),
                    value: "No hay loterias",
                    items: [
                      DropdownMenuItem(value: "No hay loterias", child: Text("No hay loterias"),)
                    ],
                    onChanged: (String data){

                    },
                  );
                },
              ),
              
              //  Form(
              //     key: _formKey,
              //     child: Column(
              //       children: <Widget>[
              //         Row(
              //           children: <Widget>[
              //             Visibility(
              //               visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta") || _existeSorteo("Super")),
              //               child: Expanded(
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: TextFormField(
              //                     autofocus: true,
              //                     enabled: _existeSorteo("Pick") == false,
              //                     decoration: InputDecoration(labelText: "Primera"),
              //                     controller: _txtPrimera,
              //                     focusNode: _txtPrimeraFocusNode,
              //                     keyboardType: TextInputType.number,
              //                     textInputAction: TextInputAction.next,
              //                     onTap: (){
              //                       _txtPrimera.selection = TextSelection(baseOffset:0, extentOffset:_txtPrimera.text.length);
              //                     },
              //                     onFieldSubmitted: (data){
              //                       _txtSegundaFocusNode.requestFocus();
              //                     },
              //                     validator: (data){
              //                       if(data.isEmpty)
              //                         return "No debe estar vacio";
              //                       return null;
              //                     },
              //                     inputFormatters: [
              //                       LengthLimitingTextInputFormatter(2),
              //                       WhitelistingTextInputFormatter.digitsOnly
              //                     ],
              //                     onChanged: (String text){
              //                       if(text.length == 2){
              //                         _txtSegundaFocusNode.requestFocus();
              //                       }
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Visibility(
              //               visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta") || _existeSorteo("Super")),
              //               child: Expanded(
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: TextFormField(
              //                     decoration: InputDecoration(labelText: "Segunda"),
              //                     enabled: _existeSorteo("Pick") == false,
              //                     controller: _txtSegunda,
              //                     focusNode: _txtSegundaFocusNode,
              //                     keyboardType: TextInputType.number,
              //                     textInputAction: TextInputAction.next,
              //                     onTap: (){
              //                       _txtSegunda.selection = TextSelection(baseOffset:0, extentOffset:_txtSegunda.text.length);
              //                     },
              //                     onFieldSubmitted: (data){
              //                       _txtTerceraFocusNode.requestFocus();
              //                     },
              //                     validator: (data){
              //                       if(data.isEmpty)
              //                         return "No debe estar vacio";
              //                       return null;
              //                     },
              //                     inputFormatters: [
              //                       LengthLimitingTextInputFormatter(2),
              //                       WhitelistingTextInputFormatter.digitsOnly
              //                     ],
              //                     onChanged: (String text){
              //                       if(text.length == 2){
              //                         _txtTerceraFocusNode.requestFocus();
              //                       }
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Visibility(
              //               visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta")),
              //               child: Expanded(
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: TextFormField(
              //                     decoration: InputDecoration(labelText: "Tercera"),
              //                     controller: _txtTercera,
              //                     enabled: _existeSorteo("Pick") == false,
              //                     focusNode: _txtTerceraFocusNode,
              //                     keyboardType: TextInputType.number,
              //                     textInputAction: TextInputAction.next,
              //                     onTap: (){
              //                       _txtTercera.selection = TextSelection(baseOffset:0, extentOffset:_txtTercera.text.length);
              //                     },
              //                     onFieldSubmitted: (data){
              //                       _txtPick3FocusNode.requestFocus();
              //                     },
              //                     validator: (data){
              //                       if(data.isEmpty)
              //                         return "No debe estar vacio";
              //                       return null;
              //                     },
              //                     inputFormatters: [
              //                       LengthLimitingTextInputFormatter(2),
              //                       WhitelistingTextInputFormatter.digitsOnly
              //                     ],
              //                     onChanged: (String text){
              //                       if(text.length == 2){
              //                         _txtPick3FocusNode.requestFocus();
              //                       }
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ),
                          
              //           ],
              //         ),
              //         Row(
              //           children: <Widget>[
              //             Visibility(
              //               visible: (_existeSorteo("Pick 3 Box") || _existeSorteo("Pick 3 Straight")),
              //               child: Expanded(
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20, left: 20),
              //                   child: TextFormField(
              //                     decoration: InputDecoration(labelText: "Pick 3"),
              //                     controller: _txtPick3,
              //                     focusNode: _txtPick3FocusNode,
              //                     keyboardType: TextInputType.number,
              //                     textInputAction: TextInputAction.next,
              //                     autofocus: true,
              //                     onTap: (){
              //                       _txtPick3.selection = TextSelection(baseOffset:0, extentOffset:_txtPick3.text.length);
              //                     },
              //                     onFieldSubmitted: (data){
              //                       _txtPick4FocusNode.requestFocus();
              //                     },
              //                     validator: (data){
              //                       if(data.isEmpty)
              //                         return "No debe estar vacio";
              //                       return null;
              //                     },
              //                     inputFormatters: [
              //                       LengthLimitingTextInputFormatter(3),
              //                       WhitelistingTextInputFormatter.digitsOnly
              //                     ],
              //                     onChanged: (String text){
              //                       if(text.length <= 1)
              //                         _txtPrimera.text = "";
              //                       if(text.length > 1){
              //                         _txtPrimera.text = text.substring(1, 2);
              //                       }
              //                       if(text.length == 3){
              //                          _txtPrimera.text += text.substring(2, 3);
              //                         _txtPick4FocusNode.requestFocus();
              //                       }
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Visibility(
              //               visible: (_existeSorteo("Pick 4 Box") || _existeSorteo("Pick 4 Straight")),
              //               child: Expanded(
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20, left: 20),
              //                   child: TextFormField(
              //                     decoration: InputDecoration(labelText: "Pick 4"),
              //                     controller: _txtPick4,
              //                     focusNode: _txtPick4FocusNode,
              //                     keyboardType: TextInputType.number,
              //                     onTap: (){
              //                       _txtPick4.selection = TextSelection(baseOffset:0, extentOffset:_txtPick4.text.length);
              //                     },
              //                     validator: (data){
              //                       if(data.isEmpty)
              //                         return "No debe estar vacio";
              //                       return null;
              //                     },
              //                     inputFormatters: [
              //                       LengthLimitingTextInputFormatter(4),
              //                       WhitelistingTextInputFormatter.digitsOnly
              //                     ],
              //                     onChanged: (String text){
              //                       if(text.length == 0){
              //                         _txtSegunda.text = "";
              //                         _txtTercera.text = "";
              //                       }
              //                       if(text.length > 0 && text.length < 3){
              //                         _txtTercera.text = "";
              //                         _txtSegunda.text = text.substring(0, text.length);
              //                       }
              //                       else if(text.length > 2 && text.length < 5)
              //                         _txtTercera.text = text.substring(2, text.length);

              //                       // if(text.length == 4){
              //                       //   _txtSegundaFocusNode.requestFocus();
              //                       // }
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 20,),
              //         AbsorbPointer(
              //           absorbing: _cargando,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: <Widget>[
              //               Flexible(
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //                   child: SizedBox(
              //                     width: double.infinity,
              //                     child: ClipRRect(
              //                         borderRadius: BorderRadius.circular(5),
              //                         child: RaisedButton(
              //                           elevation: 0,
              //                           color: Utils.fromHex("#e4e6e8"),
              //                           child: Text('Guardar', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
              //                           onPressed: (){
              //                             // _connect();
              //                             if(_formKey.currentState.validate()){
              //                               _guardar();
              //                             }
              //                           },
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //               ),
              //                 Flexible(
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //                   child: SizedBox(
              //                     width: double.infinity,
              //                     child: ClipRRect(
              //                         borderRadius: BorderRadius.circular(5),
              //                         child: RaisedButton(
              //                           elevation: 0,
              //                           color: Utils.fromHex("#e4e6e8"),
              //                           child: Text('Borrar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              //                           onPressed: () async {
              //                             // await deletePrinter();
              //                             _borrar();
              //                           },
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //               )
              //             ],
              //           ),
              //         ),
                      
              //       ],
              //     ),
              //   ),
            
            ],
          ),
        )
      ),
    );
  }
}


class ExampleStaggeredAnimations extends StatefulWidget {
  const ExampleStaggeredAnimations({
    Key key,
  }) : super(key: key);

  @override
  _ExampleStaggeredAnimationsState createState() =>
      _ExampleStaggeredAnimationsState();
}

class _ExampleStaggeredAnimationsState extends State<ExampleStaggeredAnimations>
    with SingleTickerProviderStateMixin {
   AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(),
          _buildDrawer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Flutter Menu',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    // Put page content here.
    return const SizedBox();
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : Menu(),
        );
      },
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _menuTitles = [
    'Declarative style',
    'Premade widgets',
    'Stateful hot reload',
    'Native performance',
    'Great community',
  ];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

   AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
   Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: Text(
              _menuTitles[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
                _buttonInterval.transform(_staggeredController.value));
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: () {},
            child: const Text(
              'Get started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({Key key, @required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue,
      height: 200,
      width: animation.value,
    );
  }
}
// #enddocregion AnimatedLogo

class LogoApp extends StatefulWidget {
  const LogoApp({Key key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    animation = Tween<double>(begin: 100, end: 300).animate(CurvedAnimation(
                parent: controller,
                curve: Curves.fastOutSlowIn,
              ));
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
        child: Text("Animar"),
        onPressed: (){
          if(controller.value == 1){
              controller.reverse();
            }else{
            controller.forward();
            }
        },
      ),
      AnimatedLogo(animation: animation),
    ],
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}