
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bloqueo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/widgets/MyPadding.dart';
import 'package:loterias/ui/widgets/mymontobloqueo.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';

class BloqueosVerJugada extends StatefulWidget {
  final String id;
  final Moneda moneda;
  final TipoBloqueo tipoBloqueo;
  final double monto;
  final String banca;
  const BloqueosVerJugada({Key key, @required this.id, @required this.moneda, @required this.tipoBloqueo, @required this.monto, this.banca = ''}) : super(key: key);

  @override
  State<BloqueosVerJugada> createState() => _BloqueosVerJugadaState();
}

class _BloqueosVerJugadaState extends State<BloqueosVerJugada> {
  Future _future;
  Bloqueo _bloqueo;
  bool _isSmallOrMedium = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _init();
  }

  _init() async {
    var data = await BloqueosService.mostrarJugadaDeLoteria(context: context, moneda: widget.moneda, tipoBloqueo: widget.tipoBloqueo, id: widget.id);
    _bloqueo = Bloqueo.fromMap(data["bloqueoJugada"]);
    print("BloqueosVerJugada _init: $data");
  }

  @override
  Widget build(BuildContext context) {
    _isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Jugadas",
          subtitle: FutureBuilder(
            future: _future,
            builder: (context, snapshot){
              if(snapshot.connectionState != ConnectionState.done)
                return SizedBox.shrink();

              return MyPadding(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: MyMontoBloqueo(monto: widget.monto, moneda: widget.moneda,),
                    ),
                    Visibility(visible: _esBloqueoJugadaPorBanca(), child: Text("${widget.banca}")),
                  ],
                ),
              );
            },
          ),
          actions: [
            MySliverButton(
              padding: EdgeInsets.all(0.0),
              // showOnlyOnSmall: true,
              title: _eliminarWidget(), 
              onTap: (){}
            )
          ],
        ), 
        sliver: SliverFillRemaining(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if(snapshot.hasError)
                return Utils.errorWidget(snapshot);
              if(snapshot.connectionState != ConnectionState.done)
                return Utils.cargandoWidget();
        
              return MyPadding(
                child: Column(
                  children: [
                    MySubtitle(title: "${_bloqueo.descripcionLoterias}"),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          // children: _getJugadas().map((e) => ListTile(leading: Icon(Icons.lock_clock), title: Text(e, style: TextStyle(fontWeight: FontWeight.w700),), subtitle: Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: _bloqueo.fechaHasta, end: _bloqueo.fechaHasta))}"),)).toList(),
                          children: _getJugadas().map((e) => _informacionBloqueo(e)).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        )
      )
    );
  }

  _eliminarWidget(){
    return IconButton(constraints: _actionIconsConstraint(), padding: EdgeInsets.all(0.0), onPressed: () => _eliminarBloqueo(), icon: Icon(Icons.delete, color: Colors.black,));
  }

  BoxConstraints _actionIconsConstraint(){
    return _isSmallOrMedium ? BoxConstraints(minHeight: 20) : null;
  }

  _eliminarBloqueo() async {
    var eliminado = await BloqueosService.mostrarDialogEliminarBloqueo(context, widget.tipoBloqueo, _bloqueo, widget.moneda);
    if(eliminado == true)
      Navigator.pop(context, eliminado);
  }

  List<String> _getJugadas(){
    String jugada = Utils.quitarPrimeraComa(_bloqueo.jugadas);
    jugada = Utils.quitarUltimaComa(jugada);
    jugada = jugada.trim();

    print("BloqueosVerJugada _getJugadas: $jugada");

    return jugada.split(",");
  }

  Widget _informacionBloqueo(String jugada){
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: InkWell(
        // onTap: () => _irABloqueoDetalle(bloqueo),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Utils.fromHex("#4F4F4F")),
            borderRadius: BorderRadius.circular(10)
          ),
          // child: ListTile(title: MySubtitle(title: "${Utils.toCurrency(bloqueo.monto)}", fontSize: 15,))
          // child: ListTile(title: Text("${Utils.toCurrency(bloqueo.monto)}",), subtitle: Text("${bloqueo.descripcionLoterias}"),),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: MySubtitle(title: "${jugada}", fontSize: 18, padding: EdgeInsets.all(0), fontWeight: FontWeight.bold, color: Utils.fromHex("#5E5858"),),
                  ),
                  // Visibility(visible: _esBloqueoJugadas(), child: Padding(
                  //   padding: const EdgeInsets.only(bottom: 8.0),
                  //   child: Text(_jugadas(bloqueo), style: TextStyle(color: Colors.black),),
                  // )),
                  // Visibility(visible: _esBloqueoPorBanca(), child: Padding(
                  //   padding: const EdgeInsets.only(bottom: 8.0),
                  //   child: Text(_descripcionBancas(bloqueo), style: TextStyle(color: Colors.black),),
                  // )),
                  Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: _bloqueo.fechaHasta, end: _bloqueo.fechaHasta))}", style: TextStyle(color: Utils.fromHex("#5E5858")),),
                ],
              ),
              Text("${Utils.toCurrency(_bloqueo.monto)}", style: TextStyle(fontSize: 15,color: Colors.green, fontWeight: FontWeight.bold),)
              // IconButton(onPressed: () async {
              //   bool bloqueoEliminado = await BloqueosService.mostrarDialogEliminarBloqueo(context, _getTipoBloqueo(), bloqueo, _moneda);;
              //   if(bloqueoEliminado == true)
              //     _buscarDatos();
              // }, icon: Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }


  _esBloqueoJugadaPorBanca(){
    return _getTipoBloqueo() == TipoBloqueo.jugadasPorBanca;
  }

  _esBloqueoJugada(){
    return _getTipoBloqueo() == TipoBloqueo.jugadas;
  }

  _getTipoBloqueo(){
     return widget.tipoBloqueo;
  }
}