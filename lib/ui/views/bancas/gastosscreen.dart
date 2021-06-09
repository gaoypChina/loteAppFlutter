import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/frecuencia.dart';
import 'package:loterias/core/models/gastos.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/mytogglebuttons.dart';

class GastosScreen extends StatefulWidget {
  final List<Dia> listaDia;
  final List<Frecuencia> listaFrecuencia;
  final Gasto gasto;
  GastosScreen({Key key, this.gasto, @required this.listaDia, @required this.listaFrecuencia }) : super(key: key);
  @override
  _GastosScreenState createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  var _formKey = GlobalKey<FormState>();
  var _txtDescripcion = TextEditingController();
  var _txtMonto = TextEditingController();
  Frecuencia _frecuencia;
  Dia _dia;
  Gasto gasto;

  _init(){
    gasto = widget.gasto != null ? widget.gasto : null;
    _frecuencia = gasto != null ? widget.listaFrecuencia.firstWhere((element) => element.id == gasto.frecuencia.id, orElse: () => null) : widget.listaFrecuencia.firstWhere((element) => element.descripcion == "Semanal", orElse: () => null);
    _dia = gasto != null ? widget.listaDia.firstWhere((element) => element.id == gasto.dia.id, orElse: () => null) : widget.listaDia[0];
    _txtDescripcion.text = gasto != null ? gasto.descripcion : '';
    _txtMonto.text = gasto != null ? gasto.monto.toString() : '';

    if(gasto == null)
      gasto = Gasto();
  }

  _guardar(){
    if(_formKey.currentState.validate() == false)
      return;

    gasto.descripcion = _txtDescripcion.text;
    gasto.monto = Utils.toDouble(_txtMonto.text);
    gasto.dia = _dia;
    gasto.frecuencia = _frecuencia;
    Navigator.pop(context, gasto);
  }

  

  @override
  void initState() {
    // TODO: implement initState
    _init();
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
          // title: ,
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, color: Colors.green,)
          ],
        ),
        sliver: SliverList(delegate: SliverChildListDelegate([
          Form(
            key: _formKey,
            child: Wrap(
              children: [
                Center(
                  child: MyToggleButtons(
                    items: widget.listaFrecuencia.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
                    selectedItems: _frecuencia != null ? [MyToggleData(value: _frecuencia, child:"${_frecuencia.descripcion}" )] : [],
                    onTap: (data){
                      setState(() => _frecuencia = data);
                    },
                  ),
                ),
                Visibility(
                  visible: _frecuencia != null,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${_frecuencia != null ? _frecuencia.observacion : ''}", style: TextStyle(fontSize: 12.5)),
                  )),
                ),
                MyTextFormField(
                  type: MyType.noBorder,
                  leading: Icon(Icons.description),
                  controller: _txtDescripcion,
                  hint: "Descripcion *",
                  isRequired: true,
                  autofocus: true,
                  medium: 1,
                ),
                MyDivider(showOnlyOnSmall: true,),
                MyTextFormField(
                  type: MyType.noBorder,
                  leading: Icon(Icons.attach_money),
                  controller: _txtMonto,
                  hint: "Monto *",
                  isRequired: true,
                  isMoneyFormat: true,
                  medium: 1,
                ),
                MyDivider(showOnlyOnSmall: true,),
                AnimatedSwitcher(
                  duration: Duration(microseconds: 300),
                  child: 
                  (_frecuencia != null ? _frecuencia.descripcion == "Semanal" : false) == false
                  ?
                  SizedBox.shrink()
                  :
                  Column(
                    children: [
                      MyDropdownButton(
                        hint: "Dias *",
                        type: MyDropdownType.noBorder,
                        leading: Icon(Icons.timer),

                        padding: EdgeInsets.zero,
                        medium: 1,
                        initialValue: _dia,
                        value: _dia,
                        items: widget.listaDia.map((e) => [e, "${e.descripcion}"]).toList(),
                        onChanged: (data){
                          setState(() => _dia = data);
                        },
                      ),
                      MyDivider(showOnlyOnSmall: true,),
                    ],
                  ),
                ),
              ],
            ),
          ), 
          
        ])),
      ),
    );
  }
}