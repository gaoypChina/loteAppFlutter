import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/entidadesservice.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';

class EntidadesAddScreen extends StatefulWidget {
  final Entidad data;
  const EntidadesAddScreen({ Key key, this.data }) : super(key: key);

  @override
  _EntidadesAddScreenState createState() => _EntidadesAddScreenState();
}

class _EntidadesAddScreenState extends State<EntidadesAddScreen> {
  Future _future;
  var _formKey = GlobalKey<FormState>();
  var _cargandoNotify = ValueNotifier<bool>(false);
  var _txtNombre = TextEditingController();
  Entidad _data;
  Moneda _moneda;
  Tipo _tipo;
  Color _color;
  bool _status = true;
  List<Moneda> listaMoneda = [];
  List<Tipo> listaTipo = [];



  _init() async {
    var parsed = await EntidadesService.index(context: context);
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
    listaTipo = (parsed["tipos"] != null) ? parsed["tipos"].map<Tipo>((json) => Tipo.fromMap(json)).toList() : [];
    print("EntidadesScreen _init: $parsed");
    _setsAllFields();
  }

  _setsAllFields(){
    _data = widget.data;
    _txtNombre.text = _data != null ? _data.nombre : '';
    _tipo = _data != null ? _data.tipo != null ? listaTipo.firstWhere((element) => element.id == _data.tipo.id) : null : null;
    _moneda = _data != null ? _data.moneda != null ? listaMoneda.firstWhere((element) => element.id == _data.moneda.id, orElse: () => null) : null : null;
    _status = _data != null ? _data.status == 1 : true;

    if(_data == null)
      _data = Entidad();
  }

  _guardar() async {
      try {
        if(!_formKey.currentState.validate())
          return;

        if(_tipo == null){
          Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar el tipo de la entidad");
          return;
        }

        if(_moneda == null){
          Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar la moneda entidad");
          return;
        }

        _data.nombre = _txtNombre.text;
        _data.tipo = _tipo;
        _data.moneda = _moneda;
        _data.status  = _status ? 1 : 0;
        _cargandoNotify.value = true;
        var parsed = await EntidadesService.guardar(context: context, data: _data);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        _back(parsed);
      } on Exception catch (e) {
        print("_showDialogGuardar _erroor: $e");
        _cargandoNotify.value = false;
      }
    }

  _back(Map<String, dynamic> parsed){
    Entidad data;
    if(parsed["data"] != null)
      data = Entidad.fromMap(parsed["data"]);

    Navigator.pop(context, data);
  }

  _statusScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Activa", value: _status, onChanged: _statusChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(
          title: "Estado", 
          hint: "${_status ? 'Activa' : 'Desactivada'}", 
          isSideTitle: true, 
          medium: 1.35,
          large: 1.35,
          xlarge: 1.35, 
          elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _statusChanged,),
      );
    }

  _statusChanged(data){
    setState(() => _status = data);
  }


  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);

    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: _cargandoNotify,
      isSliverAppBar: true,
      bottomTap: isSmallOrMedium ? null : _guardar,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: isSmallOrMedium ? '' : "${widget.data != null ? 'Editar' : 'Agregar'} entidad",
          subtitle: isSmallOrMedium ? '' :  "Agregue o edite cualquier entidad",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true,)
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            return SliverList(delegate: SliverChildListDelegate([
              Form(
                        key: _formKey,
                        child: Wrap(
                          children: [
                            MySubtitle(title: "Datos", showOnlyOnLarge: true,),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                              child: MyTextFormField(
                                leading: isSmallOrMedium ? SizedBox.shrink() : null,
                                isSideTitle: isSmallOrMedium ? false : true,
                                type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                                fontSize: isSmallOrMedium ? 28 : null,
                                controller: _txtNombre,
                                title: !isSmallOrMedium ? "Nombre" : "",
                                hint: "Agregar nombre",
                                medium: 1,
                                mediumSide: 1.35,
                                largeSide: 1.35,
                                // large: 1.6,
                                xlarge: 1.6,
                                isRequired: true,
                                
                              ),
                            ),
                            MyDivider(showOnlyOnSmall: true,),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                              child: MyDropdownButton(
                                padding: EdgeInsets.all(0),
                                leading: isSmallOrMedium ? Icon(Icons.person, color: Colors.black,) : null,
                                isSideTitle: isSmallOrMedium ? false : true,
                                type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                                title: !isSmallOrMedium ? "Tipo entidad *" : "",
                                hint: "Tipo entidad",
                                value: _tipo,
                                // helperText: isSmallOrMedium ? null : "Todos las ventas que este usuario realice se reflerejaran en esta banca.",
                                items: listaTipo.map((e) => [e, "${e.descripcion}"]).toList(),
                                onChanged: (data){
                                  setState(() => _tipo = data);
                                },
                              ),
                            ),
                            MyDivider(showOnlyOnSmall: true,),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                              child: MyDropdownButton(
                                padding: EdgeInsets.all(0),
                                leading: isSmallOrMedium ? Icon(Icons.person, color: Colors.black,) : null,
                                isSideTitle: isSmallOrMedium ? false : true,
                                type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                                title: !isSmallOrMedium ? "Moneda de la entidad *" : "",
                                hint: "Moneda de la entidad",
                                value: _moneda,
                                helperText: isSmallOrMedium ? null : "Ayudara a separar y agrupar sus bancas por moneda",
                                items: listaMoneda.map((e) => [e, "${e.descripcion}"]).toList(),
                                onChanged: (data){
                                  setState(() => _moneda = data);
                                },
                              ),
                            ),
                            MyDivider(showOnlyOnSmall: true,),
                            _statusScreen(isSmallOrMedium),
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
                      
            ]));
          }
        )
      )
    );
  }
}