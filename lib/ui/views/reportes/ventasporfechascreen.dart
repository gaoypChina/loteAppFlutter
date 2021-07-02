import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/ventaporfecha.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:rxdart/rxdart.dart';

class VentasPorFechaScreen extends StatefulWidget {
  const VentasPorFechaScreen({ Key key }) : super(key: key);

  @override
  _VentasPorFechaScreenState createState() => _VentasPorFechaScreenState();
}

class _VentasPorFechaScreenState extends State<VentasPorFechaScreen> {
  StreamController<List<VentaPorFecha>> _streamController;
  DateTimeRange _date;
  MyDate _fecha;
  List<VentaPorFecha> listaData;
  List<Banca> listaBanca;
  List<Moneda> listaMoneda;

  _getData() async {
     _streamController.add(null);
     listaData = await ReporteService.ventasPorFecha(context: context, date: _date, retornarBancas: false, retornarMonedas: false);
     _streamController.add(listaData);
  }

  _init() async {
    _date = MyDate.getTodayDateRange();
     listaData = await ReporteService.ventasPorFecha(context: context, date: _date, retornarMonedas: true, retornarBancas: true);
    _streamController.add(listaData);
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _getData();
    });
  }

  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    MyCollapseChanged(
      child: MyFilter(
        filterTitle: '',
        filterLeading: SizedBox.shrink(),
        leading: SizedBox.shrink(),
        value: _date,
        paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        onChanged: _dateChanged,
        showListNormalCortaLarga: 3,
      ),
    )
    :
    "Filtre y agrupe todas las ventas por fecha.";
  }

  _listTile(VentaPorFecha sesion, int index){
      return Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Text("${index + 1}"),
          // title: Text("${sesion.usuario} ( ${sesion.banca} )"),
          title: Text("${sesion.created_at.toString()}"),
          // subtitle: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Visibility(
          //       visible: sesion.primerInicioSesionPC != null || sesion.ultimoInicioSesionPC != null,
          //       child: Wrap(
          //         alignment: WrapAlignment.start,
          //         children: [
          //           Icon(Icons.computer, size: 17),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 2.0),
          //             child: Text("${sesion.primerInicioSesionPC != null ? MyDate.datetimeToHour(sesion.primerInicioSesionPC) : ''}"),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 5.0),
          //             child: Text("${sesion.ultimoInicioSesionPC != null ? MyDate.datetimeToHour(sesion.ultimoInicioSesionPC) : ''}"),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Visibility(
          //       visible: sesion.primerInicioSesionCelular != null || sesion.ultimoInicioSesionCelular != null,
          //       child: Wrap(
          //         alignment: WrapAlignment.start,
          //         children: [
          //           Icon(Icons.phone_android, size: 17),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 2.0),
          //             child: Text("${sesion.primerInicioSesionCelular != null ? MyDate.datetimeToHour(sesion.primerInicioSesionCelular) : ''}"),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 5.0),
          //             child: Text("${sesion.ultimoInicioSesionCelular != null ? MyDate.datetimeToHour(sesion.ultimoInicioSesionCelular) : ''}"),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          
          trailing: Text("${sesion.neto}"),
        ),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();

    _init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Ventas por fecha",
          subtitle: _subtitle(isSmallOrMedium),
          actions: [

          ],
        ), 
        sliver: StreamBuilder<List<VentaPorFecha>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null)
            return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(),),
            );
            if(isSmallOrMedium)
            return SliverFillRemaining(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  if(index == 0)
                    return Column(
                      children: [
                        // ListTile(
                        //   selectedTileColor: ,
                        //   leading: Text("ID"),
                        //   title: Text("Usuario"),
                        //   trailing: Text("Banca"),
                        // ),
                         Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // color: Colors.amber,
                          color: Colors.grey[100],
                          child: ListTile(
                            leading: Text('ID'),
                            title: Text('Usuario'),
                            trailing: Text('Banca'),
                          ),
                        ),
                        _listTile(snapshot.data[index], index)
                      ],
                    );
                  return _listTile(snapshot.data[index], index);
                }
              ),
            );



          return SliverList(delegate: SliverChildListDelegate([
            MySubtitle(title: "Datos"),
            MyTable(
              isScrolled: false,
              columns: ["Fecha", "Ventas", "Premios", "Comisiones", "Descuentos", "Neto"], 
              rows: snapshot.data.map((e) => [
                e, e.created_at, 
                "${e.ventas}", 
                "${e.premios}", 
                "${e.comisiones}", 
                "${e.descuentoMonto}", 
                "${e.neto}", 
              ]).toList()
            )
          ]));

          }
        )
      
      )
    );
  }
}