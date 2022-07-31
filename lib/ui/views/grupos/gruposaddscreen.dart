import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/services/gruposservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/mytringle.dart';


class GruposAddScreen extends StatefulWidget {
  final Grupo data;
  GruposAddScreen({Key key, this.data}) : super(key: key);
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

  _init() async {
    var parsed = await GrupoService.index(context: context, data: widget.data);
    grupo = widget.data;
    _txtDescripcion.text = (grupo != null) ? grupo.descripcion : '';
    _txtCodigo.text = (grupo != null) ? grupo.codigo : '';
    _status = (grupo != null) ? grupo.status == 1 ? true : false : true;

    if(grupo == null)
      grupo = Grupo();
  }

  _guardar() async {
    if(_cargandoNotify.value)
      return;

      try {
        if(!_formKey.currentState.validate())
          return;

        grupo.descripcion = _txtDescripcion.text;
        grupo.codigo = _txtCodigo.text;
        grupo.status = _status ? 1 : 0;
        _cargandoNotify.value = true;
        var parsed = await GrupoService.guardar(context: context, grupo: grupo);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        _back(parsed);
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

    _statusScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box),title: "Activo", value: _status, onChanged: _statusChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(title: "Estado", isSideTitle: true, xlarge: 1.6, large: 1.37, medium: 1.37, hint: "${_status ? 'Activo' : 'Desactivado'}", elements: [[true, "Activo"], [false, "Desactivado"]], onTap: _statusChanged,),
      );
    }

    _statusChanged(data){
      setState(() => _status = data);
    }

    _bancasScreen(bool isSmallOrMedium){
      if(widget.data == null)
        return SizedBox();

      if(widget.data.bancas == null)
        return SizedBox();

      if(widget.data.bancas.length == 0)
        return SizedBox();

      if(isSmallOrMedium)
        return ListTile(
          leading: Icon(Icons.ballot),
          title: Text(widget.data.bancas.map((e) => e.descripcion).join(", ")),
          onTap: () async {
            // var sorteosRetornados = await showDialog(
            //   context: context, 
            //   builder: (context){
            //     return MyMultiselect(
            //       title: "Agregar sorteos",
            //       items: listaSorteo.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
            //       initialSelectedItems: _sorteos.length == 0 ? [] : _sorteos.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
            //     );
            //   }
            // );

            // if(sorteosRetornados != null)
            //   setState(() => _sorteos = List.from(sorteosRetornados));
          },
        );

      return SizedBox();
      // return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     MySubtitle(title: "Sorteos", padding: EdgeInsets.only(top: 15, bottom: 4),),
      //     Padding(
      //       padding: const EdgeInsets.only(bottom: 15.0),
      //       child: MyDescripcon(title: "Son los sorteos que se podran jugar en esta loteria.", fontSize: 14,),
      //     ),
      //     MyToggleButtons(
      //       items: listaSorteo.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
      //       selectedItems: _sorteos != null ? _sorteos.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList() : [],
      //       onTap: (value){
      //         int index = _sorteos.indexWhere((element) => element == value);
      //         if(index != -1)
      //           setState(() => _sorteos.removeAt(index));
      //         else
      //           setState(() => _sorteos.add(value));
      //       },
      //     )
      //   ],
      // );
    }



  _screen(bool isSmallOrMedium){
    return Form(
      key: _formKey,
      child: Wrap(
        children: [
          // MySubtitle(title: "Datos", showOnlyOnLarge: true,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyTextFormField(
              autofocus: true,
              leading: isSmallOrMedium ? SizedBox.shrink() : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyType.noBorder : MyType.border,
              fontSize: isSmallOrMedium ? 28 : null,
              controller: _txtDescripcion,
              title: !isSmallOrMedium ? "Grupo" : "",
              hint: "Agregar grupo",
              medium: 1,
              xlarge: 1.6,
              isRequired: true,
              
            ),
          ),
          MyDivider(showOnlyOnSmall: true,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
            child: MyTextFormField(
              leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
              isSideTitle: isSmallOrMedium ? false : true,
              type: isSmallOrMedium ? MyType.noBorder : MyType.border,
              controller: _txtCodigo,
              title: !isSmallOrMedium ? "Codigo" : "",
              hint: "Codigo",
              medium: 1,
              xlarge: 1.6,
              isRequired: true,
              
            ),
          ),
          MyDivider(showOnlyOnSmall: true,),
          _statusScreen(isSmallOrMedium),
          MyDivider(showOnlyOnSmall: true,),
          _bancasScreen(isSmallOrMedium)
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
    );
              
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

    if(!isSmallOrMedium)
      return MyAlertDialog(
        title: "Agregar grupo", 
        content: _screen(isSmallOrMedium), 
        okFunction: _guardar,
        cargandoNotify: _cargandoNotify,
      );

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
          : "Agregar grupo",
          subtitle: isSmallOrMedium ? '' : "Agrega grupos para que agrupes, dividas y separes tus bancas y usuarios.",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, cargandoNotifier: _cargandoNotify,)
          ],
        ), 
        sliver: 

            SliverList(delegate: SliverChildListDelegate([
              _screen(isSmallOrMedium)
            ]))
         
      )
    );
  }
}