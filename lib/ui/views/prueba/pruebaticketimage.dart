import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

class PruebaTicketImage extends StatefulWidget {
  final Uint8List image;
  const PruebaTicketImage({ Key key, this.image }) : super(key: key);

  @override
  _PruebaTicketImageState createState() => _PruebaTicketImageState();
}

class _PruebaTicketImageState extends State<PruebaTicketImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Image.memory(widget.image),
        ),
      ),
    );
  }
}