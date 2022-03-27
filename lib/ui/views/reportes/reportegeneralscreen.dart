import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/models/branchreport.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/classes/databasesingleton.dart';

class ReporteGeneralScreen extends StatefulWidget {
  const ReporteGeneralScreen({ Key key }) : super(key: key);

  @override
  State<ReporteGeneralScreen> createState() => _ReporteGeneralScreenState();
}

class _ReporteGeneralScreenState extends State<ReporteGeneralScreen> {
  StreamController _streamControllerData;
  StreamController _streamControllerBanca;
  int idGrupo;
  double ventas = 0;
  List<Branchreport> listaBanca = [];


  _init() async {
    idGrupo = await Db.idGrupo();
    var parsed = ReporteService.general(context: context, idGrupo: idGrupo, retornarVentasPremiosComisionesDescuentos: true, retornarGrupos: true, retornarMonedas: true)
    
    _streamControllerData.add(parsed);
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerData = BehaviorSubject();
    _streamControllerBanca = BehaviorSubject();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "General"
        ), 
        sliver: SliverList(delegate: SliverChildListDelegate([
          
        ]))
      )
    );
  }
}