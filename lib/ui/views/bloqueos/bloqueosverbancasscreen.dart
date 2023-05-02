

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bloqueo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/views/bloqueos/bloqueosdetallascreen.dart';
import 'package:loterias/ui/widgets/MyPadding.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:rxdart/rxdart.dart';

class BloqueosVerBancasScreen extends StatefulWidget {
  final String ids;
  final Moneda moneda;
  final TipoBloqueo tipoBloqueo;
  final double monto;
  const BloqueosVerBancasScreen({Key key, @required this.ids, @required this.moneda, @required this.tipoBloqueo, this.monto = 0}) : super(key: key);

  @override
  State<BloqueosVerBancasScreen> createState() => _BloqueosVerBancasScreenState();
}

class _BloqueosVerBancasScreenState extends State<BloqueosVerBancasScreen> {
  StreamController<List<Bloqueo>> _streamControllerBloqueosPorBancas;
  List<Bloqueo> listaBloqueoPorLoterias = [];
  Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamControllerBloqueosPorBancas = BehaviorSubject();
    _future = _init();
  }

  _init() async {
    var datos = await BloqueosService.porBancaMostrarBancas(context: context, ids: widget.ids, moneda: widget.moneda, tipoBloqueo: widget.tipoBloqueo);
    listaBloqueoPorLoterias = Bloqueo.fromMapList(datos["bloqueosAgrupadosPorBanca"]);
    _streamControllerBloqueosPorBancas.add(listaBloqueoPorLoterias);
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
                child: _montoBloqueoWidget(),
              );
            },
          ),
        ), 
        sliver: StreamBuilder<Object>(
          stream: _streamControllerBloqueosPorBancas.stream,
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

  Widget _montoBloqueoWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
      child: Text("${Utils.toCurrency(widget.monto)} ${widget.moneda.abreviatura}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
      isThreeLine: true,
      title: MySubtitle(title: "${_descripcionBanca(bloqueo)}", padding: EdgeInsets.all(0), fontSize: 15,), 
      subtitle: _bloqueoSutitulo(bloqueo), 
      trailing: IconButton(icon: Icon(Icons.delete, color: Colors.black,), onPressed: () async {
        bool bloqueoEliminado = await _eliminarLimite(bloqueo);
        if(bloqueoEliminado == true)
          _init();
      }),
      onTap: () => _mostrarBloqueosDeLoteria(bloqueo),
    );
  }

  _descripcionBanca(Bloqueo bloqueo){
    if(bloqueo.descripcionBancas.length > 20)
      return bloqueo.descripcionBancas.substring(0, 20)  + "...";
    else 
      return bloqueo.descripcionBancas;
  }
  
  _bloqueoSutitulo(Bloqueo bloqueo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bloqueo.codigoBancas),
          Visibility(visible: _esBloqueoJugadasPorBanca(), child: Text(_jugadas(bloqueo))),
          Text(_descripcionLoterias(bloqueo)),
        ],
      );
  }

  String _jugadas(Bloqueo bloqueo) {
    if(bloqueo.jugadas == null)
      return '';
    if(bloqueo.jugadas.isEmpty)
      return '';
    if(bloqueo.jugadas.indexOf(",") == -1)
        return bloqueo.jugadas;

      List<String> jugadas = bloqueo.jugadas.split(",");
      int posicionPrimeraComa = 0;
      int posicionUltimaComa = jugadas.length - 1;
      jugadas.remove(posicionPrimeraComa);
      jugadas.remove(jugadas[posicionUltimaComa]);
      String jugadasSeparadasPorComa = jugadas.join(", ");
    if(jugadasSeparadasPorComa.length > 35)
      return jugadasSeparadasPorComa.substring(0, 35)  + "...";
    else 
      return jugadasSeparadasPorComa;
  }

  String _descripcionLoterias(Bloqueo bloqueo) {
    if(bloqueo.descripcionLoterias.length > 45)
      return bloqueo.descripcionLoterias.substring(0, 45)  + "...";
    else 
      return bloqueo.descripcionLoterias;
  }
  
  _mostrarBloqueosDeLoteria(Bloqueo bloqueo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context){
         return BloqueosDetalleScreen(
           ids: bloqueo.ids, 
           moneda: widget.moneda,
           tipoBloqueo: widget.tipoBloqueo,
           banca: bloqueo.descripcionBancas,
           monto: widget.monto,
          );
       }));
  }

  Future<bool> _eliminarLimite(Bloqueo bloqueo) async {
    return await BloqueosService.mostrarDialogEliminarBloqueo(context, widget.tipoBloqueo, bloqueo, widget.moneda);
  }

  _esBloqueoJugadasPorBanca(){
    return _getTipoBloqueo() == TipoBloqueo.jugadasPorBanca;
  }

  _getTipoBloqueo(){
    return widget.tipoBloqueo;
  }
  
}