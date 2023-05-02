

import 'package:flutter/material.dart';

class MyPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const MyPadding({Key key, @required this.child, this.padding = const EdgeInsets.symmetric(horizontal: 10.0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}