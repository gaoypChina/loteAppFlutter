import 'package:flutter/material.dart';
import 'myresizecontainer.dart';

class MySwitch extends StatefulWidget {
  final String title;
  final bool value;
  final ValueChanged onChanged;
  final double small;
  final double medium;
  final double large;
  final double xlarge;
  final Widget leading;
  MySwitch({Key key, @required this.title, @required this.value, @required this.onChanged, this.leading, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 2.7,}) : super(key: key);
  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  _leadingScreen(){

  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
          child: MyResizedContainer(
              small: widget.small,
              medium: widget.medium,
              large: widget.large,
              xlarge: widget.xlarge,
              child: ListTile(
                leading: widget.leading,
                title: Text("${widget.title}"),
                trailing:  Switch(
                  onChanged: widget.onChanged,
                  value: widget.value,
                ),
              )
              // Column(children: [
              //   Row(
              //       // mainAxisSize: MainAxisSize.min,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(right: 25.0),
              //           child: Text(widget.title),
              //         ),
              //         Switch(
              //           onChanged: widget.onChanged,
              //           value: widget.value,
              //         )
              //       ],
              //     ),
              // ],),
            ),
    );
  }
}