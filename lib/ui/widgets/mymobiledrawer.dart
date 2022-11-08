import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/classes/databasesingleton.dart';
import '../../core/classes/mydate.dart';
import '../../core/classes/principal.dart';
import '../../core/classes/singleton.dart';
import '../../core/models/pago.dart';
import '../../main.dart';
import '../views/principal/principal.dart';

class MyMobileDrawer extends StatefulWidget {
  final scaffoldKey;
  final bool showVender;
  final Function onTapDuplicar;
  final Function onTapPagar;
  final Function onTapCerrarSesion;
  final Function onTapCambiarServidor;
  const MyMobileDrawer({ Key key, this.scaffoldKey, this.onTapDuplicar, this.onTapPagar, this.onTapCerrarSesion, this.onTapCambiarServidor, this.showVender = false}) : super(key: key);

  @override
  State<MyMobileDrawer> createState() => _MyMobileDrawerState();
}

class _MyMobileDrawerState extends State<MyMobileDrawer> {
  Future _futureBanca;
  Future _futureUsuario;
  Future _futureFactura;
  bool _tienePermisoProgramador;
  bool _tienePermisoAdministrador;

  Timer _timer;
  var _programadorNotifier = ValueNotifier<bool>(false);
  var _programadorOAdministradorNotifier = ValueNotifier<bool>(false);
  var _generalNotifier = ValueNotifier<bool>(false);
  var _dashboardNotifier = ValueNotifier<bool>(false);
  var _transaccionesNotifier = ValueNotifier<bool>(false);
  var _monitoreoNotifier = ValueNotifier<bool>(false);
  var _registrarNotifier = ValueNotifier<bool>(false);
  var _reportesNotifier = ValueNotifier<bool>(false);
  var _reporteJugadasNotifier = ValueNotifier<bool>(false);
  var _reporteHistoricoNotifier = ValueNotifier<bool>(false);
  var _reporteVentasPorFechaNotifier = ValueNotifier<bool>(false);
  var _reporteVentasNotifier = ValueNotifier<bool>(false);
  var _pendientesPagoNotifier = ValueNotifier<bool>(false);
  var _manejarReglasNotifier = ValueNotifier<bool>(false);
  var _usuariosNotifier = ValueNotifier<bool>(false);
  var _manejarUsuariosNotifier = ValueNotifier<bool>(false);
  var _sesionesNotifier = ValueNotifier<bool>(false);
  var _balancesNotifier = ValueNotifier<bool>(false);
  var _balanceBancosNotifier = ValueNotifier<bool>(false);
  var _balanceBancasNotifier = ValueNotifier<bool>(false);
  var _horariosNotifier = ValueNotifier<bool>(false);
  var _monedasNotifier = ValueNotifier<bool>(false);
  var _entidadesNotifier = ValueNotifier<bool>(false);
  var _bancasNotifier = ValueNotifier<bool>(false);
  var _loteriasNotifier = ValueNotifier<bool>(false);
  var _gruposNotifier = ValueNotifier<bool>(false);
  var _ajustesNotifier = ValueNotifier<bool>(false);
  var _versionesNotifier = ValueNotifier<bool>(false);
  var _marcarTicketComoPagadoNotifier = ValueNotifier<bool>(false);
  var _verRecargasNotifier = ValueNotifier<bool>(false);


  _getPermision() async {
    _generalNotifier.value = await Db.existePermiso("Ver reporte general");
    _dashboardNotifier.value = await Db.existePermiso("Ver Dashboard");
    _transaccionesNotifier.value = await Db.existePermiso("Manejar transacciones");
    _monitoreoNotifier.value = await Db.existePermiso("Monitorear ticket");
    _registrarNotifier.value = await Db.existePermiso("Ver resultados");

    _reporteJugadasNotifier .value = await Db.existePermiso("Ver reporte jugadas");
    _reporteHistoricoNotifier.value = await Db.existePermiso("Ver historico ventas");
    _reporteVentasPorFechaNotifier.value = await Db.existePermiso("Ver ventas por fecha");
    _reporteVentasNotifier.value = await Db.existePermiso("Ver ventas");
    _reportesNotifier.value = _reporteJugadasNotifier.value || _reporteHistoricoNotifier.value || _reporteVentasPorFechaNotifier.value || _reporteVentasNotifier.value;
    bool permisoAdministrador  = await (await DB.create()).getValue("administrador");
    bool permisoProgramador  = (await (await DB.create()).getValue("tipoUsuario")) == "Programador";

    if(permisoProgramador != null && permisoAdministrador != null)
      _pendientesPagoNotifier.value = permisoAdministrador || permisoProgramador;

    _tienePermisoProgramador = permisoProgramador;
    _tienePermisoAdministrador = permisoAdministrador;
    _programadorNotifier.value = permisoProgramador;
    _programadorOAdministradorNotifier.value = (permisoProgramador || permisoAdministrador);
    _manejarReglasNotifier.value = await Db.existePermiso("Manejar reglas");
    _manejarUsuariosNotifier.value = await Db.existePermiso("Manejar usuarios");
    _sesionesNotifier.value = await Db.existePermiso("Ver inicios de sesion");
    _usuariosNotifier.value = _manejarUsuariosNotifier.value || _sesionesNotifier.value;
    _balanceBancasNotifier.value = await Db.existePermiso("Ver lista de balances de bancas");
    _balanceBancosNotifier.value = await Db.existePermiso("Ver lista de balances de bancos");
    _balancesNotifier.value = _balanceBancasNotifier.value || _balanceBancosNotifier.value;

    _horariosNotifier.value = await Db.existePermiso("Manejar horarios de loterias");
    _monedasNotifier.value = await Db.existePermiso("Manejar monedas");
    _entidadesNotifier.value = await Db.existePermiso("Manejar entidades contables");
    _bancasNotifier.value = await Db.existePermiso("Manejar bancas");
    _loteriasNotifier.value = await Db.existePermiso("Manejar loterias");
    _gruposNotifier.value = await Db.existePermiso("Manejar grupos");
    _ajustesNotifier.value  = await Db.existePermiso("Ver ajustes");
    _versionesNotifier.value  = permisoProgramador;
    _marcarTicketComoPagadoNotifier.value  = await Db.existePermiso("Marcar ticket como pagado");
    _verRecargasNotifier.value  = await Db.existePermiso("Ver recargas");

    if(PERMISSIONS_CHANGED){
      PERMISSIONS_CHANGED = false;
    }

    // bool permisoMarcarTicketComoPagado = await Db.existePermiso("Marcar ticket como pagado");
    // bool permisoAccesoAlSistema = await Db.existePermiso("Acceso al sistema");
    // bool permisoAdministrador  = await (await DB.create()).getValue("administrador");
    // bool permisoProgramador  = (await (await DB.create()).getValue("tipoUsuario")) == "Programador";
    // bool tienePermisoVerBalanceBancas = await Db.existePermiso("Ver lista de balances de bancas");
    // bool tienePermisoManejarManejarReglas = await Db.existePermiso("Manejar reglas");
    // bool tienePermisoJugarSinDisponibilidad = await Db.existePermiso("Jugar sin disponibilidad");
  }

  _updatePermissions() async {
    if(PERMISSIONS_CHANGED){
      await _getPermision();
    }
  }

  _initPago() async {
    var c = await DB.create();
    _futureFactura = c.getPagoPendiente();
  }

  @override
  void initState() {
    // TODO: implement initState
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updatePermissions());
    _futureBanca = Db.getBanca();
    _futureUsuario = Db.getUsuario();
    _initPago();
    _getPermision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: 
      ListView(
        children: <Widget>[
          ListTile(
            title: FutureBuilder<Map<String, dynamic>>(
              future: _futureBanca,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text('${snapshot.data["descripcion"]}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300));
                }

                return Text('Banca...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300));
              }
            ),
            subtitle: FutureBuilder<Map<String, dynamic>>(
              future: _futureUsuario,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text('${snapshot.data["servidor"]}');
                }

                return Text('Servidor...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300));
              }
            ),
            leading: Container(
              width: 30,
              height: 30,
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: 0.75,
                    heightFactor: 0.75,
                    child: Image(image: AssetImage('assets/images/loterias_dominicanas_sin_letras.png'), ),
                  ),
                ),
              ),
            ),
            onTap: widget.onTapCambiarServidor,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _programadorOAdministradorNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: FutureBuilder<Pago>(
                  future: _futureFactura,
                  builder: (context, snapshot) {
                    return ListTile(
                      title: Text('Facturas'),
                      leading: Icon(Icons.payment),
                      dense: true,
                      onTap: () async {
                        if(_tienePermisoProgramador)
                          Navigator.of(context).pushNamed("/pagos/servidores");
                        else if(_tienePermisoAdministrador)
                          // Navigator.of(context).pushNamed("/pagos", arguments: Servidor(descripcion: await Db.servidor()));
                          Navigator.of(context).pushNamed("/pagos/ver", arguments: snapshot.data != null ? snapshot.data.id : null);
                                    
                        widget.scaffoldKey.currentState.openEndDrawer();
                      },
                      subtitle: snapshot.data == null ? null : Row(
                        children: [
                          
                          Text("${snapshot.data.fechaDiasGracia != null ? 'Pagar antes del ' + MyDate.dateRangeToNameOrString(DateTimeRange(start: snapshot.data.fechaDiasGracia, end: snapshot.data.fechaDiasGracia)) : 'Tiene factura pendiente'}", style: TextStyle(color: Colors.pink)),
                        ],
                      )
                      // FutureBuilder<int>(
                      //   future: _futureFactura,
                      //   builder: (context, snapshot) {
                      //     return Visibility(
                      //       visible: snapshot.data != null, 
                      //       child: Text("Tiene factura pendiente", style: TextStyle(color: Colors.pink)
                      //     ));
                      //   }
                      // )
                    );
                  }
                ),
              );
            }
          ),
          
          ValueListenableBuilder<bool>(
            valueListenable: _dashboardNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Dashboard'),
                  leading: Icon(Icons.dashboard),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/dashboard");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _generalNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: widget.showVender ? false : value,
                child: ListTile(
                  title: Text('General'),
                  leading: Icon(Icons.widgets_outlined),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/general", arguments: false);
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          Visibility(
            visible: widget.showVender,
            child: ListTile(
              title: Text('Vender'),
              leading: Icon(Icons.point_of_sale),
              dense: true,
              onTap: (){
                navigatorKey.currentState.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => PrincipalApp(callThisScreenFromLogin: true,)),
                  (route) => false
                );
                widget.scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _transaccionesNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Transacciones'),
                  leading: Icon(Icons.transfer_within_a_station),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/transacciones");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _monitoreoNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Monitoreo'),
                  leading: Icon(Icons.donut_large),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/monitoreo");
                  widget.scaffoldKey.currentState.openEndDrawer();},
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _registrarNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Registrar premios'),
                  leading: Icon(Icons.format_list_numbered),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/registrarPremios");
                  widget.scaffoldKey.currentState.openEndDrawer();},
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _verRecargasNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Recargas'),
                  leading: Icon(Icons.send_to_mobile),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/recargas");
                  widget.scaffoldKey.currentState.openEndDrawer();},
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _reportesNotifier,
            builder: (context, reportesValue, __) {
              return Visibility(
                visible: reportesValue,
                child: ExpansionTile(
                  leading: Icon(Icons.analytics),
                  title: Text("Reportes"),
                  children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _reporteJugadasNotifier,
                        builder: (context, value, __) {
                          return Visibility(
                          visible: value,
                          child: ListTile(
                            title: Text('Reporte jugadas'),
                            leading: Icon(Icons.receipt_long),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/reporteJugadas");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        );
                        }
                      ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _reporteHistoricoNotifier,
                      builder: (context, value, __) {
                        return Visibility(
                          visible: value,
                          child: ListTile(
                            title: Text('Historico ventas'),
                            leading: Icon(Icons.timeline),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/historicoVentas");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        );
                      }
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _reporteVentasPorFechaNotifier,
                      builder: (context, value, __) {
                        return Visibility(
                          visible: value,
                          child: ListTile(
                            title: Text('Ventas por fecha'),
                            leading: Icon(Icons.event_available),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/ventasPorFecha");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        );
                      }
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _reporteVentasNotifier,
                      builder: (context, value, __) {
                        return Visibility(
                          visible: value,
                          child: ListTile(
                            title: Text('Ventas'),
                            leading: Icon(Icons.insert_chart),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/ventas");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        );
                      }
                    ),
                  ],
                ),
              );
            }
          ),
          
          
          ValueListenableBuilder<bool>(
            valueListenable: _programadorOAdministradorNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Pendientes de pago'),
                  leading: Icon(Icons.attach_money),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/pendientesPago");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ListTile(
            title: Text('Duplicar'),
            leading: Icon(Icons.scatter_plot),
            dense: true,
            onTap: widget.onTapDuplicar,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _marcarTicketComoPagadoNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text("Pagar"),
                  leading: Icon(Icons.payment),
                  dense: true,
                  onTap: widget.onTapPagar,
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _manejarReglasNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ExpansionTile(
                  leading: Icon(Icons.block),
                  title: Text("Bloqueos"),
                  children: [
                      ListTile(
                      title: Text('Por loterias'),
                      leading: Icon(Icons.group_work_outlined),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/bloqueosporloteria");
                        widget.scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                      ListTile(
                      title: Text('Por jugadas'),
                      leading: Icon(Icons.pin),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/bloqueosporjugadas");
                        widget.scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                  ],
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _usuariosNotifier,
            builder: (context, usuarioValue, __) {
              return Visibility(
                visible: usuarioValue,
                child: ExpansionTile(
                  leading: Icon(Icons.person_outline),
                  title: Text("Usuarios"),
                  children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _manejarUsuariosNotifier,
                        builder: (context, value, __) {
                          return Visibility(
                            visible: value,
                            child: ListTile(
                            title: Text('Usuarios'),
                            leading: Icon(Icons.person),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/usuarios");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                                                    ),
                          );
                        }
                      ),
                      ValueListenableBuilder<Object>(
                        valueListenable: _sesionesNotifier,
                        builder: (context, value, __) {
                          return Visibility(
                            visible: value,
                            child: ListTile(
                            title: Text('Sesiones'),
                            leading: Icon(Icons.sync_alt),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/sesiones");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                                                    ),
                          );
                        }
                      ),
                  ],
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _balancesNotifier,
            builder: (context, balanceValue, __) {
              return Visibility(
                visible: balanceValue,
                child: ExpansionTile(
                  leading: Icon(Icons.six_ft_apart),
                  title: Text("Balances"),
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _balanceBancosNotifier,
                      builder: (context, value, __) {
                        return Visibility(
                          visible: value,
                          child: ListTile(
                            title: Text('Balance bancos'),
                            leading: Icon(Icons.account_balance_wallet_outlined),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/balancebancos");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        );
                      }
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _balanceBancasNotifier,
                      builder: (context, value, __) {
                        return Visibility(
                          visible: value,
                          child: ListTile(
                            title: Text('Balance bancas'),
                            leading: Icon(Icons.account_balance_wallet),
                            dense: true,
                            onTap: (){
                              Navigator.of(context).pushNamed("/balanceBancas");
                              widget.scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        );
                      }
                    ),
                  ],
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _programadorNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Cierres loterias'),
                  leading: Icon(Icons.timer_off_rounded),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/cierresloterias");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _horariosNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Horarios loterias'),
                  leading: Icon(Icons.timer),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/horariosloterias");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _monedasNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Monedas'),
                  leading: Icon(Icons.attach_money_rounded),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/monedas");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _entidadesNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Entidades'),
                  leading: Icon(Icons.apartment_outlined),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/entidades");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          
          
          ValueListenableBuilder<Object>(
            valueListenable: _bancasNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Bancas'),
                  leading: Icon(Icons.account_balance),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/bancas");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _loteriasNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Loterias'),
                  leading: Icon(Icons.group_work_outlined),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/loterias");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _gruposNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Grupos'),
                  leading: Icon(Icons.group_work),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/grupos");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          
          ValueListenableBuilder<bool>(
            valueListenable: _ajustesNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Ajustes'),
                  leading: Icon(Icons.settings),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/ajustes");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ListTile(
            title: Text('Version'),
            dense: true,
            leading: Icon(Icons.assignment),
            onTap: () async {
            Principal.showVersion(context: context);
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _programadorNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: value,
                child: ListTile(
                  title: Text('Versiones'),
                  leading: Icon(Icons.format_list_numbered_outlined),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/versiones");
                    widget.scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              );
            }
          ),
          ListTile(
            title: Text('Cerrar sesion'),
            dense: true,
            leading: Icon(Icons.clear),
            onTap: widget.onTapCerrarSesion,
          )
        ],
      ),

    );
  }
}