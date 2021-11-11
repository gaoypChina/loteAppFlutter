import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/pagosservice.dart';
import 'package:loterias/core/services/servidorservice.dart';
import 'package:loterias/ui/views/pagos/servidoressearch.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class ServidoresScreen extends StatefulWidget {
  const ServidoresScreen({ Key key }) : super(key: key);

  @override
  _ServidoresScreenState createState() => _ServidoresScreenState();
}

class _ServidoresScreenState extends State<ServidoresScreen> {
  Future<List<Servidor>> _future;
  TextEditingController _txtSearch = TextEditingController();
  TextEditingController _txtDiaPago = TextEditingController();
  List<Servidor> listData = [];

  Future<List<Servidor>> _init() async {
    List<Servidor> data = [];
    var parsed = await ServidorService.index(context: context);
    if(parsed == null)
      return data;

    if(parsed["data"] == null)
      return data;

    listData = parsed["data"] != null ? parsed["data"].map<Servidor>((json) => Servidor.fromMap(json)).toList() : [];
    return listData;
  }

  Widget _mysearch(){
    return GestureDetector(
      onTap: () async {
        Servidor data = await showSearch(context: context, delegate: ServidoresSearch(listData));
        if(data == null)
          return;
  
        // _showDialogGuardar(data: data);
      },
      child: MySearchField(
        controller: _txtSearch, 
        enabled: false, 
        hint: "", 
        xlarge: 2.6, 
        padding: EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

   _avatarScreen(Servidor data){

     int daysDifference = MyDate.daysDifference(data.fechaProximoPago);
     print("PagosScren _avatarScreen: ${data.descripcion} $daysDifference");
     Color backgroundColor;
     Color iconColor;
     IconData iconData;

    if(daysDifference == null || daysDifference < 0){
       backgroundColor =  Colors.green;
       iconColor = Colors.green[100];
       iconData = Icons.done;
     }
     else if(daysDifference > 0){
       backgroundColor =  Colors.pink;
       iconColor = Colors.pink[100];
       iconData = Icons.unpublished;
     }
     else if(daysDifference == 0){
       backgroundColor =  Colors.orange;
       iconColor = Colors.orange[100];
       iconData = Icons.warning;
     }

    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(iconData, color: iconColor,),
    );
  }

  _updateDataFromList(Servidor data){
    if(data == null)
      return;

    if(listData == null)
      return;

    var index = listData.indexWhere((element) => element.id == data.id);
    if(index == null)
      setState(() => listData.add(data));
    else
      setState(() => listData[index] = data);
  }

  _agregarFechaProximoPago(Servidor servidor) async {
    print("PagosScreen _agregarFechaProximoPago: ${servidor.diaPago}");
    DateTime _diaPago = servidor.diaPago != null ? MyDate.getDateFromDiaPago(servidor.diaPago) : null;
    // print("PagosScreen _agregarFechaProximoPago 2: ${_diaPago.day}");
    _txtDiaPago.text = servidor.diaPago != null ? "${servidor.diaPago}" : null;
    DateTimeRange _fechaProximoPago = _diaPago != null ? DateTimeRange(start: _diaPago, end: Utils.getNextMonth(_diaPago)) : null;
    bool _cargando = false;

    var data = await showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            _dateChanged(DateTimeRange date){
              setState(() => _fechaProximoPago = date);
            }

            _guardar() async {
              if(_fechaProximoPago == null){
                Utils.showAlertDialog(title: "Fecha requerida", context: context, content: "Debe seleccionar una fecha");
                return;
              }

              try {
                setState(() => _cargando = true);
                var parsed = await PagosService.fechaProximoPago(context: context, fechaProximoPago: _fechaProximoPago.end, servidor: servidor);
                setState(() => _cargando = false);
                Navigator.pop(context, parsed["data"] != null ? Servidor.fromMap(parsed["data"]) : null);
              } on Exception catch (e) {
                // TODO
                setState(() => _cargando = false);
              }
            }

            return MyAlertDialog(
              title: "Fecha pago",
              description: "Agregar la proxima fecha de pago", 
              cargando: _cargando,
              builder: (context, width) {
                  return Wrap(
                    children: [
                      MyTextFormField(
                        controller: _txtDiaPago,
                        title: "dia de pago",
                        onChanged: (data){
                          _diaPago = MyDate.getDateFromDiaPago(Utils.toInt(data));
                          DateTime diaPagoFromNextMonth = Utils.getNextMonth(_diaPago);
                          setState(() {
                            _fechaProximoPago = DateTimeRange(start: _diaPago, end: diaPagoFromNextMonth);
                          });
                        },
                      ),
                      Builder(
                        builder: (context) {
                          return MyDropdown(
                            title: "Fecha proximo pago", 
                            leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
                            // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            hint: "${_fechaProximoPago != null ? MyDate.dateRangeToNameOrString(_fechaProximoPago) : 'Proxima fecha pago'}",
                            onTap: (){
                              showMyOverlayEntry(
                                context: context,
                                top: -100,
                                left: -50,
                                // right: 20,
                                builder: (context, overlay){
                                  _cancel(){
                                    overlay.remove();
                                  }
                                  return MyDateRangeDialog(width: width - 20, date: _fechaProximoPago, onCancel: _cancel, onOk: (date){_dateChanged(date); overlay.remove();},);
                                  // return Card(child: Center(child: Text("Holaa")));
                                }
                              );
                            },
                          );
                        }
                      ),
                    ],
                  );
                }, 
              okFunction: _guardar
            );
          }
        );
      }
    );
  
    _updateDataFromList(data);

  }

  _listTile(List<Servidor> listData, int index){
    return ListTile(
      leading: _avatarScreen(listData[index]),
      title: Text("${listData[index].cliente}"),
      trailing: IconButton(
        icon: Icon(Icons.more_time), 
        tooltip: "Agregar proxima fecha pago",
        onPressed: (){
          _agregarFechaProximoPago(listData[index]);
        },
      ),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${listData[index].descripcion}"),
          Text("${listData[index].fechaProximoPago != null ? MyDate.dateRangeToNameOrString(DateTimeRange(start: listData[index].fechaProximoPago, end: listData[index].fechaProximoPago)) : ''}"),
          // Text("${e.sorteos}"),
        ],
      ),
      onTap: (){
        // close(context, listData[index]);
        if(listData[index].fechaProximoPago == null){
          Utils.showAlertDialog(context: context, title: "Error", content: "No tiene fecha del proximo pago, debe generarla");
          return;
        }
        Navigator.pushNamed(context, "/pagos", arguments: listData[index]);
      },
    );
    // return ListView.builder(
    //   itemCount: listData.length,
    //   itemBuilder: (context, index){
    //     return ListTile(
    //         leading: _avatarScreen(listData[index]),
    //         title: Text("${listData[index].cliente}"),
    //         isThreeLine: true,
    //         subtitle: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text("${listData[index].descripcion}"),
    //             // Text("${e.sorteos}"),
    //           ],
    //         ),
    //         onTap: (){
    //           // close(context, listData[index]);
    //         },
    //       );
    //   },
    // );
  }

  _subtitle(bool isSmallOrMedium){
         return isSmallOrMedium 
           ?
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: _mysearch(),
           )
           :
           "Administre y realize pagos para los servidores";
  }

  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      isSliverAppBar: true,
      cargando: false,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Servidores",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 0,
        ), 
        sliver: FutureBuilder<List<Servidor>>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            if(snapshot.data.length == 0)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay servidores", titleButton: "No hay servidores registrados", icon: Icons.computer,)),);

            

            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index){
                return _listTile(snapshot.data, index);
              },
              childCount: snapshot.data.length
            ));
          }
        )
      )
    );
  }
}

class PagosScreen extends StatefulWidget {
  final Servidor servidor;
  const PagosScreen({ Key key, @required this.servidor }) : super(key: key);

  @override
  _PagosScreenState createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  StreamController<List<Pago>> _streamController;
  List<Pago> listData = [];
  bool _tienePermisoProgramador = false;
  bool _tienePermisoAdministrador = false;
  Future<bool> _futureEsProgramador;

  _init() async {
    List<Servidor> data = [];
    var parsed = await PagosService.index(context: context, servidor: widget.servidor);
    listData = parsed["pagos"] != null ? parsed["pagos"].map<Pago>((json) => Pago.fromMap(json)).toList() : [];
    _streamController.add(listData);
  }

  Future<bool> _esProgramador() async {
    _tienePermisoAdministrador  = await (await DB.create()).getValue("administrador");
    _tienePermisoProgramador  = (await (await DB.create()).getValue("tipoUsuario")) == "Programador";

    return _tienePermisoProgramador;
  }

  _addOrUpdatePayment({Pago pago}) async {
    if(_tienePermisoAdministrador == false && _tienePermisoProgramador == false)
      return;

    var data = await Navigator.pushNamed(context, "/pagos/agregar", arguments: [widget.servidor, pago]);
    _updateDataFromList(data);
  }

  _updateDataFromList(Pago data){
    if(data == null)
      return;

    if(listData == null)
      return;

    var index = listData.indexWhere((element) => element.id == data.id);
    if(index == -1){
      listData.add(data);
      _streamController.add(listData);
    }else{
      listData[index] = data;
      _streamController.add(listData);
    }
  }
  // _avatarScreen(Servidor data){

  //    int daysDifference = MyDate.daysDifference(data.fechaProximoPago);
  //    print("PagosScren _avatarScreen: ${data.descripcion} $daysDifference");
  //    Color backgroundColor;
  //    Color iconColor;
  //    IconData iconData;

  //   if(daysDifference == null || daysDifference < 0){
  //      backgroundColor =  Colors.green;
  //      iconColor = Colors.green[100];
  //      iconData = Icons.done;
  //    }
  //    else if(daysDifference > 0){
  //      backgroundColor =  Colors.pink;
  //      iconColor = Colors.pink[100];
  //      iconData = Icons.unpublished;
  //    }
  //    else if(daysDifference == 0){
  //      backgroundColor =  Colors.orange;
  //      iconColor = Colors.orange[100];
  //      iconData = Icons.warning;
  //    }

  //   return CircleAvatar(
  //     backgroundColor: backgroundColor,
  //     child: Icon(iconData, color: iconColor,),
  //   );
  // }

  _avatarScreen(Pago data){
    
    int daysDifference = MyDate.daysDifference(data.fechaDiaPago);
    //  print("PagosScren _avatarScreen: ${data.descripcion} $daysDifference");
     Color backgroundColor;
     Color iconColor;
     IconData iconData;

    if(data.fechaPagado != null){
      backgroundColor =  Colors.green;
      iconColor = Colors.green[100];
      iconData = Icons.payment;
    }

    else if(daysDifference == null || daysDifference < 0){
       backgroundColor =  Utils.colorPrimary;
      //  iconColor = Colors.green[100];
       iconColor = Colors.blue[100];
       iconData = Icons.done;
     }
     else if(daysDifference > 0 && data.fechaPagado == null){
       backgroundColor =  Colors.pink;
       iconColor = Colors.pink[100];
       iconData = Icons.unpublished;
     }
     else if(daysDifference == 0 && data.fechaPagado == null){
       backgroundColor =  Colors.orange;
       iconColor = Colors.orange[100];
       iconData = Icons.warning;
     }

    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(iconData, color: iconColor,),
    );

    // return CircleAvatar(
    //   backgroundColor: data.fechaPagado != null ? Colors.green : Colors.pink,
    //   child: data.fechaPagado != null ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    // );
  }


  _verPago(Pago pago){
    Navigator.pushNamed(context, "/pagos/ver", arguments: pago.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _futureEsProgramador = _esProgramador();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      isSliverAppBar: true,
      floatingActionButton: FutureBuilder<bool>(
        future: _futureEsProgramador,
        builder: (context, snapshot) {
          // if(snapshot.data != true)
          //   return null;

          return Visibility(visible: snapshot.data == true, child: FloatingActionButton(onPressed: _addOrUpdatePayment, child: Icon(Icons.add),));
        }
      ),
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          expandedHeight: 75,
          title: "Facturas",
          subtitle: MyCollapseChanged(
            actionWhenCollapse: MyCollapseAction.hide,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text("${widget.servidor.cliente}(${widget.servidor.descripcion})"),
            ),
          ),
        ), 
        sliver: StreamBuilder<List<Pago>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

            if(snapshot.data.length == 0)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay facturas generadas", titleButton: "No hay facturas", icon: Icons.payment,)));

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index){
                  return Padding(
                    padding: EdgeInsets.only(bottom: snapshot.data.length - 1 == index ? 50.0 : 0, top: index == 0 ? 20 : 0),
                    child: ListTile(
                      leading: _avatarScreen(snapshot.data[index]),
                      title: Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: snapshot.data[index].fechaDiaPago, end: snapshot.data[index].fechaDiaPago))}"),
                      subtitle: Text("${snapshot.data[index].detallesCount} bancas"),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text("${Utils.toCurrency(snapshot.data[index].total)}"),
                      //     Text("${snapshot.data[index].detallesCount} bancas"),
                      //   ],
                      // ),
                      trailing: Text("${Utils.toCurrency(snapshot.data[index].total)}"),
                      // Wrap(
                      //   children: [
                      //     IconButton(onPressed: (){_sendNotification(snapshot.data[index]);}, icon: Icon(Icons.notifications), tooltip: "Enviar notificacion",),
                      //     IconButton(onPressed: (){_watchPay(snapshot.data[index]);}, icon: Icon(Icons.remove_red_eye), tooltip: "Ver pago",),
                      //     IconButton(onPressed: (){_pay(snapshot.data[index]);}, icon: Icon(Icons.payment), tooltip: "Marcar como pagado",),
                      //   ],
                      // ),
                      onTap: (){_verPago(snapshot.data[index]);},
                    ),
                  );
                },
                childCount: snapshot.data.length,
              )
            );
          }
        )
      )
    );
  }
}