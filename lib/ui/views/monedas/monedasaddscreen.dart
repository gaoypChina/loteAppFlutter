import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';

class MonedasAddScreen extends StatefulWidget {
  final Moneda data;
  const MonedasAddScreen({ Key key, this.data}) : super(key: key);

  @override
  _MonedasAddScreenState createState() => _MonedasAddScreenState();
}

class _MonedasAddScreenState extends State<MonedasAddScreen> {
  var _formKey = GlobalKey<FormState>();
  var _cargandoNotify = ValueNotifier<bool>(false);
  bool _permiteDecimales = false;
  var _txtDescripcion = TextEditingController();
  var _txtAbreviatura = TextEditingController();
  var _txtEquivalenciaEnDolar = TextEditingController();
  Moneda _data;

  _init(){
    _data = widget.data;
    _txtDescripcion.text = _data != null ? _data.descripcion : '';
    _txtAbreviatura.text = _data != null ? _data.abreviatura : '';
    _txtEquivalenciaEnDolar.text = _data != null ? _data.equivalenciaDeUnDolar != null ? _data.equivalenciaDeUnDolar.toString() : '' : '';
    _permiteDecimales = _data != null ? _data.permiteDecimales == 1 : false;
  }

  _guardar(){

  }

  _permiteDecimalesScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Permite decimales", value: _permiteDecimales, onChanged: _permiteDecimalesChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(title: "Permite decimales", hint: "${_permiteDecimales ? 'Si' : 'No'}", isSideTitle: true, xlarge: 1.6, elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _permiteDecimalesChanged,),
      );
    }

  _permiteDecimalesChanged(data){
    setState(() => _permiteDecimales = data);
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
      cargando: false, 
      cargandoNotify: _cargandoNotify,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "${widget.data != null ? 'Editar' : 'Agregar'} moneda",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true,)
          ],
        ), 
        sliver: SliverList(delegate: SliverChildListDelegate([
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
                            controller: _txtDescripcion,
                            title: !isSmallOrMedium ? "Loteria" : "",
                            hint: "Agregar loteria",
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
                            controller: _txtAbreviatura,
                            title: !isSmallOrMedium ? "Abreviatura" : "",
                            hint: "Abreviatura",
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
                            controller: _txtEquivalenciaEnDolar,
                            title: !isSmallOrMedium ? "Equivalencia en dolar" : "",
                            hint: "Equivalencia en dolar",
                            medium: 1,
                            xlarge: 1.6,
                            isRequired: true,
                            
                          ),
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        _permiteDecimalesScreen(isSmallOrMedium),
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
                  
        ]))
      )
    );
  }
}