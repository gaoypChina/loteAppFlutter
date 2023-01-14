import 'package:flutter/material.dart';

class ShowSnackBarWidget extends StatefulWidget {
  final content;
  ShowSnackBarWidget({this.content});
  @override
  _ShowSnackBarWidgetState createState() => _ShowSnackBarWidgetState();
}

class _ShowSnackBarWidgetState extends State<ShowSnackBarWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

_showSnackBar(String content){
      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //     content: Text(content),
      //     action: SnackBarAction(label: 'CERRAR', onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),),
      //   ));
    }

  @override
  void initState() {
    // TODO: implement initState
    _showSnackBar(widget.content);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
    );

    
  }
}