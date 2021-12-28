import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/cierreloteria.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/cierreloteriaservice.dart';
import 'package:loterias/core/services/loteriaservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/mymultiselectdialog.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CerrarLoteriasAddScreen extends StatefulWidget {
  const CerrarLoteriasAddScreen({ Key key }) : super(key: key);

  @override
  _CerrarLoteriasAddScreenState createState() => _CerrarLoteriasAddScreenState();
}

class _CerrarLoteriasAddScreenState extends State<CerrarLoteriasAddScreen> {
  List<Loteria> listaLoteria;
  List<Cierreloteria> _cierres = [];
  Future _future;
  StreamController<List<Cierreloteria>> _streamController;

  Future<void> _init() async {
    var parsed = await LoteriaService.index(context: context);
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
  }

  _guardar() async {
    if(_cierres == null){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay cierres agregados");
      return;
    }

    var parsed = await CierreloteriaService.guardar(context: context, cierreLoterias: _cierres, servidores: await Servidor.all(context));
    List<Cierreloteria> cierres = (parsed["data"] != null) ? parsed["data"].map<Cierreloteria>((json) => Cierreloteria.fromMap(json)).toList() : [];
    Navigator.pop(context, cierres);
  }

  _agregar(){
    List<Loteria> _loteriasSeleccionadas = [];
    List<DateTime> _fechasSeleccionadas = [];

    showDialog(
      context: context, 
      builder: (context){

        return StatefulBuilder(
          builder: (context, setState) {
            _seleccionarLoterias() async {
              List<Loteria> loterias = await showDialog(
                context: context, 
                builder: (context){
                  return MyMultiSelectDialog<Loteria>(
                    initialSelectedValues: [],
                    items: listaLoteria.map<MyMultiSelectDialogItem<Loteria>>((e) => MyMultiSelectDialogItem<Loteria>(e, "${e.descripcion}")).toList(),
                  );
                }
              );

              print("CerrarLoteriasAddScreen _agregar.seleccionarLoterias: $loterias");
              setState(() => _loteriasSeleccionadas = loterias);
            }

            _seleccionarFechas(BuildContext context){
              showDialog(context: context, builder: (context){
                return MyAlertDialog(
                  small: 1,
                  medium: 1,
                  title: "Seleccionar fecha", 
                  content: MyDateRangeDialog(
                    showLeftStringDate: false,
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    date: _fechasSeleccionadas,
                    onOk: (dates){
                      setState(() {
                        _fechasSeleccionadas = dates;

                        if(_fechasSeleccionadas != null){
                          if(_fechasSeleccionadas.length > 1)
                            _fechasSeleccionadas.sort((a, b) => a.compareTo(b));
                        }

                      });
                      Navigator.pop(context);
                    },
                  ), 
                    okFunction: null
                  );
              });

              // showMyOverlayEntry(context: context, builder: (context, overlay){
              //   return MyDateRangeDialog(
              //     selectionMode: DateRangePickerSelectionMode.multiple,
              //     date: _fechasSeleccionadas,
              //     onOk: (dates){
              //       setState(() => _fechasSeleccionadas = dates);
              //       overlay.remove();
              //     },
              //   );
              // });
            
            }

            _agregarCierre(){
              if(_loteriasSeleccionadas == null){
                Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
                return;
              }
              if(_loteriasSeleccionadas.length == 0){
                Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
                return;
              }
              if(_fechasSeleccionadas == null){
                Utils.showAlertDialog(context: context, title: "Error", content: "No hay fechas seleccionadas");
                return;
              }
              if(_fechasSeleccionadas.length == 0){
                Utils.showAlertDialog(context: context, title: "Error", content: "No hay fechas seleccionadas");
                return;
              }


              for (var loteria in _loteriasSeleccionadas) {
                for (var date in _fechasSeleccionadas) {
                  if(_cierres.indexWhere((element) => element.idLoteria == loteria.id && Utils.dateTimeToDate(element.date, null) == Utils.dateTimeToDate(date, null)) == -1)
                    _cierres.add(Cierreloteria(loteria: loteria, idLoteria: loteria.id, date: date)); 
                } 
              }

              _streamController.add(_cierres);
              Navigator.pop(context);
            }

            return MyAlertDialog(
              xlarge: 5,
              large: 5,
              title: "Agregar cierres", 
              content: Wrap(
                children: [
                  MyDropdown(
                    title: null,
                    leading: Icon(Icons.group_work_outlined, color: Colors.black),
                    color: Colors.grey[300],
                    textColor: Colors.black,
                    hint: "${_loteriasSeleccionadas != null ? _loteriasSeleccionadas.length > 0 ? _loteriasSeleccionadas.map((e) => e.descripcion).join(", ") : 'Seleccionar loterias' : 'Seleccionar loterias'}",
                    onTap: _seleccionarLoterias,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Builder(
                      builder: (context) {
                        return MyDropdown(
                          title: null,
                          leading: Icon(Icons.date_range, color: Colors.black),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                          hint: "${_fechasSeleccionadas != null ? _fechasSeleccionadas.length > 0 ? MyDate.listDateTimeToNameOrString(_fechasSeleccionadas) : 'Seleccionar fechas' : 'Seleccionar fechas'}",
                          onTap: () => _seleccionarFechas(context),
                        );
                      }
                    ),
                  ),

                ],
              ), okFunction: _agregarCierre
            );
          }
        );
      }
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _future = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      floatingActionButton: FloatingActionButton(onPressed: _agregar, child: Icon(Icons.add)),
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Cerrar loterias",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar)
          ],
        ),
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            return SliverFillRemaining(
              child: StreamBuilder<List<Cierreloteria>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return MyEmpty(title: "No hay cierres para guardar", titleButton: "Agregar cierres", icon: Icons.timer, onTap: _agregar,);
                  if(snapshot.data.length == 0)
                    return MyEmpty(title: "No hay cierres para guardar", titleButton: "Agregar cierres", icon: Icons.timer, onTap: _agregar);

                  
                  List<Cierreloteria> listaConLoteriasUnicas = Utils.removeDuplicateLoteriasFromList(List<Cierreloteria>.from(snapshot.data));

                  return ListView.builder(
                    itemCount: listaConLoteriasUnicas.length,
                    itemBuilder: (context, index){
                       List<Cierreloteria> listaCierresParaEstaLoteria = snapshot.data.where((element) => element.loteria.id == listaConLoteriasUnicas[index].loteria.id).toList();
                      return ExpansionTile(
                        title: Row(
                          children: [
                            Text(listaConLoteriasUnicas[index].loteria.descripcion, style: TextStyle(fontWeight: FontWeight.bold),),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text("${listaCierresParaEstaLoteria.length}", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              )
                          ],
                        ),
                        children: listaCierresParaEstaLoteria.asMap().map((key, value) => MapEntry(key, ListTile(
                          leading: CircleAvatar(
                            child: Text("${key + 1}"),
                            radius: 16,
                            backgroundColor: Colors.grey[400],
                          ),
                          title: Text("${value.date.toString()}"),
                        ))).values.toList()
                      );
                    },
                  );
                }
              ),
            );
          }
        ),
      )
    );
  }
}