

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/models/lotterycolor.dart';
import 'package:loterias/ui/widgets/myexpansiontile.dart';
import 'package:loterias/ui/widgets/mylisttile.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class MyDrawerType {
  const MyDrawerType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyDrawerType normal = MyDrawerType._(0);

  /// Extra-light
  static const MyDrawerType onlyIcons = MyDrawerType._(1);

  /// A list of all the font weights.
  static const List<MyDrawerType> values = <MyDrawerType>[
    normal, onlyIcons,
  ];
}

class MyDrawer extends StatefulWidget {
  final bool dashboard;
  final bool inicio;
  final bool transacciones;
  final bool monitoreo;
  final bool registrarPremios;
  final bool reporteJugadas;
  final bool ventasPorFecha;
  final bool historicoVentas;
  final bool ventas;
  final bool pendientesPago;
  final bool bloqueosPorLoteria;
  final bool bloqueosPorJugadas;
  final bool usuarios;
  final bool sesiones;

  final bool balancebancos;
  final bool balanceBancas;
  final bool horariosloterias;
  final bool monedas;
  final bool entidades;
  final bool bancas;
  final bool loterias;
  final bool grupos;
  final bool ajustes;
  
  final bool clientesBack;
  final bool isExpanded;
  final bool isForSmallScreen;
  final MyDrawerType type;
  final Widget Function(BuildContext context, AnimationController animationController, Widget widget) animationBuilder;
  final Function onMouseEnter;
  final Function onMouseExit;
  final Lotterycolor lotteryColor;
  // final ValueChanged onChanged;
  MyDrawer({Key key, @required this.isExpanded, this.inicio = false, this.dashboard = false, this.transacciones = false, this.monitoreo = false, this.registrarPremios = false, this.reporteJugadas = false, this.ventasPorFecha = false, this.historicoVentas = false, this.ventas =  false, this.loterias = false, this.pendientesPago = false, this.bancas = false, this.monedas = false, this.entidades = false, this.bloqueosPorLoteria = false, this.bloqueosPorJugadas = false, this.usuarios = false, this.sesiones = false, this.balancebancos = false, this.clientesBack = false, this.horariosloterias, this.balanceBancas, this.isForSmallScreen = false, this.type = MyDrawerType.normal, this.animationBuilder, this.onMouseEnter, this.onMouseExit, this.grupos, this.ajustes, this.lotteryColor}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  bool _cargandoAbrirCaja = false;
  bool _visibleByClick = true;
  bool _visibleOnHover = false;
  Timer _timer;
  Stopwatch calculateMouseDuration;
  StreamController<MyListTileType> _streamControllerListTile;

  AnimationController _controller;
  Animation<double> _animation;

  AnimationController _controllerTile;
  Animation<double> _animationTile;

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


  _gotTo(String route){
    Navigator.pushNamed(context, route);
  }

  
  _reduceWebDrawer(){

  }

  _expandOrCloseDrawer(bool open){
    if(!mounted)
      return;

    if(open){
      if(_controller.value == 0 || _controller.status == AnimationStatus.reverse){
        _controller.forward();
      }
    }
    else{
      if(_controller.value == 1 || _controller.status == AnimationStatus.forward){
        _controller.reverse();
      }
    }
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
    
  //   super.didChangeDependencies();
  // }

  _getPermision() async {
    _dashboardNotifier.value = await Db.existePermiso("Ver Dashboard");
    _transaccionesNotifier.value = await Db.existePermiso("Manejar transacciones");
    _monitoreoNotifier.value = await Db.existePermiso("Monitorear ticket");
    _registrarNotifier.value = await Db.existePermiso("Manejar resultados");

    _reporteJugadasNotifier .value = await Db.existePermiso("Ver reporte jugadas");
    _reporteHistoricoNotifier.value = await Db.existePermiso("Ver historico ventas");
    _reporteVentasPorFechaNotifier.value = await Db.existePermiso("Ver ventas por fecha");
    _reporteVentasNotifier.value = await Db.existePermiso("Ver ventas");
    _reportesNotifier.value = _reporteJugadasNotifier.value || _reporteHistoricoNotifier.value || _reporteVentasPorFechaNotifier.value || _reporteVentasNotifier.value;
    bool permisoAdministrador  = await (await DB.create()).getValue("administrador");
    bool permisoProgramador  = (await (await DB.create()).getValue("tipoUsuario")) == "Programador";

    if(permisoProgramador != null && permisoAdministrador != null)
      _pendientesPagoNotifier.value = permisoAdministrador || permisoProgramador;

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

  @override
  void initState() {
    // TODO: implement initState
  //   _controller = AnimationController(
  //   duration: const Duration(milliseconds: 500),
  //   vsync: this,
  // );
  // // _animation = CurvedAnimation(
  // //   parent: _controller,
  // //   curve: Curves.fastOutSlowIn,
  // // );
  // _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.fastOutSlowIn,
  // );
  _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updatePermissions());
_streamControllerListTile = BehaviorSubject();

  _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
  _animation = Tween<double>(begin: 65, end: 260).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

  _controllerTile = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  _animationTile = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _getPermision();

    if(widget.isExpanded)
      _expandOrCloseDrawer(true);

    
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyDrawer oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.isExpanded != widget.isExpanded)
      _expandOrCloseDrawer(true);
      
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  

  _visible(double width){
    bool visible = true;
    if(width > ScreenSize.md && _visibleByClick)
      visible = true;
    else if(width < ScreenSize.md && _visibleByClick)
      visible = true;
    else 
      visible = false;
    
    return visible;
  }

  Widget _myListTile({String title, IconData icon, bool selected, Function onTap, bool visible = false}){
    return Visibility(
      visible: visible,
      child: MyListTile(
            // type: widget.animationBuilder == null ? widget.type == MyDrawerType.normal ? widget.isExpanded ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon : MyListTileType.onlyIcon : MyListTileType.normal, 
            controller: _controller,
            type:  _controller.status == AnimationStatus.reverse ? MyListTileType.onlyIcon : MyListTileType.normal, 
            title: title, 
            icon: icon, 
            selected: selected, 
            lotteryColor: widget.lotteryColor,
            onTap: (){onTap();}, 
          ),
    );
  }

  Widget _myExpansionTile({String title, IconData icon, List<Widget> listaMylisttile, bool selected, bool initialExpanded, bool visible = true}){
    return Visibility(
      visible: visible,
      child: MyExpansionTile(
        title: title, 
        // type: widget.animationBuilder == null ? widget.type == MyDrawerType.normal ? widget.isExpanded ? MyExpansionTileType.normal : _showOnHoverNotify.value ? MyExpansionTileType.normal : MyExpansionTileType.onlyIcon : MyExpansionTileType.onlyIcon : MyExpansionTileType.normal,
        // type: _animation.value == 65 ? MyExpansionTileType.onlyIcon : MyExpansionTileType.normal,
        controller: _controller,
        selected: selected,
        icon: icon, 
        initialExpanded: initialExpanded,
        listaMylisttile: listaMylisttile
      ),
    );
  }

  var _showOnHoverNotify = ValueNotifier<bool>(false);

  Widget _screen({width}){
    // if(!visible)
    // return SizedBox();

    return AnimatedLogo(
      isExpanded: widget.isExpanded,
      animation: _animation,
      child: Container(
                            color: widget.lotteryColor != null ? widget.lotteryColor.color.withOpacity(0.4) : Colors.white,
                            // width: widget.isExpanded == false && value == false ? 65 : 260,
                            width: width,
                            height: MediaQuery.of(context).size.height,
                            child: ValueListenableBuilder(
                              valueListenable: _showOnHoverNotify,
                              builder: (context, value, __) {
                                return Scrollbar(
                                  isAlwaysShown: value,
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      SizedBox(height: 5,),
                                      Visibility(
                                        visible: ModalRoute.of(context)?.canPop == true,
                                        child: 
                                        AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, child) {
                                            return FractionalTranslation(
                                              
                                              translation: Offset(0.0, 0.0),
                                              child: 
                                              
                                              _controller.value <= 0.3 || _controller.value == null
                                              ? 
                                              GestureDetector(child: Icon(Icons.arrow_back), onTap: (){Navigator.pop(context);},)
                                              : 
                                              Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300, width: 1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(children: [
                                                Icon(Icons.arrow_back, size: 18,),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text("Atras", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade800),),
                                                )
                                              ],),
                                            ),
                                          ),
                                        ),
                                            );
                                          },
                                      )
                                        
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _dashboardNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Dashboard", icon: Icons.dashboard, selected: widget.dashboard, visible: value, onTap: (){_gotTo("/dashboard");}, );
                                        }
                                      ),
                                      _myListTile(title: "Vender", icon: Icons.point_of_sale, selected: widget.inicio, visible: true, onTap: (){
                                              Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                      }, ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _transaccionesNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Transacciones", icon: Icons.transfer_within_a_station, selected: widget.transacciones, visible: value, onTap: (){_gotTo("/transacciones");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _monitoreoNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Monitoreo", icon: Icons.donut_large, selected: widget.monitoreo, visible: value, onTap: (){_gotTo("/monitoreo");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _registrarNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Registrar premios", icon: Icons.format_list_numbered, selected: widget.registrarPremios, visible: value, onTap: (){_gotTo("/registrarPremios");},);
                                        }
                                      ),
                                       ValueListenableBuilder<bool>(
                                        valueListenable: _reportesNotifier,
                                        builder: (context, reportesValue, snapshot) {
                                           return _myExpansionTile(
                                             visible: reportesValue,
                                            title: "Reportes", 
                                            selected: widget.reporteJugadas || widget.historicoVentas || widget.ventasPorFecha || widget.ventas,
                                            icon: Icons.analytics, 
                                            initialExpanded: widget.reporteJugadas || widget.historicoVentas || widget.ventasPorFecha || widget.ventas,
                                            listaMylisttile: [
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _reporteJugadasNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Reporte jugadas", icon: null, visible: value, onTap: (){_gotTo("/reporteJugadas");}, selected: widget.reporteJugadas,);
                                                }
                                              ), 
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _reporteHistoricoNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Historico ventas", icon: null, visible: value, onTap: (){_gotTo("/historicoVentas");}, selected: widget.historicoVentas,);
                                                }
                                              ), 
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _reporteVentasPorFechaNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Ventas por fecha", icon: null, visible: value, onTap: (){_gotTo("/ventasPorFecha");}, selected: widget.ventasPorFecha,);
                                                }
                                              ), 
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _reporteVentasNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Ventas", icon: null, visible: value, onTap: (){_gotTo("/ventas");}, selected: widget.ventas,);
                                                }
                                              ), 
                                            ]
                                                                             );
                                         }
                                       ),
                                       
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _pendientesPagoNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Pendientes pago", icon: Icons.attach_money, selected: widget.pendientesPago, visible: value, onTap: (){_gotTo("/pendientesPago");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _manejarReglasNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myExpansionTile(
                                            title: "Bloqueos", 
                                            visible: value,
                                            selected: widget.bloqueosPorLoteria || widget.bloqueosPorJugadas,
                                            icon: Icons.block, 
                                            initialExpanded: widget.bloqueosPorLoteria || widget.bloqueosPorJugadas,
                                            listaMylisttile: [
                                              _myListTile(title: "Bloqueo loterias", icon: null, visible: true, onTap: (){_gotTo("/bloqueosporloteria");}, selected: widget.bloqueosPorLoteria,),
                                              _myListTile(title: "Bloqueo jugadas", icon: null, visible: true, onTap: (){_gotTo("/bloqueosporjugadas");}, selected: widget.bloqueosPorJugadas,)
                                            ]
                                          );
                                        }
                                      ),
                                       ValueListenableBuilder<bool>(
                                        valueListenable: _usuariosNotifier,
                                        builder: (context, usuarioValue, snapshot) {
                                           return _myExpansionTile(
                                            title: "Usuarios", 
                                            visible: usuarioValue,
                                            selected: widget.usuarios || widget.sesiones,
                                            icon: Icons.person_outline, 
                                            initialExpanded: widget.usuarios || widget.sesiones,
                                            listaMylisttile: [
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _manejarUsuariosNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Usuarios", icon: null, visible: value, onTap: (){_gotTo("/usuarios");}, selected: widget.usuarios,);
                                                }
                                              ), 
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _sesionesNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Sesiones", icon: null, visible: value, onTap: (){_gotTo("/sesiones");}, selected: widget.sesiones,);
                                                }
                                              ), 
                                            ]
                                                                             );
                                         }
                                       ),
                                       ValueListenableBuilder<bool>(
                                        valueListenable: _balancesNotifier,
                                        builder: (context, balanceValue, snapshot) {
                                           return _myExpansionTile(
                                            title: "Balances", 
                                            visible: balanceValue,
                                            selected: widget.balancebancos || widget.balanceBancas,
                                            icon: Icons.six__ft_apart,
                                            initialExpanded: widget.balancebancos || widget.balanceBancas,
                                            listaMylisttile: [
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _balanceBancosNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Balance bancos", icon: null, visible: value, onTap: (){_gotTo("/balancebancos");}, selected: widget.balancebancos,);
                                                }
                                              ), 
                                              ValueListenableBuilder<bool>(
                                                valueListenable: _balanceBancasNotifier,
                                                builder: (context, value, snapshot) {
                                                  return _myListTile(title: "Balance bancas", icon: null, visible: value, onTap: (){_gotTo("/balanceBancas");}, selected: widget.balanceBancas,);
                                                }
                                              ), 
                                            ]
                                                                             );
                                         }
                                       ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _horariosNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Horarios loterias", icon: Icons.timer, selected: widget.horariosloterias, visible: value, onTap: (){_gotTo("/horariosloterias");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _monedasNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Monedas", icon: Icons.attach_money_rounded, selected: widget.monedas, visible: value, onTap: (){_gotTo("/monedas");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _entidadesNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Entidades", icon: Icons.apartment_outlined, selected: widget.entidades, visible: value, onTap: (){_gotTo("/entidades");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _bancasNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Bancas", icon: Icons.account_balance, selected: widget.bancas, visible: value, onTap: (){_gotTo("/bancas");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _loteriasNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Loterias", icon: Icons.group_work_outlined, selected: widget.loterias, visible: value, onTap: (){_gotTo("/loterias");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _gruposNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Grupos", icon: Icons.group_work, selected: widget.grupos, visible: value, onTap: (){_gotTo("/grupos");},);
                                        }
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _ajustesNotifier,
                                        builder: (context, value, snapshot) {
                                          return _myListTile(title: "Ajustes", icon: Icons.settings, selected: widget.ajustes, visible: value, onTap: (){_gotTo("/ajustes");},);
                                        }
                                      ),
                                    ],),
                                  ),
                                );
                              }
                            ),
                          ),
    );
                      
  }

  _onMouseEnter(PointerEnterEvent value){
    _showOnHoverNotify.value = true;
    if(widget.isExpanded)
      return;

    calculateMouseDuration = Stopwatch()..start();
    Future.delayed(Duration(milliseconds: 400), (){
    print("MyWebDrawer MouseRegion time: ${calculateMouseDuration.elapsed.inMilliseconds}");
      // _showOnHoverNotify.value = calculateMouseDuration.elapsed.inMilliseconds >= 400;
      // _controller.forward();
      //Si el mouse dura 400 milisegundos o mas entonces retornamos el evento onMouseEnter
      if(calculateMouseDuration.elapsed.inMilliseconds >= 400 && widget.onMouseEnter != null){
        // widget.onMouseEnter();
        if(_controller.value == 0){
          if(mounted){
            _expandOrCloseDrawer(true);
          }
        }
      }
    });
    
  }

  _onMouseExit(PointerExitEvent value){
    _showOnHoverNotify.value = false;
    if(widget.isExpanded)
      return;
    calculateMouseDuration.stop();
    print("MyDrawer onExit: ${_controller.value} : ${widget.animationBuilder}");
    if(widget.animationBuilder != null)
      widget.onMouseExit();
    // if(widget.animationBuilder != null){
    //   _controller.reverse();
    // }
    // _showOnHoverNotify.value = false;
    // if(_controller.value == 1)
    //   _controller.reverse();

    _expandOrCloseDrawer(false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxconstraint) {
        if(widget.isForSmallScreen)
          return _screen(width: MediaQuery.of(context).size.width / 1.3);

        print("MyWebdrawer issmall: ${boxconstraint.maxWidth < ScreenSize.md} c: ${boxconstraint.maxWidth} s: ${ScreenSize.md}");
        if(widget.isForSmallScreen == false && MediaQuery.of(context).size.width < ScreenSize.md)
          return SizedBox();
        
        return Visibility(
          visible: widget.isExpanded == false ? boxconstraint.maxWidth < ScreenSize.md ? false : true : true,
          child: MouseRegion(
            onEnter: _onMouseEnter,
            onExit: _onMouseExit,
            child: 
                // widget.animationBuilder == null
                // ?
                //  _screen(width: (widget.isExpanded == false && widget.type == MyDrawerType.normal) || widget.type == MyDrawerType.onlyIcons ? 65.0 : 260.0)
                //  :
                // widget.animationBuilder(
                //   context,
                //   _controller,
                //   SizeTransition(
                //     axis: Axis.horizontal,
                //     sizeFactor: _animation,
                //     child: MouseRegion(
                //       onEnter: (value){
                //         print("MyWebDrawer MouseRegion SizeTransition: ${calculateMouseDuration.elapsed.inMilliseconds}");

                //       },
                //       onExit: (value){
                //         calculateMouseDuration.stop();
                //         print("MyWebDrawer onExit SizeTransition: ${_controller.value} : ${widget.animationBuilder}");
                //         if(widget.animationBuilder != null)
                //           widget.onMouseExit();
                //         // if(widget.animationBuilder != null){
                //         //   _controller.reverse();
                //         // }
                //         // _showOnHoverNotify.value = false;
                //       },
                //       child: _screen(width: 260.0)
                //     )
                //   )
                // )

              widget.animationBuilder == null
                ?
                 _screen(width: _animation.value)
                 :
                widget.animationBuilder(
                  context,
                  _controller,
                  SizeTransition(
                    sizeFactor: _animation,
                    child: _screen(width: 260.0)
                  )
                )
            // ValueListenableBuilder(
            //   valueListenable: _showOnHoverNotify,
            //   builder: (context, value, __) {
            //     return
            //     widget.animationBuilder == null
            //     ?
            //      _screen(width: _animation.value)
            //      :
            //     widget.animationBuilder(
            //       context,
            //       _controller,
            //       SizeTransition(
            //         sizeFactor: _animation,
            //         child: _screen(width: 260.0)
            //       )
            //     );
            //   }
            // ),
          ),
        );
      }
    );
      
  }
}


class AnimatedLogo extends AnimatedWidget {
  final Widget child;
  final bool isExpanded;
  const AnimatedLogo({Key key, @required Animation<double> animation, @required this.child, @required this.isExpanded})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: animation.value,
      margin:  animation.value < 200 || isExpanded ? null : const EdgeInsets.only(right: 6.0),
      decoration: BoxDecoration(
        // borderRadius: animation.value != 265 ? null : BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: animation.value < 200 || isExpanded
        ?
        null
        :
        [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 0.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: child
    );
  }
}