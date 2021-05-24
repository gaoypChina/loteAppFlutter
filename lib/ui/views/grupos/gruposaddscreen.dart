import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/services/gruposservice.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/mytringle.dart';


class GruposAddScreen extends StatefulWidget {
  final Grupo grupo;
  GruposAddScreen({Key key, this.grupo}) : super(key: key);
  @override
  _GruposAddScreenState createState() => _GruposAddScreenState();
}

class _GruposAddScreenState extends State<GruposAddScreen> {
  var _cargandoNotify = ValueNotifier<bool>(false);
  var _formKey = GlobalKey<FormState>();
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  bool _status = true;
  Grupo grupo;

  _init(){
    grupo = widget.grupo;
    _txtDescripcion.text = (grupo != null) ? grupo.descripcion : '';
    _txtCodigo.text = (grupo != null) ? grupo.codigo : '';
    _status = (grupo != null) ? grupo.status == 1 ? true : false : true;

    if(grupo == null)
      grupo = Grupo();
  }

  _guardar() async {
      try {
        if(!_formKey.currentState.validate())
          return;

        grupo.descripcion = _txtDescripcion.text;
        grupo.codigo = _txtCodigo.text;
        grupo.status = _status ? 1 : 0;
        _cargandoNotify.value = true;
        var parsed = await GrupoService.guardar(context: context, grupo: grupo);
        print("_showDialogGuardar parsed: $parsed");
        _back(parsed);
        
        _cargandoNotify.value = false;
        Navigator.pop(context);

      } on Exception catch (e) {
        print("_showDialogGuardar _erroor: $e");
        _cargandoNotify.value = false;
      }
    }

    _back(Map<String, dynamic> parsed){
      Grupo grupo;
      if(parsed["grupo"] != null)
        grupo = Grupo.fromMap(parsed["grupo"]);

      Navigator.pop(context, grupo);
    }

    _statusChanged(data){
      setState(() => _status = data);
    }


  @override
  void initState() {
    // TODO: implement initState
    _init();
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
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: 
          isSmallOrMedium ? 
          SizedBox.shrink() 
          : "Agregar grupo",
          
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar)
          ],
        ), 
        sliver: 

            SliverList(delegate: SliverChildListDelegate([
              Form(
                key: _formKey,
                child: Wrap(
                  children: [
                    MyTextFormField(
                      leading: isSmallOrMedium ? SizedBox.shrink() : null,
                      isSideTitle: isSmallOrMedium ? false : true,
                      type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                      fontSize: 28,
                      controller: _txtDescripcion,
                      hint: "Agregar grupo",
                      medium: 1,
                      isRequired: true,
                      
                    ),
                    MyDivider(showOnlyOnSmall: true,),
                    MyTextFormField(
                      leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
                      isSideTitle: isSmallOrMedium ? false : true,
                      type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                      controller: _txtCodigo,
                      hint: "Codigo",
                      medium: 1,
                      isRequired: true,
                      
                    ),
                    MyDivider(showOnlyOnSmall: true,),
                    MySwitch(leading: Icon(Icons.check_box),title: "Activo", value: _status, onChanged: _statusChanged),
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
              
            ]))
         
      )
    );
  }
}