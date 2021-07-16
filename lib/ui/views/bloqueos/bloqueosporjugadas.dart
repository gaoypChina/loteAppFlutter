import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';

class BloqueosPorJugadas extends StatefulWidget {
  const BloqueosPorJugadas({ Key key }) : super(key: key);

  @override
  _BloqueosPorJugadasState createState() => _BloqueosPorJugadasState();
}

class _BloqueosPorJugadasState extends State<BloqueosPorJugadas> {
  DateTimeRange _date;
  MyDate _fecha;
  Future _future;
  List<Banca> listaBanca = [];
  List<Loteria> listaLoteria = [];
  List<Draws> listaSorteo = [];
  List<Dia> listaDia = [];
  List<Moneda> listaMoneda = [];
  List<String> listaTipo = ["General", "Por banca"];
  String _selectedTipo = "General";
  Moneda _selectedMoneda;
  List<Banca> _bancas = [];
  List<Dia> _dias = [];
  List<Loteria> _loterias = [];
  List<Draws> _sorteos = [];
  bool _descontarDelBloqueoGeneral = true;
  var _cargandoNotify = ValueNotifier<bool>(false);


  _init() async {
    _date = MyDate.getTodayDateRange();
    var parsed = await BloqueosService.index(context: context);
    listaBanca = (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((json) => Draws.fromMap(json)).toList() : [];
    listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];

    if(listaMoneda.length > 0)
      _selectedMoneda = listaMoneda[0];

    if(listaDia.length > 0)
      _dias = List.from(listaDia);

    print("BloqueosPorJugadasScreen: ${parsed}");
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      // _getData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
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
          title: "Limitar jugadas",
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
                          right: 10,
                            context: context,
                            builder: (context, overlay){
                              _cancel(){
                                overlay.remove();
                              }
                              return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
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
        sliver: SliverFillRemaining(
          child: Text("Klk blo"),
        )
      )
    );
  }
}