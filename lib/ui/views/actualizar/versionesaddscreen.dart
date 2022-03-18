import 'package:flutter/material.dart';
import 'package:loterias/core/models/version.dart';
import 'package:loterias/core/services/versionesservice.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';

import '../../../core/classes/utils.dart';
import '../../widgets/mydivider.dart';
import '../../widgets/mydropdown.dart';
import '../../widgets/mydropdownbutton.dart';
import '../../widgets/myswitch.dart';
import '../../widgets/mytextformfield.dart';

class VersionesAddScreen extends StatefulWidget {
  final Version version;
  const VersionesAddScreen({ Key key, this.version }) : super(key: key);

  @override
  State<VersionesAddScreen> createState() => _VersionesAddScreenState();
}

class _VersionesAddScreenState extends State<VersionesAddScreen> {
  Version version;
  var _txtVersion1 = TextEditingController();
  var _txtVersion2 = TextEditingController();
  var _txtVersion3 = TextEditingController();
  var _txtEnlace = TextEditingController();
  bool _urgente = false;
  List<dynamic> listaEstados = [
    {"id" : 3, "descripcion" : "Publicar"},
    {"id" : 1, "descripcion" : "Activo"},
    {"id" : 2, "descripcion" : "Desactivado"},
  ];

  dynamic _estado;


  _init(){
    version = widget.version;
    _txtVersion1.text = version != null ? version.version : '';
    _txtVersion2.text = version != null ? version.version2 : '';
    _txtVersion3.text = version != null ? version.version3 : '';
    _txtEnlace.text = version != null ? version.enlace : '';
    _estado = version != null ? listaEstados.firstWhere((element) => element["id"] == version.status, orElse: () => null,) : listaEstados[0];
    _urgente = version != null ? version.urgente : false;
      
    if(version == null)
      version = Version();
  }

  void _back({Version version}){
    Navigator.pop(context, version);
  }

  _guardar() async {
    if(_txtVersion1.text.isEmpty){
      Utils.showAlertDialog(context: context, title: "Error", content: "El campo version 1 no puede estar vacio");
      return;
    }
    if(_txtEnlace.text.isEmpty){
      Utils.showAlertDialog(context: context, title: "Error", content: "El campo campo enlace no puede estar vacio");
      return;
    }

    version.version = _txtVersion1.text;
    version.version2 = _txtVersion2.text.isNotEmpty ? _txtVersion2.text : null;
    version.version3 = _txtVersion3.text.isNotEmpty ? _txtVersion3.text : null;
    version.enlace = _txtEnlace.text.isNotEmpty ? _txtEnlace.text : null;
    version.urgente = _urgente;
    version.status = _estado["id"];

    var parsed = await VersionService.guardar(context: context, data: version);
    _back(version: version);
    print("VersionesaddScreen _guardar parsed: $parsed");
    print("VersionesaddScreen _guardar parsed: ${version.toJson()}");
  }

  _urgenteChanged(data){
    setState(() => _urgente = data);
  }

  _urgenteScreen(isSmallOrMedium){
    if(isSmallOrMedium)
      return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Urgente", value: _urgente, onChanged: _urgenteChanged);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: MyDropdown(title: "Actualizar urgente", helperText: "Si este campo esta activo, el usuario recibira la actualizacion instantaneamente y debera actualizar de manera obligatoria", hint: "${_urgente ? 'Activa' : 'Desactivada'}", isSideTitle: true, large: 1.6, xlarge: 1.35, elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _urgenteChanged,),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _txtVersion1.dispose();
    _txtVersion2.dispose();
    _txtVersion3.dispose();
    _txtEnlace.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);

    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      bottomTap: isSmallOrMedium ? null : _guardar,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Version",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true,)
          ],
        ), 
        sliver: SliverList(delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyTextFormField(
              leading: isSmallOrMedium ? SizedBox.shrink() : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyType.noBorder : MyType.border,
              fontSize: isSmallOrMedium ? 28 : null,
              controller: _txtVersion1,
              title: !isSmallOrMedium ? "Version 1" : "",
              hint: "Version 1",
              medium: 1,
              xlarge: 1.6,
              isRequired: true,
              isDigitOnly: true,
            ),
          ),
          MyDivider(showOnlyOnSmall: true,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyTextFormField(
              leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyType.noBorder : MyType.border,
              controller: _txtVersion2,
              title: !isSmallOrMedium ? "Version 2" : "",
              hint: "Version 2",
              medium: 1,
              xlarge: 1.6,
              isRequired: true,
              isDigitOnly: true,
            ),
          ),
          MyDivider(showOnlyOnSmall: true,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyTextFormField(
              leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyType.noBorder : MyType.border,
              controller: _txtVersion3,
              title: !isSmallOrMedium ? "Version 3" : "",
              hint: "Version 3",
              medium: 1,
              xlarge: 1.6,
              isRequired: true,
              isDigitOnly: true,
            ),
          ),
          MyDivider(showOnlyOnSmall: true,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyTextFormField(
              leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyType.noBorder : MyType.border,
              controller: _txtEnlace,
              title: !isSmallOrMedium ? "Enlace" : "",
              hint: "Enlace aplicacion",
              medium: 1,
              xlarge: 1.6,
              isRequired: true,
              
            ),
          ),
          _urgenteScreen(isSmallOrMedium),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyDropdownButton(
              padding: EdgeInsets.all(0),
              leading: isSmallOrMedium ? Icon(Icons.check, color: Colors.black,) : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
              title: !isSmallOrMedium ? "Estado de la version *" : "",
              hint: "Estado de la version",
              value: _estado,
              items: listaEstados.map((e) => [e, "${e["descripcion"]}"]).toList(),
              onChanged: (data){
                setState(() => _estado = data);
              },
            ),
          ),
          MyDivider(showOnlyOnSmall: true,),
        ]),)
      )
    );
  }
}