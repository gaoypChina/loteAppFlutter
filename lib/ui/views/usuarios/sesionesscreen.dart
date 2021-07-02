import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
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

  _sesiones() async {
     listaData = await UsuarioService.sesiones(context: context, fecha: _date);
     _streamController.add(listaData);
  }

  _init() async {
    _date = MyDate.getTodayDateRange();
    _sesiones();
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
        value: _date,
        paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        onChanged: _dateChanged,
      ),
    )
    :
    "Observe las horas en las cuales los usuarios han iniciado sesion";
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
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return MyDropdown(title: null, 
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: (){
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

          return SliverList(delegate: SliverChildListDelegate([
            MySubtitle(title: "Datos"),
            MyTable(
              isScrolled: false,
              columns: ["Banca", "Usuario", "1er inicio en (PC)", "Ultimo inicio en (PC)", "1er inicio en (Celular)", "Ultimo inicio en (Celular)"], 
              rows: snapshot.data.map((e) => [
                e, e.banca, 
                e.usuario, 
                e.primerInicioSesionPC != null ? e.primerInicioSesionPC.toString() : '', 
                e.ultimoInicioSesionPC != null ? e.ultimoInicioSesionPC.toString() : '', 
                e.primerInicioSesionCelular != null ? e.primerInicioSesionCelular.toString() : '', 
                e.ultimoInicioSesionCelular != null ? e.ultimoInicioSesionCelular.toString() : ''
              ]).toList()
            )
          ]));

          }
        )
      )
    );
  }
}