import 'package:flutter/material.dart';

class MyBottomSheet2 extends StatefulWidget {
  final Widget child;
  final double height;
  const MyBottomSheet2({ Key key, this.child, this.height = 200}) : super(key: key);

  @override
  _MyBottomSheet2State createState() => _MyBottomSheet2State();
}

class _MyBottomSheet2State extends State<MyBottomSheet2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height / 2,
      height: widget.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
        
  }
}