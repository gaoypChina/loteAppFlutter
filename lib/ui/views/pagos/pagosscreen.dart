import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/pagosservice.dart';
import 'package:loterias/core/services/servidorservice.dart';
import 'package:loterias/ui/views/pagos/servidoressearch.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';

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
    print("PagosScreen _agregarFechaProximoPago 2: ${_diaPago.day}");
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
        Navigator.pushNamed(context, "/pagos/agregar", arguments: [listData[index], null]);
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

