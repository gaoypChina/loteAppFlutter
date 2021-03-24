import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loterias/core/classes/utils.dart';

class ContactoScreen extends StatefulWidget {
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
                     ListTile(
                       leading: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, ),
                       title: Text("+1829-426-6800"),
                       subtitle: Text("Contactame por Whatsapp."),
                     ),
                     ListTile(
                       leading: FaIcon(FontAwesomeIcons.google, color: Colors.red, ),
                       title: Text("jeancon29@gmail.com"),
                       subtitle: Text("Contactame por correo"),
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