

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bloqueo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/views/bloqueos/bloqueosverjugada.dart';
import 'package:loterias/ui/widgets/MyPadding.dart';
import 'package:loterias/ui/widgets/mymontobloqueo.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:rxdart/rxdart.dart';

class BloqueosDetalleScreen extends StatefulWidget {
  final String ids;
  final Moneda moneda;
  final TipoBloqueo tipoBloqueo;
  final String banca;
  final double monto;
  const BloqueosDetalleScreen({Key key, @required this.ids, @required this.moneda, @required this.tipoBloqueo, this.banca = '', this.monto = 0}) : super(key: key);

  @override
  State<BloqueosDetalleScreen> createState() => _BloqueosDetalleScreenState();
}

class _BloqueosDetalleScreenState extends State<BloqueosDetalleScreen> {
  StreamController<List<Bloqueo>> _streamControllerBloqueosPorLoterias;
  List<Bloqueo> listaBloqueoPorLoterias = [];
  Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamControllerBloqueosPorLoterias = BehaviorSubject();
    _future = _init();
  }

  _init() async {
    var datos = await BloqueosService.mostrarLoterias(context: context, ids: widget.ids, moneda: widget.moneda, tipoBloqueo: widget.tipoBloqueo);
    listaBloqueoPorLoterias = Bloqueo.fromMapList(datos["bloqueosAgrupadosPorLoteria"]);
    _streamControllerBloqueosPorLoterias.add(listaBloqueoPorLoterias);
    print("BloqueosDetalleScreen _init: $datos");
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
          title: "Detalle bloqueo",
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
                    Visibility(visible: _esBloqueoPorBanca() || _esBloqueoJugadas(), child: Text("${widget.banca}")),
                  ],
                ),
              );
            },
          ),
        ), 
        sliver: StreamBuilder<Object>(
          stream: _streamControllerBloqueosPorLoterias.stream,
          builder: (context, snapshot) {

            if(snapshot.hasError)
              return SliverFillRemaining(child: _errorWidget(snapshot.error));
            if(!snapshot.hasData)
              return SliverFillRemaining(child: _cargandoWidget());


            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => _bloqueoWidget(listaBloqueoPorLoterias[index]),
              childCount: listaBloqueoPorLoterias.length
            ));
          }
        )
      )
    );
  }
  
  Widget _errorWidget(Object error) {
    return Center(child: Text("Error: ${error}"));
  }
  
  Widget _cargandoWidget() {
    return Center(child: CircularProgressIndicator());
  }
  
  Widget _bloqueoWidget(Bloqueo bloqueo) {
    return ListTile(
      isThreeLine: _esBloqueoJugadas(),
      title: MySubtitle(title: "${bloqueo.descripcionLoterias}", padding: EdgeInsets.all(0), fontSize: 15,), 
      subtitle: _bloqueoSutitulo(bloqueo), 
      trailing: IconButton(icon: Icon(Icons.delete, color: Colors.black,), onPressed: () async {
        bool bloqueoEliminado = await _eliminarBloqueo(bloqueo);
        if(bloqueoEliminado == true)
          _init();
      }),
      onTap: () => _esBloqueoJugadas() ? _mostrarBloqueoJugadaDeLoteria(bloqueo) : _mostrarBloqueosDeLoteria(bloqueo),
    );
  }
  
  Widget _bloqueoSutitulo(Bloqueo bloqueo) {
     if(_esBloqueoGeneral() || _esBloqueoPorBanca()){
      return Text(_dias(bloqueo));
     }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_jugadas(bloqueo)),
          Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: bloqueo.fechaHasta, end: bloqueo.fechaHasta))}"),
        ],
      );
  }
  
  _dias(Bloqueo bloqueo){
    int cantidadDiasDeLaSemana = 7;
    if(cantidadDiasDeLaSemana == bloqueo.cantidadDias)
      return "Diariamente";
    return "${bloqueo.cantidadDias == cantidadDiasDeLaSemana ? 'Diariamente' : bloqueo.descripcionDias}";
  }

  String _jugadas(Bloqueo bloqueo) {
    if(bloqueo.jugadas == null)
      return '';
    if(bloqueo.jugadas.isEmpty)
      return '';
    if(bloqueo.jugadas.indexOf(",") == -1)
        return bloqueo.jugadas;

      String jugada = Utils.quitarPrimeraComa(bloqueo.jugadas);
      jugada = Utils.quitarUltimaComa(jugada);
      List<String> jugadas = jugada.split(",");
      // int posicionPrimeraComa = 0;
      // int posicionUltimaComa = jugadas.length - 1;
      // jugadas.remove(posicionPrimeraComa);
      // jugadas.remove(jugadas[posicionUltimaComa]);
      // String jugadasSeparadasPorComa = jugadas.join(", ");
      String jugadasSeparadasPorComa = jugadas.join(", ");

    if(jugadasSeparadasPorComa.length > 35)
      return jugadasSeparadasPorComa.substring(0, 35)  + "...";
    else 
      return jugadasSeparadasPorComa;
  }

  _mostrarBloqueosDeLoteria(Bloqueo bloqueo) {
    Future<List<Bloqueo>> _future = _getBloqueosPorDiaDeLoteria(bloqueo);
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("${bloqueo.descripcionLoterias}"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: SingleChildScrollView(
            child: FutureBuilder<List<Bloqueo>>(
              future: _future,
              builder: (context, snapshot) {
                if(snapshot.hasError)
                  return _errorWidget(snapshot.error);
          
                if(snapshot.connectionState != ConnectionState.done)
                  return _cargandoWidget();
          
                return Column(
                  children: snapshot.data.map((bloqueo) =>  ListTile(
                      title: Text("${bloqueo.descripcionDias}"),
                      trailing: IconButton(icon: Icon(Icons.delete), onPressed: () async {
                        bool bloqueoEliminado = await _eliminarBloqueo(bloqueo);
                        if(bloqueoEliminado == true){
                          _init();
                          Navigator.pop(context);
                        }
                      },),
                    )).toList(),
                );
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text("${snapshot.data[index].abreviaturaDias}"),
                      trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){},),
                    );
                  }
                );
              }
            ),
          ),
        );
      }
    );
  }

  _mostrarBloqueoJugadaDeLoteria(Bloqueo bloqueo) async {
    var eliminado = await Navigator.push(context, MaterialPageRoute(builder: (context){
         return BloqueosVerJugada(
           id: bloqueo.ids, 
           moneda: widget.moneda,
           tipoBloqueo: _getTipoBloqueo(),
           monto: bloqueo.monto,
           banca: widget.banca,
          );
       }));
    if(eliminado == true)
      _init();
  }

  Future<bool> _eliminarBloqueo(Bloqueo bloqueo) async {
    return await BloqueosService.mostrarDialogEliminarBloqueo(context, widget.tipoBloqueo, bloqueo, widget.moneda);
  }
  
  Future<List<Bloqueo>> _getBloqueosPorDiaDeLoteria(Bloqueo bloqueo) async {
    var datos = await BloqueosService.mostrarDiasDeLoteria(context: context, moneda: widget.moneda, ids: bloqueo.ids, tipoBloqueo: _getTipoBloqueo());
    return Bloqueo.fromMapList(datos["bloqueosDiasDeLoteria"]);
  }

  _esBloqueoJugadas(){
    return !_esBloqueoGeneral() && !_esBloqueoPorBanca();
  }

  _esBloqueoPorBanca(){
    return _getTipoBloqueo() == TipoBloqueo.porBancas;
  }

  _esBloqueoGeneral(){
    return _getTipoBloqueo() == TipoBloqueo.general;
  }

  _getTipoBloqueo(){
     return widget.tipoBloqueo;
  }
}