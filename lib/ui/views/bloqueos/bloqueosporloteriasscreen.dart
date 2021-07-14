import 'package:flutter/material.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';

class BloqueosPorLoteriasScreen extends StatefulWidget {
  const BloqueosPorLoteriasScreen({ Key key }) : super(key: key);

  @override
  _BloqueosPorLoteriasScreenState createState() => _BloqueosPorLoteriasScreenState();
}

class _BloqueosPorLoteriasScreenState extends State<BloqueosPorLoteriasScreen> {
  
  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Bloqueos",
        ), 
        sliver: SliverFillRemaining(
          child: Center(child: Text("Klk mi pana"),),
        )
      )
    );
  }
}