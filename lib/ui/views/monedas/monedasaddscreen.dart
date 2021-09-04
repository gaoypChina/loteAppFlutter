import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:loterias/core/classes/hexcolor.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/monedasservice.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  Color _color;

  _init(){
    _data = widget.data;
    _txtDescripcion.text = _data != null ? _data.descripcion : '';
    _txtAbreviatura.text = _data != null ? _data.abreviatura : '';
    _txtEquivalenciaEnDolar.text = _data != null ? _data.equivalenciaDeUnDolar != null ? _data.equivalenciaDeUnDolar.toString() : '' : '';
    _permiteDecimales = _data != null ? _data.permiteDecimales == 1 : false;
    _color = _data != null ? _data.color.isNotEmpty ? HexColor.fromHex(_data.color) : null : null;

    if(_data == null)
      _data = Moneda();
  }

  _guardar() async {
      try {
        if(!_formKey.currentState.validate())
          return;

        if(_color == null){
          Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar un color");
          return;
        }

        _data.descripcion = _txtDescripcion.text;
        _data.abreviatura = _txtAbreviatura.text;
        _data.permiteDecimales  = _permiteDecimales ? 1 : 0;
        _data.color = _color.toHex();
        _data.equivalenciaDeUnDolar = Utils.toDouble(_txtEquivalenciaEnDolar.text);
        _cargandoNotify.value = true;
        var parsed = await MonedasService.guardar(context: context, data: _data);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        _back(parsed);
      } on Exception catch (e) {
        print("_showDialogGuardar _erroor: $e");
        _cargandoNotify.value = false;
      }
    }

    _back(Map<String, dynamic> parsed){
      Moneda data;
      if(parsed["data"] != null)
        data = Moneda.fromMap(parsed["data"]);

      Navigator.pop(context, data);
    }

  _permiteDecimalesScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Permite decimales", value: _permiteDecimales, onChanged: _permiteDecimalesChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(
          title: "Permite decimales", 
          hint: "${_permiteDecimales ? 'Si' : 'No'}", 
          isSideTitle: true, 
          medium: 1.35,
          large: 1.35,
          xlarge: 1.35, 
          elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _permiteDecimalesChanged,),
      );
    }

  void changeColor(Color color) {
    setState(() => _color = color);
  }

  _colorScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        // return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Permite decimales", value: _permiteDecimales, onChanged: _permiteDecimalesChanged);
      

return ListTile(
          leading: Icon(Icons.color_lens),
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _color != null ? _color : null, 
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(child: Text(_color != null ? "${_color.toHex()}" : "Agregar color"))),
          onTap: () async {
            var loteriasRetornadas = await showDialog(
              context: context, 
              builder: (context){
                Color pickerColor = Color(0xff443a49);
                Color currentColor = Color(0xff443a49);
                
                return AlertDialog(
                  title: Text("Seleccionar color"),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: _color != null ? _color : pickerColor,
                      onColorChanged: changeColor,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))
                  ],
                );
              }
            );

            // if(loteriasRetornadas != null)
            //   setState(() => _loteriasSeleccionadas = List.from(loteriasRetornadas));
          },
        );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(
          onlyBorder: true,
          leading: Icon(Icons.color_lens, color: _color != null ? _color : Colors.black,),
          title: "Color", 
          hint: "${_color != null ? _color.toHex() : 'Agregar color'}", 
          color: _color != null ? _color : Colors.transparent, 
          textColor: _color != null ? _color : Colors.black,
          isSideTitle: true, 
          medium: 1.35,
          large: 1.35,
          xlarge: 1.35, 
          helperText: "Le ayuda a encontrar e identificar que moneda esta seleccionada de manera mucho mas facil.",
          onTap: (){
           showDialog(
              context: context, 
              builder: (context){
                Color pickerColor = Color(0xff443a49);
                Color currentColor = Color(0xff443a49);
                
                return AlertDialog(
                  title: Text("Seleccionar color"),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: _color != null ? _color : pickerColor,
                      onColorChanged: changeColor,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))
                  ],
                );
              }
            );
        },),
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
      bottomTap: !isSmallOrMedium ? _guardar : null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "${widget.data != null ? 'Editar' : 'Agregar'} moneda",
          subtitle: isSmallOrMedium ? '' :  "Agregue o edite cualquier moneda",
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
                            title: !isSmallOrMedium ? "Moneda" : "",
                            hint: "Agregar moneda",
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
                          child: MyTextFormField(
                            leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
                            isSideTitle: isSmallOrMedium ? false : true,
                            type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            controller: _txtAbreviatura,
                            title: !isSmallOrMedium ? "Codigo" : "",
                            hint: "Codigo de la moneda",
                            helperText: "Es el codigo que tiene cada moneda, ejemplo: US\$",
                            medium: 1,
                            mediumSide: 1.35,
                            largeSide: 1.35,
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
                            isMoneyFormat: true,
                            controller: _txtEquivalenciaEnDolar,
                            title: !isSmallOrMedium ? "Equivalencia de un dolar" : "",
                            hint: "Equivalencia de un dolar",
                            helperText: "Es el monto que ayudara a convertir su moneda en dolar.",
                            medium: 1,
                            mediumSide: 1.35,
                            largeSide: 1.35,
                            xlarge: 1.6,
                            isRequired: true,
                            
                          ),
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        _colorScreen(isSmallOrMedium),
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