import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ActualizarScreen extends StatefulWidget {
  final String url;
  ActualizarScreen(this.url);
  @override
  _ActualizarScreenState createState() => _ActualizarScreenState();
}

class _ActualizarScreenState extends State<ActualizarScreen> {
  _launchURL(String url) async {
  // const url = url;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar app", style: TextStyle(color: Colors.black),),
        // leading: BackButton(
        //   color: Utils.colorPrimary,
        // ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
         
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Debe actualizar la app para seguir utilizandola"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Utils.colorInfo 
                ),
                child: Text("Actualizar",),
                onPressed: (){
                  _launchURL(widget.url);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}