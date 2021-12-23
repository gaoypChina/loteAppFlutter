
// import 'cross_platform_db_stub.dart'
    import 'package:loterias/core/classes/cross_platform_sembas/cross_platform_sembas_stub.dart'

if (dart.library.io) 'mobile_sembas.dart'
    if (dart.library.js) 'web_sembas.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/pago.dart';

abstract class CrossSembas {
  // QueryExecutor getMoorCrossConstructor();
  getPlantForm();
  Future create();

  add(String key, var value);

  getValue(String key);

  delete(String key);

  addList(String key, List<dynamic> s);

  getList(String key);

  getListWithoutConvert(String key);

  addListStock(List<dynamic> s);
  getListStock();

  getIdUsuario();

  getIdBanca();

  getPrinter();

  Future<void> addOrRemovePagoPendiente(Pago pago);

  Future<Pago> getPagoPendiente();
  Future<void> removePagoPendiente();
  Future<void> addAjuste(Ajuste ajuste);
  Future<Ajuste> getAjuste();

  factory CrossSembas() => getSembas();
  
}