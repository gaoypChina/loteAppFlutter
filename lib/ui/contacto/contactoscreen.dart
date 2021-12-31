import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:phone_form_field/phone_form_field.dart';

class ContactoScreen extends StatefulWidget {
  final Ajuste data;
  ContactoScreen({Key key, this.data}) : super(key: key);
  @override
  _ContactoScreenState createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> {
  Color _colorPrimary = Utils.fromHex("#38B6FF");
  // PhoneController _txtWhatsapp;

  _navigateBack(){
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    // _txtWhatsapp = PhoneController(PhoneNumber(nsn: widget.data.whatsapp, isoCode: widget.data.isoCode ?? 'US'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
       Container(
         height: 200,
         child: SingleChildScrollView(
           child: Stack(
             // mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Align(
                 alignment: Alignment.center,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                       child: Text("Contacto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                     ),
                     Visibility(
                       visible: widget.data.whatsapp != null && widget.data.whatsapp != '',
                       child: ListTile(
                         leading: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, ),
                         title: PhoneFormField(
                          key: Key('phone-field'),
                          
                          // controller: _txtWhatsapp,     // controller & initialValue value
                          initialValue: PhoneNumber(nsn: widget.data.whatsapp, isoCode: widget.data.isoCode ?? 'US'),   // can't be supplied simultaneously
                          shouldFormat: true,    // default
                          defaultCountry: 'US',
                          // focusNode: _txtWhatsappFocusNode,// default
                          decoration: InputDecoration(
                              // labelText: _showPhoneLabel ? 'Phone' : null,          // default to null
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
                          enabled: false,          // default
                          autofocus: false,       // default
                          autovalidateMode: AutovalidateMode.onUserInteraction, // default
                          onSaved: (PhoneNumber p) => print('saved $p'),   // default null
                          onChanged: (PhoneNumber p) => print('saved $p'), // default null
                          // ... + other textfield params
                                             ),
                       ),
                      //  ListTile(
                      //    leading: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, ),
                      //    title: Text("${widget.data.whatsapp}"),
                      //    subtitle: Text("Contactame por Whatsapp."),
                      //  ),
                     ),
                     Visibility(
                       visible: widget.data.email != null && widget.data.email != '',
                       child: ListTile(
                         leading: Icon(Icons.mail, color: Colors.red, ),
                         title: Text("${widget.data.email}"),
                         subtitle: Text("Contactame por correo"),
                       ),
                     ),
                   ],
                 ),
               ),
               
             ],
           ),
         ),
       );
    
  }
}