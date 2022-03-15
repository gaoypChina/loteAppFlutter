import 'package:flutter/material.dart';

class MyCircleButton extends StatefulWidget {
  final Function onTap;
  final dynamic child;
  const MyCircleButton({ Key key, @required this.child, @required this.onTap }) : super(key: key);

  @override
  State<MyCircleButton> createState() => _MyCircleButtonState();
}

class _MyCircleButtonState extends State<MyCircleButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 14),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.blue[900]),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15)
          ),
          child: Center(child: widget.child is Widget ? widget.child : Text("${widget.child != null ? widget.child : ''}", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),),
        ),
      ),
    );
  }
}