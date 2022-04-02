import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loterias/ui/contacto/contactoscreen.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:loterias/ui/screensizetest.dart';
import 'package:loterias/ui/splashscreen.dart';
import 'package:loterias/ui/views/actualizar/actualizar.dart';
import 'package:loterias/ui/views/actualizar/versionesaddscreen.dart';
import 'package:loterias/ui/views/actualizar/versionesscreen.dart';
import 'package:loterias/ui/views/ajustes/ajustesscreen.dart';
import 'package:loterias/ui/views/balance/balancebanca.dart';
import 'package:loterias/ui/views/balance/balancebancos.dart';
import 'package:loterias/ui/views/bancas/bancasaddscreen.dart';
import 'package:loterias/ui/views/bancas/bancasscreen.dart';
import 'package:loterias/ui/views/bloqueos/bloqueosporjugadas.dart';
import 'package:loterias/ui/views/bloqueos/bloqueosporloteriasscreen.dart';
import 'package:loterias/ui/views/bluetoothdevice/bluetooth.dart';
import 'package:loterias/ui/views/cerrarloterias/cerrarloteriasaddscreen.dart';
import 'package:loterias/ui/views/cerrarloterias/cerrarloteriasscreen.dart';
import 'package:loterias/ui/views/dashboard/dashboard.dart';
import 'package:loterias/ui/views/entidades/entidadesaddscreen.dart';
import 'package:loterias/ui/views/entidades/entidadesscreen.dart';
import 'package:loterias/ui/views/grupos/gruposaddscreen.dart';
import 'package:loterias/ui/views/grupos/gruposscreen.dart';
import 'package:loterias/ui/views/horarios/horariosscreen.dart';
import 'package:loterias/ui/views/loterias/loteriasaddscreen.dart';
import 'package:loterias/ui/views/loterias/loteriasscreen.dart';
import 'package:loterias/ui/views/monedas/monedasscreen.dart';
import 'package:loterias/ui/views/monitoreo/monitoreo.dart';
import 'package:loterias/ui/views/notificacion/notificacion.dart';
import 'package:loterias/ui/views/notificacion/ver.dart';
import 'package:loterias/ui/views/pagos/pagosaddscreen.dart';
import 'package:loterias/ui/views/pagos/pagosscreen.dart';
import 'package:loterias/ui/views/pagos/pagosverscreen.dart';
import 'package:loterias/ui/views/premios/registrarpremios.dart';
import 'package:loterias/ui/views/principal/principal.dart';
import 'package:loterias/ui/views/principal/probarnullsafety.dart';
import 'package:loterias/ui/views/principal/probartiemporestante.dart';
import 'package:loterias/ui/views/principal/prueba2.dart';
import 'package:loterias/ui/views/prueba/pruebatimezone.dart';
import 'package:loterias/ui/views/reportes/historicoventas.dart';
import 'package:loterias/ui/views/reportes/reportegeneralscreen.dart';
import 'package:loterias/ui/views/reportes/reportejugadasscreen.dart';
import 'package:loterias/ui/views/reportes/ticketspendientespago.dart';
import 'package:loterias/ui/views/reportes/ventas.dart';
import 'package:loterias/ui/views/reportes/ventasporfechascreen.dart';
import 'package:loterias/ui/views/transaccion/add.dart';
import 'package:loterias/ui/views/transaccion/transacciones.dart';
import 'package:loterias/ui/views/usuarios/sesionesscreen.dart';
import 'package:loterias/ui/views/usuarios/usuariosaddscreen.dart';
import 'package:loterias/ui/views/usuarios/usuariosscreen.dart';

import 'views/monedas/monedasaddscreen.dart';


class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        // return  MaterialPageRoute(
        //   builder: (_)=> PruebaTimeZone()
        // );
        return  MaterialPageRoute(
          builder: (_)=> PrincipalApp(callThisScreenFromLogin: (settings.arguments != null) ? settings.arguments : false,)
        );
        // return  MaterialPageRoute(
        //   builder: (_)=> ProbarNullSafety()
        // );
        // return  MaterialPageRoute(
        //   builder: (_)=> ProbarTiempoRestante()
        // );
      case '/prueba2' :
        return  MaterialPageRoute(
          builder: (_)=> Prueba2()
        );
      case '/login' :
        return  MaterialPageRoute(
          builder: (_)=> LoginScreen()
        );
      case '/principal' :
        return  MaterialPageRoute(
          builder: (_)=> PrincipalApp(callThisScreenFromLogin: (settings.arguments != null) ? true : false,)
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
            builder: (_)=> VentasScreen(idBancaReporteGeneral: settings.arguments,)
          ) ;
        case '/general' :
          return MaterialPageRoute(
            builder: (_)=> ReporteGeneralScreen(showDrawer: settings.arguments,)
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
        case '/transacciones' :
          return MaterialPageRoute(
            builder: (_)=> TransaccionesScreen()
          ) ;
        case '/addTransacciones' :
          return MaterialPageRoute(
            builder: (_)=> AddTransaccionesScreen()
          ) ;
        case '/notificaciones' :
          return MaterialPageRoute(
            builder: (_)=> NotificacionScreen()
          ) ;
        case '/contacto' :
          return MaterialPageRoute(
            builder: (_)=> ContactoScreen()
          ) ;
        case '/verNotificaciones' :
          return MaterialPageRoute(
            builder: (_)=> VerNotificacionScreen(notificacion: settings.arguments,)
          ) ;
        case '/reporteJugadas' :
          return MaterialPageRoute(
            builder: (_)=> ReporteJugadasScreen()
          ) ;
        case '/ajustes' :
          return MaterialPageRoute(
            builder: (_)=> AjustesScreen()
          ) ;
        case '/grupos' :
          return MaterialPageRoute(
            builder: (_)=> GrupoScreen()
          ) ;
        case '/grupos/agregar' :
        return PageRouteBuilder(
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, anim1, anim2) =>
            FadeTransition(
              opacity: anim1,
              child: GruposAddScreen(
                data: settings.arguments, 
              ),
            ),
          );
          // return MaterialPageRoute(
          //   builder: (_)=> GruposAddScreen(data: settings.arguments,)
          // ) ;
        case '/usuarios' :
          return MaterialPageRoute(
            builder: (_)=> UsuarioScreen()
          ) ;
        case '/usuarios/agregar' :
        return PageRouteBuilder(
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, anim1, anim2) =>
            FadeTransition(
              opacity: anim1,
              child: UsuarioAddScreen(
                usuario: settings.arguments, 
              ),
            ),
          );
          // return MaterialPageRoute(
          //   builder: (_)=> UsuarioScreen()
          // ) ;
        case '/sesiones' :
          return MaterialPageRoute(
            builder: (_)=> SesionesScreen()
          ) ;
          case '/loterias' :
          return MaterialPageRoute(
            builder: (_)=> LoteriasScreen()
          ) ;
        case '/loterias/agregar' :
          return MaterialPageRoute(
            builder: (_)=> LoteriasAddScreen(loteria: settings.arguments,)
          ) ;
        case '/bancas' :
          return MaterialPageRoute(
            builder: (_)=> BancasScreen()
          ) ;
        case '/bancas/agregar' :
          return MaterialPageRoute(
            builder: (_)=> BancasAddScreen(idBanca: settings.arguments,)
          ) ;
        case '/screensizetest' :
          return MaterialPageRoute(
            builder: (_)=> ScreenSizeTest()
          ) ;
        case '/ventasPorFecha' :
          return MaterialPageRoute(
            builder: (_)=> VentasPorFechaScreen()
          ) ;
        case '/bloqueosporloteria' :
          return MaterialPageRoute(
            builder: (_)=> BloqueosPorLoteriasScreen()
          ) ;
        case '/bloqueosporjugadas' :
          return MaterialPageRoute(
            builder: (_)=> BloqueosPorJugadas()
          ) ;
        case '/horariosloterias' :
          return MaterialPageRoute(
            builder: (_)=> HorariosScreen()
          ) ;
        case '/monedas' :
          return MaterialPageRoute(
            builder: (_)=> MonedasScreen()
          ) ;
        case '/monedas/agregar' :
          return MaterialPageRoute(
            builder: (_)=> MonedasAddScreen(data: settings.arguments,)
          ) ;
        case '/entidades' :
          return MaterialPageRoute(
            builder: (_)=> EntidadesScreen()
          ) ;
        case '/entidades/agregar' :
          return MaterialPageRoute(
            builder: (_)=> EntidadesAddScreen(data: settings.arguments,)
          ) ;
        case '/balancebancos' :
          return MaterialPageRoute(
            builder: (_)=> BalanceBancosScreen()
          ) ;
        case '/pagos/servidores' :
          return MaterialPageRoute(
            builder: (_)=> ServidoresScreen()
          ) ;
        case '/pagos' :
          return MaterialPageRoute(
            builder: (_)=> PagosScreen(servidor: settings.arguments)
          ) ;
        case '/pagos/agregar' :
          return MaterialPageRoute(
            builder: (_)=> PagosAddScreen(servidor: (settings.arguments as List)[0], pago: (settings.arguments as List)[1])
          ) ;
        case '/pagos/ver' :
          return MaterialPageRoute(
            builder: (_)=> PagosVerScreen(id: settings.arguments)
          ) ;
        case '/cierresloterias' :
          return MaterialPageRoute(
            builder: (_)=> CerrarLoteriasScreen()
          ) ;
        case '/cierresloterias/agregar' :
          return MaterialPageRoute(
            builder: (_)=> CerrarLoteriasAddScreen()
          ) ;
        case '/versiones/agregar' :
          return MaterialPageRoute(
            builder: (_)=> VersionesAddScreen(version: settings.arguments,)
          ) ;
        case '/versiones' :
          return MaterialPageRoute(
            builder: (_)=> VersionesScreen()
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