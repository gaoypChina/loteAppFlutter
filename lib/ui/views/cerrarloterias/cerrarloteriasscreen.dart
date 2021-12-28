import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/cierreloteria.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/cierreloteriaservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:rxdart/rxdart.dart';

class CerrarLoteriasScreen extends StatefulWidget {
  const CerrarLoteriasScreen({ Key key }) : super(key: key);

  @override
  _CerrarLoteriasScreenState createState() => _CerrarLoteriasScreenState();
}

class _CerrarLoteriasScreenState extends State<CerrarLoteriasScreen> {
  List<Cierreloteria> listData = [];
  StreamController<List<Cierreloteria>> _controller;

  _init() async {
    var parsed = await CierreloteriaService.index(context: context, date: DateTime.now());
    listData = (parsed["data"] != null) ? parsed["data"].map<Cierreloteria>((json) => Cierreloteria.fromMap(json)).toList() : [];
    _controller.add(listData);
    print("CerrarLoteriasScreen _init: ${parsed}");
  }

  _removeCierre(Cierreloteria data){
    bool cargando = false;

    showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {

            

            _eliminar() async {
              try {
                List<Servidor> servidores = await Servidor.all(context);
                setState(() => cargando = true);
                Cierreloteria returnedData = await CierreloteriaService.eliminar(context: context, data: data, servidores: servidores);
                if(returnedData != null){
                  listData.removeWhere((e) => e.id == returnedData.id);
                  _controller.add(listData);
                }
              } on Exception catch (e) {
                setState(() => cargando = false);
                // TODO
              }
              Navigator.pop(context);
            }

            return MyAlertDialog(
              isDeleteDialog: true,
              title: "Eliminar", 
              cargando: cargando,
              content: MyRichText(
                text: "Esta seguro de eliminar este cierre?",
              ), 
                okFunction: _eliminar
              );
          }
        );
      }
    );
  }

  Widget _headerListTile(){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // color: Colors.amber,
        color: Colors.grey[100],
        child: ListTile(
          leading: Text('ID'),
          title: Text('Loteria'),
          trailing: Text('Eliminar'),
        ),
      );
  }

  Widget _listTile(Cierreloteria data, int index, int dataLength){
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: index+ 1 == dataLength ? 55 : 0.0),
      child: ListTile(
        leading: Text("${index + 1}"),
        title: Text("${data.loteria.descripcion}"),
        subtitle: Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: data.date, end: data.date))}"),
        trailing: IconButton(onPressed: () => _removeCierre(data), icon: Icon(Icons.delete)),
      ),
    );
  }

  _agregarCierre() async {
    var data = await Navigator.pushNamed(context, "/cierresloterias/agregar");
    if(data == null)
      return;

    if((data as List<Cierreloteria>).length == 0)
      return;

    listData.addAll(data);
    listData.sort((a, b) => a.date.compareTo(b.date));
    _controller.add(listData);
    
    print("CerrarLoteriasScreen _agregarCierre: $data");
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = BehaviorSubject();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      floatingActionButton: FloatingActionButton(onPressed: _agregarCierre, child: Icon(Icons.add),),
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Loterias cerradas",
        ), 
        sliver: StreamBuilder<List<Cierreloteria>>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);
            if(snapshot.data.length == 0)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay loterias cerradas", titleButton: "Cerrar loterias", icon: Icons.timer_off_rounded, onTap: _agregarCierre,)),);

            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index){
                if(index == 0)
                  return Column(
                    children: [
                      _headerListTile(),
                      _listTile(snapshot.data[index], index, snapshot.data.length)
                    ],
                  );
                
                return _listTile(snapshot.data[index], index, snapshot.data.length);
              },
              childCount: snapshot.data.length
            ),);
          }
        )
      )
    );
  }
}