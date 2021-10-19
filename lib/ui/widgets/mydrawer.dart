

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/ui/widgets/myexpansiontile.dart';
import 'package:loterias/ui/widgets/mylisttile.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:rxdart/rxdart.dart';

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
  // final ValueChanged onChanged;
  MyDrawer({Key key, @required this.isExpanded, this.inicio = false, this.dashboard = false, this.transacciones = false, this.monitoreo = false, this.registrarPremios = false, this.reporteJugadas = false, this.ventasPorFecha = false, this.historicoVentas = false, this.ventas =  false, this.loterias = false, this.pendientesPago = false, this.bancas = false, this.monedas = false, this.entidades = false, this.bloqueosPorLoteria = false, this.bloqueosPorJugadas = false, this.usuarios = false, this.sesiones = false, this.balancebancos = false, this.clientesBack = false, this.horariosloterias, this.balanceBancas, this.isForSmallScreen = false, this.type = MyDrawerType.normal, this.animationBuilder, this.onMouseEnter, this.onMouseExit, this.grupos, this.ajustes}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  bool _cargandoAbrirCaja = false;
  bool _visibleByClick = true;
  bool _visibleOnHover = false;
  Stopwatch calculateMouseDuration;
  StreamController<MyListTileType> _streamControllerListTile;

  AnimationController _controller;
  Animation<double> _animation;

  AnimationController _controllerTile;
  Animation<double> _animationTile;

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

  Widget _myListTile({String title, IconData icon, bool selected, Function onTap, bool visible = true}){
    return Visibility(
      visible: visible,
      child: MyListTile(
            // type: widget.animationBuilder == null ? widget.type == MyDrawerType.normal ? widget.isExpanded ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon : MyListTileType.onlyIcon : MyListTileType.normal, 
            controller: _controller,
            type:  _controller.status == AnimationStatus.reverse ? MyListTileType.onlyIcon : MyListTileType.normal, 
            title: title, 
            icon: icon, 
            selected: selected, 
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
                            color: Colors.white,
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
                                      _myListTile(title: "Dashboard", icon: Icons.dashboard, selected: widget.dashboard, onTap: (){_gotTo("/dashboard");}, ),
                                      _myListTile(title: "Vender", icon: Icons.point_of_sale, selected: widget.inicio, onTap: (){_gotTo("/");}, ),
                                      _myListTile(title: "Transacciones", icon: Icons.transfer_within_a_station, selected: widget.transacciones, onTap: (){_gotTo("/transacciones");},),
                                      _myListTile(title: "Monitoreo", icon: Icons.donut_large, selected: widget.monitoreo, onTap: (){_gotTo("/monitoreo");},),
                                      _myListTile(title: "Registrar premios", icon: Icons.format_list_numbered, selected: widget.registrarPremios, onTap: (){_gotTo("/registrarPremios");},),
                                       _myExpansionTile(
                                        title: "Reportes", 
                                        selected: widget.reporteJugadas || widget.historicoVentas || widget.ventasPorFecha || widget.ventas,
                                        icon: Icons.analytics, 
                                        initialExpanded: widget.reporteJugadas || widget.historicoVentas || widget.ventasPorFecha || widget.ventas,
                                        listaMylisttile: [
                                          _myListTile(title: "Reporte jugadas", icon: null, onTap: (){_gotTo("/reporteJugadas");}, selected: widget.reporteJugadas,), 
                                          _myListTile(title: "Historico ventas", icon: null, onTap: (){_gotTo("/historicoVentas");}, selected: widget.historicoVentas,), 
                                          _myListTile(title: "Ventas por fecha", icon: null, onTap: (){_gotTo("/ventasPorFecha");}, selected: widget.ventasPorFecha,), 
                                          _myListTile(title: "Ventas", icon: null, onTap: (){_gotTo("/ventas");}, selected: widget.ventas,), 
                                        ]
                                      ),
                                       
                                      _myListTile(title: "Pendientes pago", icon: Icons.attach_money, selected: widget.pendientesPago, onTap: (){_gotTo("/pendientesPago");},),
                                      _myExpansionTile(
                                        title: "Bloqueos", 
                                        selected: widget.bloqueosPorLoteria || widget.bloqueosPorJugadas,
                                        icon: Icons.block, 
                                        initialExpanded: widget.bloqueosPorLoteria || widget.bloqueosPorJugadas,
                                        listaMylisttile: [
                                          _myListTile(title: "Bloqueo loterias", icon: null, onTap: (){_gotTo("/bloqueosporloteria");}, selected: widget.bloqueosPorLoteria,), 
                                          _myListTile(title: "Bloqueo jugadas", icon: null, onTap: (){_gotTo("/bloqueosporjugadas");}, selected: widget.bloqueosPorJugadas,), 
                                        ]
                                      ),
                                       _myExpansionTile(
                                        title: "Usuarios", 
                                        selected: widget.usuarios || widget.sesiones,
                                        icon: Icons.person_outline, 
                                        initialExpanded: widget.usuarios || widget.sesiones,
                                        listaMylisttile: [
                                          _myListTile(title: "Usuarios", icon: null, onTap: (){_gotTo("/usuarios");}, selected: widget.usuarios,), 
                                          _myListTile(title: "Sesiones", icon: null, onTap: (){_gotTo("/sesiones");}, selected: widget.sesiones,), 
                                        ]
                                      ),
                                       _myExpansionTile(
                                        title: "Balances", 
                                        selected: widget.balancebancos || widget.balanceBancas,
                                        icon: Icons.six_ft_apart, 
                                        initialExpanded: widget.balancebancos || widget.balanceBancas,
                                        listaMylisttile: [
                                          _myListTile(title: "Balance bancos", icon: null, onTap: (){_gotTo("/balancebancos");}, selected: widget.balancebancos,), 
                                          _myListTile(title: "Balance bancas", icon: null, onTap: (){_gotTo("/balanceBancas");}, selected: widget.balanceBancas,), 
                                        ]
                                      ),
                                      _myListTile(title: "Horarios loterias", icon: Icons.timer, selected: widget.horariosloterias, onTap: (){_gotTo("/horariosloterias");},),
                                      _myListTile(title: "Monedas", icon: Icons.attach_money_rounded, selected: widget.monedas, onTap: (){_gotTo("/monedas");},),
                                      _myListTile(title: "Entidades", icon: Icons.apartment_outlined, selected: widget.entidades, onTap: (){_gotTo("/entidades");},),
                                      _myListTile(title: "Bancas", icon: Icons.account_balance, selected: widget.bancas, onTap: (){_gotTo("/bancas");},),
                                      _myListTile(title: "Loterias", icon: Icons.group_work_outlined, selected: widget.loterias, onTap: (){_gotTo("/loterias");},),
                                      _myListTile(title: "Grupos", icon: Icons.group_work, selected: widget.grupos, onTap: (){_gotTo("/grupos");},),
                                      _myListTile(title: "Ajustes", icon: Icons.settings, selected: widget.ajustes, onTap: (){_gotTo("/ajustes");},),
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