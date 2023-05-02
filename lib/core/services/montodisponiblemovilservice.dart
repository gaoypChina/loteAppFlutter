import 'package:flutter/foundation.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/services/sorteoservice.dart';

class MontoDisponibleMovilService{
  String _jugada;
  Loteria _loteria;
  Banca _banca; 
  Loteria _loteriaSuperpale;
  var _sqfliteTransaction;
  int _idDia;
  int _idSorteo;
  double _montoDisponible;
  Stock _stockARetornar;

  static get descontarDelBloqueoGeneral => kIsWeb ? "descontar_del_bloqueo_general" : "descontarDelBloqueoGeneral";
  static get ignorarDemasBloqueos => kIsWeb ? "ignorar_demas_bloqueos" : "ignorarDemasBloqueos";
  static get esBloqueoJugada => kIsWeb ? "es_bloqueo_jugada" : "esBloqueoJugada";
  static Future<MontoDisponible> obtener(String jugada, Loteria loteria, Banca banca, Loteria loteriaSuperpale, {var sqfliteTransaction}) async {
    return await MontoDisponibleMovilService._(jugada, loteria, banca, loteriaSuperpale, sqfliteTransaction: sqfliteTransaction).obtenerMonto();
  }

  MontoDisponibleMovilService._(String jugada, Loteria loteria, Banca banca, Loteria loteriaSuperpale, {var sqfliteTransaction}){
    _jugada = jugada;
    _loteria = loteria;
    _banca = banca; 
    _loteriaSuperpale = loteriaSuperpale;
    _sqfliteTransaction = sqfliteTransaction;
  }

  Future<MontoDisponible> obtenerMonto() async {
    await llenarIdDiaYIdSorteo();
    await siEsSorteoPickOSuperpaleQuitarUltimoCaracterALaJugada();
    siIdLoteriaMayorQueIdLoteriaSuperpaleIntercambiarLoterias();
    // return await buscarMontoDisponible();
    return await buscarMontoDisponible();
  }
  
  Future<void> llenarIdDiaYIdSorteo() async {
    _idDia = Utils.getIdDia();
    _idSorteo = await SorteoService.getIdSorteo(_jugada, _loteria, _sqfliteTransaction);
  }
  
  Future<void> siEsSorteoPickOSuperpaleQuitarUltimoCaracterALaJugada() async {
    _jugada = await SorteoService.esSorteoPickQuitarUltimoCaracter(_jugada, _idSorteo, _sqfliteTransaction);
  }
  
  void siIdLoteriaMayorQueIdLoteriaSuperpaleIntercambiarLoterias() {
    if(!esSorteoSuperpale())
      return;
    if(_loteria.id > _loteriaSuperpale.id){
        Loteria tmp = _loteriaSuperpale;
        _loteriaSuperpale = _loteria;
        _loteria = tmp;
      }
  }
  
  bool esSorteoSuperpale() => SorteoService.esSorteoSuperpale(_idSorteo);

  Future<MontoDisponible> buscarMontoDisponible() async {
    await asignarBloqueoPorBancaStock();
    await asignarIgnorarDemasBloqueosOIntercambiarPorBloqueosGenerales();
    await asignarBloqueoStockOPorBancaOIntercambiarPorBloqueosGenerales();
    await asignarBloqueoJugadaGeneralIgnorarDemasBloqueos();
    await asingnarBloqueoJugadaPorBancaOGeneralOIntercambiarPorGeneral();
    await asignarBloqueoLoteriaPorBancaOGeneralOIntercambiarPorGeneral();
    await asignarBloqueoGeneral();
    print("MontoDisponibleMovilservice buscarMontoDisponible: $_montoDisponible");
    return obtenerMontoDisponible();
  }
  
  Future<void> asignarBloqueoPorBancaStock() async {
    List<Map<String, dynamic>> datos = await Db.obtenerMontoDeTablaStock(idBanca: _banca.id, idLoteria: _loteria.id, idSorteo: _idSorteo, jugada: _jugada, idMoneda: _banca.idMoneda, esGeneral: 0, idLoteriaSuperpale: obtenerIdLoteriaSuperpale(), sqfliteTransaction: _sqfliteTransaction);
    print("MontoDisponibleMovilservice asignarBloqueoPorBancaStock: $datos");
    if(datos.isNotEmpty)
      llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: datos.first['monto'], descontarDelBloqueoGeneral: datos.first[descontarDelBloqueoGeneral], esBloqueoJugada: datos.first[esBloqueoJugada]);
  }
  
  Future<void> asignarIgnorarDemasBloqueosOIntercambiarPorBloqueosGenerales() async {
    if(!hayMontoDisponible())
      return;
    List<Map<String, dynamic>> bloqueosGeneralesDeTablaStock = await obtenerBloqueosGeneralesDeTablaStock();
    if(esIgnorarDemasBloqueos(bloqueosGeneralesDeTablaStock))
      asignarIgnorarDemasBloqueosDeTablaStock(bloqueosGeneralesDeTablaStock);
    else{
      List<Map<String, dynamic>> bloqueosJugadasGenerales = await obtenerBloqueosJugadasGenerales();
      asignarIgnorarDemasBloqueosOIntercambiarPorBloqueoGeneral(bloqueosJugadasGenerales, bloqueosGeneralesDeTablaStock);
    }
  }

  asignarIgnorarDemasBloqueosDeTablaStock(List<Map<String, dynamic>> bloqueosStock){
    asignarIgnorarDemasBloqueos(bloqueosStock);
  }

  Future<void> asignarIgnorarDemasBloqueosOIntercambiarPorBloqueoGeneral(List<Map<String, dynamic>> bloqueosJugadasGenerales, bloqueosGeneralesDeTablaStock) async {
    if(esIgnorarDemasBloqueos(bloqueosJugadasGenerales))
      asignarIgnorarDemasBloqueosDesdeBloqueoJugadas(bloqueosJugadasGenerales);
    else
      await intercambiarPorBloqueoGeneral(bloqueosJugadasGenerales, bloqueosGeneralesDeTablaStock);
  }

  Future<void> intercambiarPorBloqueoGeneral(bloqueosJugadasGenerales, bloqueosGeneralesDeTablaStock) async{
    if(!esDescontarDelBloqueoGeneral(_stockARetornar))
      return;
    if(bloqueosGeneralesDeTablaStock.isNotEmpty)
      siEsMenorQueMontoDisponibleIntercambiar(bloqueosGeneralesDeTablaStock.first, bloqueosGeneralesDeTablaStock.first[esBloqueoJugada]);
    else if(bloqueosJugadasGenerales.isNotEmpty)
      siEsMenorQueMontoDisponibleIntercambiar(bloqueosJugadasGenerales.first, 1);
    else{
      List<Map<String, dynamic>> bloqueoGenerales = await obtenerBloqueosGenerales();
      if(bloqueoGenerales.isNotEmpty)
        siEsMenorQueMontoDisponibleIntercambiar(bloqueoGenerales.first, 0);
    }
  }

  Future<void> asignarBloqueoStockOPorBancaOIntercambiarPorBloqueosGenerales() async {
    if(hayMontoDisponible()) return;
    List<Map<String, dynamic>> bloqueosGeneralesDeTablaStock = await obtenerBloqueosGeneralesDeTablaStock();
    if(bloqueosGeneralesDeTablaStock.isEmpty) return;
    if(!esIgnorarDemasBloqueos(bloqueosGeneralesDeTablaStock))
      await asignarBloqueoLoteriaJugadaPorBancaOIntercambiar(bloqueosGeneralesDeTablaStock);
    else
      llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosGeneralesDeTablaStock.first["monto"], esGeneral: 1, ignorarDemasBloqueos: 1, esBloqueoJugada: bloqueosGeneralesDeTablaStock.first[esBloqueoJugada]);
  }

  Future<List<Map<String, dynamic>>> obtenerBloqueosGeneralesDeTablaStock() async {
    return await Db.obtenerMontoDeTablaStock(idLoteria: _loteria.id, idSorteo: _idSorteo, jugada: _jugada, esGeneral: 1, idMoneda: _banca.idMoneda, idLoteriaSuperpale: obtenerIdLoteriaSuperpale(), sqfliteTransaction: _sqfliteTransaction);
  }

  Future<void> asignarBloqueoLoteriaJugadaPorBancaOIntercambiar(List<Map<String, dynamic>> bloqueosGeneralesDeTablaStock) async {
    List<Map<String, dynamic>> bloqueosJugadasPorBanca = await obtenerBloqueosJugadasPorBanca();
    if(bloqueosJugadasPorBanca.isNotEmpty)
      asignarBloqueoJugadaPorBancaOIntercambiar(bloqueosJugadasPorBanca, bloqueosGeneralesDeTablaStock);
    else{
      List<Map<String, dynamic>> bloqueosLoteriasPorBanca = await obtenerBloqueosLoteriasPorBanca();
      if(bloqueosLoteriasPorBanca.isNotEmpty)
        asignarBloqueoLoteriaPorBancaOIntercambiar(bloqueosLoteriasPorBanca, bloqueosGeneralesDeTablaStock);
      else
        asignarDesdeBloqueoGeneral(bloqueosGeneralesDeTablaStock);
    }
  }

  void asignarBloqueoJugadaPorBancaOIntercambiar(List<Map<String, dynamic>> bloqueosJugadasPorBanca, List<Map<String, dynamic>> bloqueosGeneralesDeTablaStock){
    llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosJugadasPorBanca.first["monto"], esGeneral: 0, descontarDelBloqueoGeneral: bloqueosJugadasPorBanca.first[descontarDelBloqueoGeneral], esBloqueoJugada: 1);
    if(esDescontarDelBloqueoGeneral(_stockARetornar))
      siEsMenorQueMontoDisponibleIntercambiar(bloqueosGeneralesDeTablaStock.first, 1);
  }

  void asignarBloqueoLoteriaPorBancaOIntercambiar(List<Map<String, dynamic>> bloqueosLoteriasPorBanca, List<Map<String, dynamic>> bloqueosGeneralesDeTablaStock) {
    llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosLoteriasPorBanca.first["monto"], esGeneral: 0, descontarDelBloqueoGeneral: bloqueosLoteriasPorBanca.first[descontarDelBloqueoGeneral]);
    if(esDescontarDelBloqueoGeneral(_stockARetornar))
      siEsMenorQueMontoDisponibleIntercambiar(bloqueosGeneralesDeTablaStock.first);
  }

  void asignarDesdeBloqueoGeneral(List<Map<String, dynamic>> bloqueosGeneralesDeTablaStock){
    llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosGeneralesDeTablaStock.first["monto"], esGeneral: 1, esBloqueoJugada: bloqueosGeneralesDeTablaStock.first[esBloqueoJugada]);
  }

  Future<void> asignarBloqueoJugadaGeneralIgnorarDemasBloqueos() async {
    if(hayMontoDisponible())
      return;
    List<Map<String, dynamic>> bloqueosJugadasGenerales = await obtenerBloqueosJugadasGenerales();
    if(esIgnorarDemasBloqueos(bloqueosJugadasGenerales))
      asignarIgnorarDemasBloqueosDesdeBloqueoJugadas(bloqueosJugadasGenerales);
  }

  bool esIgnorarDemasBloqueos(List<Map<String, dynamic>> bloqueos){
    if(bloqueos.isEmpty)
      return false;
    return bloqueos.indexWhere((element) => element[ignorarDemasBloqueos] == 1) != -1;
  }

  asignarIgnorarDemasBloqueosDesdeBloqueoJugadas(List<Map<String, dynamic>> bloqueosJugadasGeneral){
    asignarIgnorarDemasBloqueos(bloqueosJugadasGeneral);
  }

  void asignarIgnorarDemasBloqueos(List<Map<String, dynamic>> bloqueos){
    Map<String, dynamic> bloqueoConCampoIgnorarDemasBloqueosActivo = bloqueos[obtenerIndiceDelElementoConCampoIgnorarDemasBloqueosActivo(bloqueos)];
    llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueoConCampoIgnorarDemasBloqueosActivo['monto'], esGeneral: 1, ignorarDemasBloqueos: 1, esBloqueoJugada: bloqueoConCampoIgnorarDemasBloqueosActivo[esBloqueoJugada]);
  }

  int obtenerIndiceDelElementoConCampoIgnorarDemasBloqueosActivo(List<Map<String, dynamic>> bloqueos){
    return bloqueos.indexWhere((element) => element[ignorarDemasBloqueos] == 1);
  }

  Future<void> asingnarBloqueoJugadaPorBancaOGeneralOIntercambiarPorGeneral() async {
    if(hayMontoDisponible())
      return;
    List<Map<String, dynamic>> bloqueosJugadasPorBanca = await obtenerBloqueosJugadasPorBanca();
    print("MontoDisponibleMovilservice asingnarBloqueoJugadaPorBancaOGeneralOIntercambiarPorGeneral: $_montoDisponible");
    if(bloqueosJugadasPorBanca.isNotEmpty)
      await asignarBloqueoJugadaPorBancaOIntercambiarPorGeneral(bloqueosJugadasPorBanca);
    else
      await asignarBloqueoJugadaGeneral();
  }

  Future<List<Map<String, dynamic>>> obtenerBloqueosJugadasPorBanca() async {
    return await Db.obtenerMontoDeTablaBlocksplays(idBanca: _banca.id, idLoteria: _loteria.id, idSorteo: _idSorteo, jugada: _jugada, idMoneda: _banca.idMoneda, sqfliteTransaction: _sqfliteTransaction);
  }

  Future<void> asignarBloqueoJugadaPorBancaOIntercambiarPorGeneral(List<Map<String, dynamic>> bloqueosJugadasPorBanca) async {
    llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosJugadasPorBanca.first["monto"], esGeneral: 0, descontarDelBloqueoGeneral: bloqueosJugadasPorBanca.first[descontarDelBloqueoGeneral], esBloqueoJugada: 1);
    if(esDescontarDelBloqueoGeneral(_stockARetornar))
      await intercambiarPorBloqueosLoteriasJugadasGenerales(esBloqueJugada: 1);
  }

  Future<void> asignarBloqueoJugadaGeneral() async {
    List<Map<String, dynamic>> bloqueosJugadasGeneral = await obtenerBloqueosJugadasGenerales();
    if(bloqueosJugadasGeneral.isNotEmpty)
      llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosJugadasGeneral.first["monto"], esGeneral: 1, ignorarDemasBloqueos: 0, esBloqueoJugada: 1);
  }

  Future<void> asignarBloqueoLoteriaPorBancaOGeneralOIntercambiarPorGeneral() async {
    if(hayMontoDisponible())
      return;
    List<Map<String, dynamic>> bloqueosLoteriasPorBanca = await obtenerBloqueosLoteriasPorBanca();
    if(bloqueosLoteriasPorBanca.isEmpty)
      return;
    llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosLoteriasPorBanca.first["monto"], esGeneral: 0, descontarDelBloqueoGeneral: bloqueosLoteriasPorBanca.first[descontarDelBloqueoGeneral]);
    if(esDescontarDelBloqueoGeneral(_stockARetornar))
      await intercambiarPorBloqueosLoteriasJugadasGenerales();
  }

  Future<List<Map<String, dynamic>>> obtenerBloqueosLoteriasPorBanca() async{
    return await Db.obtenerMontoDeTablaBlockslotteries(idBanca: _banca.id, idLoteria: _loteria.id, idSorteo: _idSorteo, idDia: _idDia, idMoneda: _banca.idMoneda, idLoteriaSuperpale: obtenerIdLoteriaSuperpale(), sqfliteTransaction: _sqfliteTransaction);
  }

  bool esDescontarDelBloqueoGeneral(Stock stockARetornar){
    return _stockARetornar.descontarDelBloqueoGeneral == 1;
  }

  Future<void> intercambiarPorBloqueosLoteriasJugadasGenerales({esBloqueJugada = 0}) async {
    List<Map<String, dynamic>> bloqueosJugadasGeneral = await obtenerBloqueosJugadasGenerales();
    if(bloqueosJugadasGeneral.isNotEmpty)
      siEsMenorQueMontoDisponibleIntercambiar(bloqueosJugadasGeneral.first, 1);
    else{
      List<Map<String, dynamic>> bloqueosGenerales = await obtenerBloqueosGenerales();
      if(bloqueosGenerales.isNotEmpty)
        siEsMenorQueMontoDisponibleIntercambiar(bloqueosGenerales.first, esBloqueJugada);
    }
  }

  Future<List<Map<String, dynamic>>> obtenerBloqueosJugadasGenerales() async {
    return await Db.obtenerMontoDeTablaBlocksplaysgenerals(idLoteria: _loteria.id, idSorteo: _idSorteo, jugada: _jugada, idMoneda: _banca.idMoneda, sqfliteTransaction: _sqfliteTransaction);
  }

  void siEsMenorQueMontoDisponibleIntercambiar(Map<String, dynamic> bloqueoDeTablaStock, [int esBloqueoJugada = 0]){
    if(bloqueoDeTablaStock["monto"] < _montoDisponible)
      llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueoDeTablaStock["monto"], esGeneral: 1, ignorarDemasBloqueos: 0, esBloqueoJugada: esBloqueoJugada);
  }

  Future<void> asignarBloqueoGeneral() async {
    if(hayMontoDisponible())
      return;
    List<Map<String, dynamic>> bloqueosGenerales = await obtenerBloqueosGenerales();
    if(bloqueosGenerales.isNotEmpty)
      llenarVariablesMontoDisponibleYStockARetornar(montoDisponible: bloqueosGenerales.first["monto"], esGeneral: 1);
  }

  bool hayMontoDisponible(){
    return _montoDisponible != null;
  }

  Future<List<Map<String, dynamic>>> obtenerBloqueosGenerales() async {
    return await Db.obtenerMontoDeTablaGenerals(idLoteria: _loteria.id, idSorteo: _idSorteo, idDia: _idDia, idMoneda: _banca.idMoneda, idLoteriaSuperpale: obtenerIdLoteriaSuperpale(), sqfliteTransaction: _sqfliteTransaction);
  }

  void llenarVariablesMontoDisponibleYStockARetornar({var montoDisponible, esGeneral = 0, descontarDelBloqueoGeneral, esBloqueoJugada = 0, ignorarDemasBloqueos = 0}){
    _montoDisponible = Utils.toDouble(montoDisponible);
    _stockARetornar = Stock(idBanca: _banca.id, idLoteria: _loteria.id, idSorteo: _idSorteo, jugada: _jugada, esGeneral: esGeneral, idMoneda: _banca.idMoneda, descontarDelBloqueoGeneral: descontarDelBloqueoGeneral, esBloqueoJugada: esBloqueoJugada, ignorarDemasBloqueos: ignorarDemasBloqueos, idLoteriaSuperpale: obtenerIdLoteriaSuperpale());
  }

  MontoDisponible obtenerMontoDisponible(){
    if(!hayMontoDisponible())
      _montoDisponible = 0;
    anexarIdLoteriaSuperpaleYMontoAlStockARetornar();
    return MontoDisponible(monto: _stockARetornar.monto, stock: _stockARetornar);
  }

  anexarIdLoteriaSuperpaleYMontoAlStockARetornar(){
    if(_stockARetornar != null){
      _stockARetornar.monto = _montoDisponible;
      _stockARetornar.idLoteriaSuperpale = obtenerIdLoteriaSuperpale();
    }else
      _stockARetornar = Stock(monto: _montoDisponible);
  }

  obtenerIdLoteriaSuperpale(){
    return _loteriaSuperpale != null ? _loteriaSuperpale.id : null;
  }

}