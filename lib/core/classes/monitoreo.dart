import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/core/services/ticketservice.dart';

class Monitoreo{
  static showDialogImprimirCompartir({Venta venta, BuildContext context}){
   showDialog(
     context: context,
     builder: (context){
       bool _cargando = false;
       return StatefulBuilder(
         builder: (context, setState) {
         return AlertDialog(
           title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               Text("Accion a realizar"),
               SizedBox(
                width: 30,
                height: 30,
                child: Visibility(
                  visible: _cargando,
                  child: Theme(
                    data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ),
             ],
           ),
           content: null,
          actions: <Widget>[
            FlatButton(
                child: Text("Compartir"),
                onPressed: () async {
                  try{
                    setState(() => _cargando = true);
                    var datos = await TicketService.ticket(context: context, idTicket: venta.idTicket);
                    ShareChannel.shareHtmlImageToSmsWhatsapp(html: datos["ticket"]["img"], codigoQr: datos["ticket"]["codigoQr"], sms_o_whatsapp: true);
                    setState(() => _cargando = false);
                    Navigator.pop(context);
                  } on Exception catch(e){
                    setState(() => _cargando = false);
                  }

                },
              ),
               FlatButton(
                child: Text("Ver ticket"),
                onPressed: () async {
                  try{
                    setState(() => _cargando = true);
                    var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: venta.codigoBarra);
                    setState(() => _cargando = false);
                    Navigator.pop(context);
                    showDialogVerTicket(context: context, mapVenta: datos["venta"]);
                  } on Exception catch(e){
                    setState(() => _cargando = false);
                  }
                },
              ),
               FlatButton(
                child: Text("Imprimir"),
                onPressed: () async {

                  try{
                    setState(() => _cargando = true);
                    var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: venta.codigoBarra);
                    await BluetoothChannel.printTicket(datos["venta"], BluetoothChannel.TYPE_COPIA);
                    setState(() => _cargando = false);
                    Navigator.pop(context);
                  } on Exception catch(e){
                    setState(() => _cargando = false);
                  }

                },
              ),
          ],
         );
        }
       );
     }
   );
 }

 static showDialogVerTicket({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, Map<String, dynamic> mapVenta, List<Loteria> loterias}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _loterias = mapVenta['loterias'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
        List<Jugada> _jugadas = mapVenta['jugadas'].map<Jugada>((json) => Jugada.fromMap(json)).toList();
        bool tieneJugadasPendientes = (_jugadas.indexWhere((j) => j.status == 0) != -1);
        bool _cargando = false;
        print("Tiene pendientes: $tieneJugadasPendientes");
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Pagar ticket'),
                   Visibility(
                    visible: _cargando,
                    child: CircularProgressIndicator()
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: (_jugadas.length < 18) ? 300 : MediaQuery.of(context).size.height - 100),
                child: Column(
                  children: <Widget>[
                    Text('Leyenda', style: TextStyle(fontSize: 25, color: Colors.grey[500])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Utils.colorInfo
                          ),
                          child: Center(child: Text('Ganador')),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Utils.colorRosa
                          ),
                          child: Center(child: Text('Perdedor')),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Utils.colorGris
                          ),
                          child: Center(child: Text('Pendiente')),
                        )
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                                  children: [
                                    TextSpan(text: "Monto:"),
                                    TextSpan(text: ' ${mapVenta["total"]}', style: TextStyle(color: Utils.colorInfo))
                                  ]
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                                  children: [
                                    TextSpan(text: "Pendiente de pago:"),
                                    TextSpan(text: ' ${mapVenta["montoAPagar"]}', style: TextStyle(color: (Utils.toDouble(mapVenta["montoAPagar"].toString()) > 0) ? Colors.pink : Utils.colorInfo))
                                  ]
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                                  children: [
                                    TextSpan(text: "Premio total:"),
                                    TextSpan(text: ' ${mapVenta["premio"]}', style: TextStyle(color: Utils.colorInfo))
                                  ]
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Column(
                            children: _loterias.map<Widget>((l) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(l.descripcion, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                ),
                                _buildTable(_jugadas.where((j) => j.idLoteria == l.id).toList())
                              ],
                            )).toList(),
                          )
                          // _buildTable(_jugadas)
                        ],
                      ),
                    )
                    
                  ],

                ),
              ),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop();
                },),
                FlatButton(child: Text("Ok"), onPressed: () async {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    );
  }

  static Widget _buildTable(List<Jugada> jugadas){
   var tam = jugadas.length;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[
          
        ];
   }else{
     rows = jugadas.map((j)
          => TableRow(
            decoration: BoxDecoration(color: Utils.colorGanadorPerdedorPendiente(j.status, j.premio)),
            children: [
              Center(child: Text(j.jugada, style: TextStyle(fontSize: 13))),
              Center(child: Text(j.sorteo, style: TextStyle(fontSize: 13))),
              Center(child: Text(j.monto.toString(), style: TextStyle(fontSize: 13))),
              Center(child: Text(j.premio.toString(), style: TextStyle(fontSize: 13))),
              // Center(child: Text(j.monto.toString(), style: TextStyle(fontSize: 16))),
            ],
          )
        
        ).toList();
        
    rows.insert(0, 
              TableRow(
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Center(child: Text('Jugada', style: TextStyle(fontSize: 18, color: Colors.grey))),
                  Center(child: Text('Sorteo', style: TextStyle(fontSize: 18, color: Colors.grey)),),
                  Center(child: Text('Monto', style: TextStyle(fontSize: 18, color: Colors.grey)),),
                  Center(child: Text('Premio', style: TextStyle(fontSize: 18, color: Colors.grey)),),
                  // Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                ]
              )
              );
        
   }


  return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{1 : FractionColumnWidth(.35)},
            children: rows,
           );

  return Flexible(
      child: ListView(
      children: <Widget>[
        Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
            children: rows,
           ),
      ],
    ),
  );
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: 
     SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: Container(
         child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
          children: rows,
         ),
       ),
     )
  //    DataTable(
  //      columnSpacing: 4,
  //      onSelectAll: null,
       
  //     columns: [
  //       DataColumn(label: Text('Loteria', style: TextStyle( fontWeight: FontWeight.bold),)),
  //       DataColumn(
  //         label: Text('Jugada', style: TextStyle( fontWeight: FontWeight.bold)), 
  //       ),
  //       DataColumn(
  //         label: Text('Monto', style: TextStyle( fontWeight: FontWeight.bold)), 
  //         // numeric: true
          
  //       ),
  //       DataColumn(
  //         label: Text('Eliminar', style: TextStyle( fontWeight: FontWeight.bold)), 
  //       ),
  //     ],
  //     rows: rows,
  // ),
   );
 }
}