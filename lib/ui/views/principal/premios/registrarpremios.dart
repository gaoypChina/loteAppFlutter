import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/premiosservice.dart';
import 'package:rxdart/rxdart.dart';

class RegistrarPremiosScreen extends StatefulWidget {
  @override
  _RegistrarPremiosScreenState createState() => _RegistrarPremiosScreenState();
}

class _RegistrarPremiosScreenState extends State<RegistrarPremiosScreen> {
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
  @override
  void initState() {
    // TODO: implement initState
    _streamControllerLoteria = BehaviorSubject();
    _txtPrimeraFocusNode = FocusNode();
    _txtSegundaFocusNode = FocusNode();
    _txtTerceraFocusNode = FocusNode();
    _txtPick3FocusNode = FocusNode();
    _txtPick4FocusNode = FocusNode();
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
      setState(() => _cargando = true);
      listaLoteria = await PremiosService.getLoterias(scaffoldKey: _scaffoldKey);
      setState(() => _cargando = false);
      _streamControllerLoteria.add(listaLoteria);
      _llenarCampos();
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  bool _existeSorteo(String sorteo){
    if(listaLoteria == null)
      return false;
    if(listaLoteria.length == 0)
      return false;
    if(listaLoteria[_indexLoteria].sorteos == null)
      return false;
    if(listaLoteria[_indexLoteria].sorteos.length == 0)
      return false;

   return (listaLoteria[_indexLoteria].sorteos.indexWhere((s) => s.descripcion.indexOf(sorteo) != -1) != -1) ? true : false;
  }

  _guardar() async {
    if(listaLoteria == null)
      return;
    if(listaLoteria.isEmpty || listaLoteria.length == 0)
      return;

    listaLoteria[_indexLoteria].primera = _txtPrimera.text;
    listaLoteria[_indexLoteria].segunda = _txtSegunda.text;
    listaLoteria[_indexLoteria].tercera = _txtTercera.text;
    listaLoteria[_indexLoteria].pick3 = _txtPick3.text;
    listaLoteria[_indexLoteria].pick4 = _txtPick4.text;

    try{
      setState(() => _cargando = true);
      listaLoteria = await PremiosService.guardar(scaffoldKey: _scaffoldKey, loteria: listaLoteria[_indexLoteria]);
      setState(() => _cargando = false);
      _streamControllerLoteria.add(listaLoteria);
      Utils.showSnackBar(content: "Se ha guardado correctamente", scaffoldKey: _scaffoldKey);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _borrar() async {
    try{
      setState(() => _cargando = true);
      listaLoteria = await PremiosService.borrar(scaffoldKey: _scaffoldKey, loteria: listaLoteria[_indexLoteria]);
      setState(() => _cargando = false);
      _streamControllerLoteria.add(listaLoteria);
      _llenarCampos();
      Utils.showSnackBar(content: "Se ha borrado correctamente", scaffoldKey: _scaffoldKey);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              
               Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta")),
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
                                    WhitelistingTextInputFormatter.digitsOnly
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
                            visible: (_existeSorteo("Directo") || _existeSorteo("Pale") || _existeSorteo("Tripleta")),
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
                                    WhitelistingTextInputFormatter.digitsOnly
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
                                    WhitelistingTextInputFormatter.digitsOnly
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
                                    WhitelistingTextInputFormatter.digitsOnly
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
                                    WhitelistingTextInputFormatter.digitsOnly
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
                      SizedBox(height: 20,),
                      AbsorbPointer(
                        absorbing: _cargando,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: RaisedButton(
                                        elevation: 0,
                                        color: Utils.fromHex("#e4e6e8"),
                                        child: Text('Guardar', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
                                        onPressed: (){
                                          // _connect();
                                          if(_formKey.currentState.validate()){
                                            _guardar();
                                          }
                                        },
                                    ),
                                  ),
                                ),
                              )
                            ),
                              Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: RaisedButton(
                                        elevation: 0,
                                        color: Utils.fromHex("#e4e6e8"),
                                        child: Text('Borrar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                                        onPressed: () async {
                                          // await deletePrinter();
                                          _borrar();
                                        },
                                    ),
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
            ],
          ),
        )
      ),
    );
  }
}