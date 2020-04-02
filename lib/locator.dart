
import 'package:get_it/get_it.dart';



GetIt locator = GetIt();

void setupLocator() {
  locator.allowReassignment = true;
  // locator.registerLazySingleton(() => Api('products'));
  // locator.registerLazySingleton(() => CRUDModel()) ;
  // locator.registerLazySingleton(() => UnidadCRUD()) ;
  // locator.registerLazySingleton(() => CRUDArticulo()) ;
  

  // locator.registerFactory(() => Api('products'));
  // locator.registerFactory(() => CRUDModel()) ;
  
// locator.registerFactory(() => Api('unidades'));
//   locator.registerFactory(() => UnidadCRUD()) ;
}