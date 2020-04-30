import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:loterias/ui/splashscreen.dart';
import 'package:loterias/ui/views/actualizar/actualizar.dart';
import 'package:loterias/ui/views/balance/balancebanca.dart';
import 'package:loterias/ui/views/bluetoothdevice/bluetooth.dart';
import 'package:loterias/ui/views/dashboard/dashboard.dart';
import 'package:loterias/ui/views/monitoreo/monitoreo.dart';
import 'package:loterias/ui/views/premios/registrarpremios.dart';
import 'package:loterias/ui/views/principal/principal.dart';
import 'package:loterias/ui/views/reportes/historicoventas.dart';
import 'package:loterias/ui/views/reportes/ticketspendientespago.dart';
import 'package:loterias/ui/views/reportes/ventas.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return  MaterialPageRoute(
          builder: (_)=> SplashScreen()
        );
        case '/bluetooth' :
          return MaterialPageRoute(
            builder: (_)=> BluetoothScreen()
          ) ;
        case '/monitoreo' :
          return MaterialPageRoute(
            builder: (_)=> MonitoreoScreen()
          ) ;
        case '/registrarPremios' :
          return MaterialPageRoute(
            builder: (_)=> RegistrarPremiosScreen()
          ) ;
        case '/historicoVentas' :
          return MaterialPageRoute(
            builder: (_)=> HistoricoVentasScreen()
          ) ;
        case '/ventas' :
          return MaterialPageRoute(
            builder: (_)=> VentasScreen()
          ) ;
        case '/balanceBancas' :
          return MaterialPageRoute(
            builder: (_)=> BalanceBancaScreen()
          ) ;
        case '/pendientesPago' :
          return MaterialPageRoute(
            builder: (_)=> TicketsPendientesPagoScreen()
          ) ;
        case '/dashboard' :
          return MaterialPageRoute(
            builder: (_)=> DashboardScreen()
          ) ;
        case '/actualizar' :
          return MaterialPageRoute(
            builder: (_)=> ActualizarScreen(settings.arguments)
          ) ;
      // case '/' :
      //   return  MaterialPageRoute(
      //     builder: (_)=> SplashScreen()
      //   );
      // case '/' :
      //   return  MaterialPageRoute(
      //     builder: (_)=> PrincipalApp()
      //   );
      // case '/' :
      //   return MaterialPageRoute(
      //     builder: (_)=> PruebaApp()
      //   ) ;
      // case '/addArticulo' :
      //   return MaterialPageRoute(
      //     builder: (_)=> addArticulo()
      //   ) ;
      // case '/articulos' :
      //   return MaterialPageRoute(
      //     builder: (_)=> ArticulosApp()
      //   ) ;
      // case '/AddProyecto' :
      //   return MaterialPageRoute(
      //     builder: (_)=> AddProyecto()
      //   ) ;
      // case '/proyectos' :
      //   return MaterialPageRoute(
      //     builder: (_)=> ProyectosApp()
      //   ) ;
      // case '/addProduct' :
      //   return MaterialPageRoute(
      //     builder: (_)=> AddProduct()
      //   ) ;
      // case '/productDetails' :
      //   return MaterialPageRoute(
      //       builder: (_)=> ProductDetails()
      //   ) ;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}