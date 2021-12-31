import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/country.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/ajustesservice.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:phone_form_field/phone_form_field.dart';

class AjustesScreen extends StatefulWidget {
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _txtConsorcio = TextEditingController();
  var _txtEmail = TextEditingController();
  bool _cargando = false;
  Future _future;
  List<Tipo> listaTipo = [];
  Ajuste _ajuste;
  Tipo _tipo;
  bool _imprimirNombreConsorcio = true;
  bool _imprimirNombreBanca = true;
  bool _cancelarTicketWhatsapp = false;
  bool _pagarTicketEnCualquierBanca = false;
  List<String> lista = ["Republica Dominicana", "Estados Unidos"];
  // Country _selectedPhoneCountry;
  FocusNode _txtWhatsappFocusNode;
  bool _showPhoneLabel = true;
  PhoneController _txtWhatsapp;
  var _formKey = GlobalKey<FormState>();

  
  Future _init() async{
    var parsed = await AjustesService.index(scaffoldKey: _scaffoldKey);
    _setAllFields(parsed);
    print("AjustesScreen _init cargo: $parsed");
  }

  _addOrRemoveLabel() {
    bool campoVacio = false;
    if (_txtWhatsapp.value == null)
      campoVacio = true;
    else {
      if (_txtWhatsapp.value.nsn == null || _txtWhatsapp.value.nsn == '')
        campoVacio = true;
    }
    setState(() =>
    _showPhoneLabel = !_txtWhatsappFocusNode.hasFocus && campoVacio);
  }

  _setAllFields(var parsed){
    _ajuste = (parsed["data"] != null) ? Ajuste.fromMap(parsed["data"]) : null;
    _txtConsorcio.text = (_ajuste != null) ? _ajuste.consorcio : null;
    listaTipo = parsed["tipos"].map<Tipo>((e) => Tipo.fromMap(e)).toList();
    _tipo = (_ajuste != null) ? listaTipo.firstWhere((element) => element.id == _ajuste.tipoFormatoTicket.id) : listaTipo[0];
    _imprimirNombreConsorcio = (_ajuste != null) ? _ajuste.imprimirNombreConsorcio == 1 : true; 
    _imprimirNombreBanca = (_ajuste != null) ? _ajuste.imprimirNombreBanca == 1 : true; 
    _cancelarTicketWhatsapp = (_ajuste != null) ? _ajuste.cancelarTicketWhatsapp == 1 : true;
    _pagarTicketEnCualquierBanca = (_ajuste != null) ? _ajuste.pagarTicketEnCualquierBanca == 1 : false;
    // _selectedPhoneCountry = Country.get().firstWhere((element) => element.isoCode == 'DO', orElse: () => null);
    // _txtWhatsapp.text = (_ajuste != null) ? _ajuste.whatsapp : null;
    if(_ajuste != null){
      _txtWhatsapp = PhoneController(PhoneNumber(nsn: _ajuste.whatsapp, isoCode: _ajuste.isoCode ?? 'US'));
      _addOrRemoveLabel();
    }
    _txtEmail.text = (_ajuste != null) ? _ajuste.email : null;
  }

  _guardar() async {
    try {
      if(!_formKey.currentState.validate())
        return;

      setState(() => _cargando = true);
      _ajuste.consorcio = _txtConsorcio.text;
      _ajuste.tipoFormatoTicket = _tipo;
      _ajuste.imprimirNombreConsorcio = (_imprimirNombreConsorcio) ? 1 : 0;
      _ajuste.imprimirNombreBanca = (_imprimirNombreBanca) ? 1 : 0;
      _ajuste.cancelarTicketWhatsapp = (_cancelarTicketWhatsapp) ? 1 : 0;
      _ajuste.pagarTicketEnCualquierBanca = (_pagarTicketEnCualquierBanca) ? 1 : 0;
      _ajuste.whatsapp = _txtWhatsapp.value != null ? _txtWhatsapp.value.nsn != null ? _txtWhatsapp.value.nsn : '' : '';
      _ajuste.isoCode = _txtWhatsapp.value != null ? _txtWhatsapp.value.isoCode != null ? _txtWhatsapp.value.isoCode : null : null;
      _ajuste.email = _txtEmail.text;
      var parsed = await AjustesService.guardar(scaffoldKey: _scaffoldKey, ajuste: _ajuste);
      _ajuste = parsed;
      setState(() => _cargando = false);
      // Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Se ha guardado correctamente");
      Navigator.pop(context);
    } on Exception catch (e) {
          // TODO
      setState(() => _cargando = false);
    }
  }

  _tipoChanged(sorteo){
    setState(() => _tipo = sorteo);
  }

  _showSorteos() async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            _back(){
              Navigator.pop(context);
            }
            tipoChange(tipo){
              setState(() => _tipo = tipo);
              _tipoChanged(tipo);
              _back();
            }
            return Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaTipo.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _tipo == listaTipo[index],
                          onChanged: (data){
                            tipoChange(listaTipo[index]);
                          },
                          title: Text("${listaTipo[index].descripcion}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  _imprimirNombreConsorcioChanged(value){
    setState(() => _imprimirNombreConsorcio = value);
  }

  _imprimirNombreBancaChanged(value){
    setState(() => _imprimirNombreBanca = value);
  }

  _cancelarTicketWhatsappChanged(value){
    setState(() => _cancelarTicketWhatsapp = value);
  }

  _pagarTicketEnCualquierBancaChanged(value){
    setState(() => _pagarTicketEnCualquierBanca = value);
  }

  @override
  void initState() {
    // TODO: implement initState
    _txtWhatsappFocusNode = FocusNode();
    _txtWhatsappFocusNode.addListener(_addOrRemoveLabel);
    _txtWhatsapp = PhoneController(null);
    

    _future = _init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _txtConsorcio.dispose();
    _txtWhatsapp.dispose();
    _txtEmail.dispose();
    _txtWhatsappFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
        context: context,
        cargando: false,
        cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
          sliverAppBar: MySliverAppBar(
            title: "Ajustes",
            actions: [
              MySliverButton(
                  title: "Guardar",
                  onTap: _guardar
              )
            ],
          ),
          sliver: FutureBuilder<void>(
            future: _future,
            builder: (context, snapshot) {
              print("_futureBUildeer snapshot: ${snapshot.hasData} : ${snapshot.connectionState}");
              if(snapshot.connectionState != ConnectionState.done)
                return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                    child: MyTextFormField(
                      autofocus: true,
                      leading: isSmallOrMedium ? SizedBox.shrink() : null,
                      isSideTitle: isSmallOrMedium ? false : true,
                      type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                      fontSize: isSmallOrMedium ? 28 : null,
                      controller: _txtConsorcio,
                      title: !isSmallOrMedium ? "Agregar consorcio *" : "",
                      hint: "Agregar consorcio",
                      medium: 1,
                      isRequired: true,
                      helperText: "Este es el nombre que aparecera en todas partes que se haga referencia a esta banca, inclusive encima del ticket impreso.",
                    ),
                  ),
                  MyDivider(showOnlyOnSmall: true,),
                  MySwitch(
                      leading: Icon(Icons.print_rounded),
                      title: "Imprimir consorcio",
                      value: _imprimirNombreConsorcio,
                      onChanged: _imprimirNombreConsorcioChanged
                  ),
                  MySwitch(
                      leading: Icon(Icons.home_work_sharp),
                      title: "Imprimir nombre banca",
                      value: _imprimirNombreBanca,
                      onChanged: _imprimirNombreBancaChanged
                  ),
                  MySwitch(
                      leading: FaIcon(FontAwesomeIcons.removeFormat),
                      title: "Cancelar tickets WhatsApp",
                      value: _cancelarTicketWhatsapp,
                      onChanged: _cancelarTicketWhatsappChanged
                  ),
                  MySwitch(
                      leading: Icon(Icons.payment),
                      title: "Pagar desde cualquier banca",
                      value: _pagarTicketEnCualquierBanca,
                      onChanged: _pagarTicketEnCualquierBancaChanged
                  ),
                  MyDivider(showOnlyOnSmall: true,),
                  ListTile(
                    leading: isSmallOrMedium ? FaIcon(FontAwesomeIcons.whatsapp) : null,
                    title: Form(
                      key: _formKey,
                      child: PhoneFormField(
                        key: Key('phone-field'),
                        controller: _txtWhatsapp,     // controller & initialValue value
                        initialValue: null,   // can't be supplied simultaneously
                        shouldFormat: true,    // default
                        defaultCountry: 'US',
                        focusNode: _txtWhatsappFocusNode,// default
                        decoration: InputDecoration(
                            labelText: _showPhoneLabel ? 'Phone' : null,          // default to null
                            border: InputBorder.none, // default to UnderlineInputBorder(),
                            hintText: "Whatsapp",
                          helperText: "Este numero aparecerá en la ventana para acceder al sistema"
                          // ...
                        ),
                        validator: PhoneValidator.validMobile(),   // default PhoneValidator.valid()
                        selectorNavigator: const BottomSheetNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
                        // selectorNavigator: const PopupNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
                        showFlagInInput: true,  // default
                        flagSize: 16,           // default
                        autofillHints: [AutofillHints.telephoneNumber], // default to null
                        enabled: true,          // default
                        autofocus: false,       // default
                        autovalidateMode: AutovalidateMode.onUserInteraction, // default
                        onSaved: (PhoneNumber p) => print('saved $p'),   // default null
                        onChanged: (PhoneNumber p) => print('saved $p'), // default null
                        // ... + other textfield params
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  //   child: MyTextFormField(
                  //     leading: isSmallOrMedium ? FaIcon(FontAwesomeIcons.whatsapp) : null,
                  //     isSideTitle: isSmallOrMedium ? false : true,
                  //     type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                  //     padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 12),
                  //     // phoneCountryValue: _selectedPhoneCountry,
                  //     textInputType: TextInputType.phone,
                  //     // phoneCountryChanged: (country) => setState(() => _selectedPhoneCountry = country),
                  //     controller: _txtWhatsapp,
                  //     title: !isSmallOrMedium ? "WhatsApp" : "",
                  //     hint: "WhatsApp",
                  //     medium: 1,
                  //     isRequired: true,
                  //     helperText: "Este whatsapp aparecerá en la ventana para acceder al sistema",
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                    child: MyTextFormField(
                      leading: isSmallOrMedium ? Icon(Icons.email,) : null,
                      isSideTitle: isSmallOrMedium ? false : true,
                      type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                      controller: _txtEmail,
                      title: !isSmallOrMedium ? "Correo" : "",
                      hint: "Correo",
                      medium: 1,
                      isRequired: true,
                      helperText: "Este correo aparecerá en la ventana para acceder al sistema",
                    ),
                  ),
                  MyDivider(showOnlyOnSmall: true, padding: EdgeInsets.symmetric(vertical: 13),),
                  ListTile(
                    leading: Icon(Icons.confirmation_number_outlined),
                    trailing: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.pink,), onPressed: (){}),
                    title: Align(alignment: Alignment.centerLeft, child: MyContainerButton(data: [_tipo, "${_tipo != null ? _tipo.descripcion : 'Ninguno'}"], onTap: (data){_showSorteos();})),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(thickness: 1,),
                  ),
                  
                ]),

              );
            }
          )
      )
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear,),
            color: Utils.colorPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          
          title: Text("Ajustes", style: TextStyle( color: Colors.black, fontWeight: FontWeight.w500)),
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
              IconButton(icon: Icon(Icons.save_rounded, size: 28,), onPressed: _guardar, color: Utils.colorPrimary,),

            //  Padding(
            //    padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //    child: Container(
            //      child: Center(
            //        child: ElevatedButton(
            //           onPressed: _filtrar, 
            //           child: Text("Filtrar", style: TextStyle(letterSpacing: 1.2),),
            //           style: ElevatedButton.styleFrom(
            //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //             primary: Utils.colorPrimary
            //           ),
            //         ),
            //      ),
            //    ),
            //  ) 
              // ElevatedButton(child: Text("Guardar"), 
              // onPressed: _guardar,
              // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utils.colorPrimary)),)
          ],
        ),
       body: FutureBuilder<void>(
         future: _future,
         builder: (context, snapshot) {
           print("_futureBUildeer snapshot: ${snapshot.hasData} : ${snapshot.connectionState}");
           if(snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());

           return SafeArea(child: ListView(
             children: [
               ListTile(
                 leading: SizedBox(),
                 title: TextFormField(
                   controller: _txtConsorcio,
                   keyboardType: TextInputType.multiline,
                   maxLines: null,
                   style: TextStyle(fontSize: 24),
                   decoration: InputDecoration(
                     hintStyle: TextStyle(fontSize: 24),
                     hintText: "Agregar consorcio",
                     border: InputBorder.none
                   ),
                 ),
               ),
               Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
                // SwitchListTile(
                //   // leading: Icon(Icons.print_rounded),
                //   title: Text("Imprimir nombre consorcio"),
                //   value: true,
                //   onChanged: (value){},
                // ),
                ListTile(
                  leading: Icon(Icons.print_rounded),
                  title: Text("Imprimir consorcio"),
                  trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirNombreConsorcio, onChanged: _imprimirNombreConsorcioChanged),
                ),
                ListTile(
                  leading: Icon(Icons.home_work_sharp),
                  title: Text("Imprimir nombre banca"),
                  trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirNombreBanca, onChanged: _imprimirNombreBancaChanged),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.whatsapp),
                  title: Text("Cancelar tickets WhatsApp"),
                  trailing: Switch(activeColor: Utils.colorPrimary, value: _cancelarTicketWhatsapp, onChanged: _cancelarTicketWhatsappChanged),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.whatsapp),
                  title: Text("Pagar desde cualquier banca"),
                  trailing: Switch(activeColor: Utils.colorPrimary, value: _pagarTicketEnCualquierBanca, onChanged: _pagarTicketEnCualquierBancaChanged),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
                 ListTile(
                  leading: Icon(Icons.confirmation_number_outlined),
                  trailing: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.pink,), onPressed: (){}),
                  title: Align(alignment: Alignment.centerLeft, child: MyContainerButton(data: [_tipo, "${_tipo != null ? _tipo.descripcion : 'Ninguno'}"], onTap: (data){_showSorteos();})),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
             ],
           ));
         }
       ),
    );
  }
}