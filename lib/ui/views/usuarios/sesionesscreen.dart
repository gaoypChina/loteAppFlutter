import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/sesion.dart';
import 'package:loterias/core/services/usuarioservice.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class SesionesScreen extends StatefulWidget {
  const SesionesScreen({ Key key }) : super(key: key);

  @override
  _SesionesScreenState createState() => _SesionesScreenState();
}

class _SesionesScreenState extends State<SesionesScreen> {
  StreamController<List<Sesion>> _streamController;
  DateTimeRange _date;
  MyDate _fecha;
  List<Sesion> listaData;
  int _idGrupo;

  _sesiones() async {
     _streamController.add(null);
     listaData = await UsuarioService.sesiones(context: context, fecha: _date, idGrupo: _idGrupo);
     _streamController.add(listaData);
  }

  _init() async {
    _date = MyDate.getTodayDateRange();
     _idGrupo = await Db.idGrupo();
     listaData = await UsuarioService.sesiones(context: context, fecha: _date, idGrupo: _idGrupo);
    _streamController.add(listaData);
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _sesiones();
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
        showListNormalCortaLarga: 2,
      ),
    )
    :
    "Observe las horas en las cuales los usuarios han iniciado sesion";
  }

  _listTile(Sesion sesion, int index){
      return Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Text("${index + 1}"),
          // title: Text("${sesion.usuario} ( ${sesion.banca} )"),
          title: Text("${sesion.usuario}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: sesion.primerInicioSesionPC != null || sesion.ultimoInicioSesionPC != null,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Icon(Icons.computer, size: 17),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text("${sesion.primerInicioSesionPC != null ? MyDate.datetimeToHour(sesion.primerInicioSesionPC) : ''}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text("${sesion.ultimoInicioSesionPC != null ? MyDate.datetimeToHour(sesion.ultimoInicioSesionPC) : ''}"),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: sesion.primerInicioSesionCelular != null || sesion.ultimoInicioSesionCelular != null,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Icon(Icons.phone_android, size: 17),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text("${sesion.primerInicioSesionCelular != null ? MyDate.datetimeToHour(sesion.primerInicioSesionCelular) : ''}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text("${sesion.ultimoInicioSesionCelular != null ? MyDate.datetimeToHour(sesion.ultimoInicioSesionCelular) : ''}"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Text("${sesion.banca}"),
        ),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
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
          floating: true,
          title: "Sesiones de los usuarios",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 85,
          actions: [
            MySliverButton(
              title: "title", 
              iconWhenSmallScreen: Icons.date_range,
              showOnlyOnSmall: true,
              onTap: () async {
                if(isSmallOrMedium){
                  var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime.now().subtract(Duration(days: 365 * 5)), lastDate: DateTime.now().add(Duration(days: 365 * 2)));
                  if(date == null)
                    return;
                  _dateChanged(DateTimeRange(
                    start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00:00"),
                    end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59"),
                  ));
                }
              }
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return MyDropdown(title: null, 
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: () async {
                        

                        showMyOverlayEntry(
                          context: context,
                          builder: (context, overlay){
                            _cancel(){
                              overlay.remove();
                            }
                            return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
                              print("SesionesScreen date: ${date}");
                              _dateChanged(date); 
                              overlay.remove();
                            },);
                          }
                        );
                      },
                    );
                   
                  }
                ),
              ), 
              onTap: (){}
              ),
          ],
        ), 
        sliver: StreamBuilder<List<Sesion>>(
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
              columns: ["Banca", "Usuario", "1er inicio en (PC)", "Ultimo inicio en (PC)", "1er inicio en (Celular)", "Ultimo inicio en (Celular)"], 
              rows: snapshot.data.map((e) => [
                e, e.banca, 
                e.usuario, 
                e.primerInicioSesionPC != null ? MyDate.datetimeToHour(e.primerInicioSesionPC) : '', 
                e.ultimoInicioSesionPC != null ? MyDate.datetimeToHour(e.ultimoInicioSesionPC) : '', 
                e.primerInicioSesionCelular != null ? MyDate.datetimeToHour(e.primerInicioSesionCelular) : '', 
                e.ultimoInicioSesionCelular != null ? MyDate.datetimeToHour(e.ultimoInicioSesionCelular) : ''
              ]).toList()
            )
          ]));

          }
        )
      )
    );
  }
}