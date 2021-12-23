import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';

class ContactoScreen extends StatefulWidget {
  final Ajuste data;
  ContactoScreen({Key key, this.data}) : super(key: key);
  @override
  _ContactoScreenState createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> {
  Color _colorPrimary = Utils.fromHex("#38B6FF");

  _navigateBack(){
    Navigator.pop(context);
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
                         title: Text("${widget.data.whatsapp}"),
                         subtitle: Text("Contactame por Whatsapp."),
                       ),
                     ),
                     Visibility(
                       visible: widget.data.email != null && widget.data.email != '',
                       child: ListTile(
                         leading: FaIcon(FontAwesomeIcons.google, color: Colors.red, ),
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