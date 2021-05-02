import 'package:flutter/material.dart';

class ProbarError extends StatefulWidget {
  @override
  _ProbarErrorState createState() => _ProbarErrorState();
}

class _ProbarErrorState extends State<ProbarError> {
  _test(){
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(onPressed: _test, child: Text("Probar acra catcher")),
    );
  }
}