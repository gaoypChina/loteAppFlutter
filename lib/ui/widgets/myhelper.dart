import 'package:flutter/material.dart';

class MyHelper extends StatelessWidget {
  final String mensaje;
  const MyHelper({Key key, this.mensaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: mensaje,
      child: Icon(Icons.help_outline_outlined, size: 20, color: Colors.black54,)
    );
  }
}