

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/ui/widgets/myexpansiontile.dart';
import 'package:loterias/ui/widgets/mylisttile.dart';

class MyDrawer extends StatefulWidget {
  final bool inicio;
  final bool clientes;
  final bool rutas;
  final bool gastos;
  final bool cajas;
  final bool cerrarCaja;
  final bool bancos;
  final bool prestamos;
  final bool configuracion;
  final bool configuracionPrestamo;
  final bool configuracionEmpresa;
  final bool configuracionRecibo;
  final bool configuracionOtro;
  final bool cuentas;
  final bool usuarios;
  final bool roles;
  final bool sucursales;
  final bool pagos;
  final bool garantias;
  final bool clientesBack;
  final bool visible;
  final bool isForSmallScreen;
  // final ValueChanged onChanged;
  MyDrawer({Key key, @required this.visible, this.inicio = false, this.clientes = false, this.rutas = false, this.gastos = false, this.cajas = false, this.cerrarCaja = false, this.bancos = false, this.prestamos =  false, this.configuracion = false, this.configuracionPrestamo = false, this.configuracionEmpresa = false, this.configuracionRecibo = false, this.configuracionOtro = false, this.cuentas = false, this.usuarios = false, this.roles = false, this.sucursales = false, this.clientesBack = false, this.garantias, this.pagos, this.isForSmallScreen = false}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _cargandoAbrirCaja = false;
  bool _visibleByClick = true;
  bool _visibleOnHover = false;

  _gotTo(String route){
    Navigator.pushNamed(context, route);
  }

  
  _reduceWebDrawer(){

  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
    
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  var _showOnHoverNotify = ValueNotifier<bool>(false);

  _screen({width}){
    // if(!visible)
    // return SizedBox();

    return Container(
                          color: Colors.white,
                          // width: widget.visible == false && value == false ? 65 : 260,
                          width: width,
                          height: MediaQuery.of(context).size.height,
                          child: ListView(children: [
                            SizedBox(height: 5,),
                            Visibility(
                              visible: ModalRoute.of(context)?.canPop == true,
                              child: 
                              widget.visible == false
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
                            ),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Inicio", icon: Icons.apps, selected: widget.inicio, onTap: (){_gotTo("/inicio");}, ),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Prestamos", icon: Icons.request_quote_outlined, selected: widget.prestamos, onTap: (){_gotTo("/prestamos");},),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Clientes", icon: Icons.people, selected: widget.clientes, onTap: (){_gotTo("/clientes");},),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Pagos", icon: Icons.payment, selected: widget.pagos, onTap: (){_gotTo("/pagos");},),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Garantias", icon: Icons.wysiwyg_rounded, selected: widget.garantias, onTap: (){_gotTo("/garantias");},),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Rutas", icon: Icons.location_on, selected: widget.rutas, onTap: (){_gotTo("/rutas");},),
                            MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Gastos", icon: Icons.money_off, selected: widget.gastos, onTap: (){_gotTo("/gastos");},),
                            // MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Usuarios y permisos", icon: Icons.recent_actors),
                            // MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Cajas", icon: Icons.attach_money, selected: widget.cajas, onTap: (){_gotTo("/cajas");}),
                            
                            MyExpansionTile(
                              title: "General", 
                              type: widget.visible ? MyExpansionTileType.normal : _showOnHoverNotify.value ? MyExpansionTileType.normal : MyExpansionTileType.onlyIcon,
                              selected: widget.bancos || widget.cuentas || widget.sucursales,
                              icon: Icons.dashboard_outlined, 
                              initialExpanded: widget.bancos || widget.cuentas,
                              listaMylisttile: [
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Bancos", icon: null, onTap: (){_gotTo("/bancos");}, selected: widget.bancos,), 
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Cuentas", icon: null, onTap: (){_gotTo("/cuentas");}, selected: widget.cuentas,), 
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Sucursales", icon: null, onTap: (){_gotTo("/sucursales");}, selected: widget.sucursales,), 
                              ]
                            ),
                            MyExpansionTile(
                              title: "Usuarios y roles", 
                              type: widget.visible ? MyExpansionTileType.normal : _showOnHoverNotify.value ? MyExpansionTileType.normal : MyExpansionTileType.onlyIcon,
                              selected: widget.usuarios || widget.roles,
                              icon: Icons.supervised_user_circle_outlined, 
                              initialExpanded: widget.usuarios || widget.roles,
                              listaMylisttile: [
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Usuarios", icon: null, onTap: (){_gotTo("/usuarios");}, selected: widget.usuarios,), 
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Roles", icon: null, onTap: (){_gotTo("/roles");}, selected: widget.roles,), 
                              ]
                            ),
                            MyExpansionTile(
                              title: "Configuracion", 
                              icon: Icons.settings_outlined, 
                              type: widget.visible ? MyExpansionTileType.normal : _showOnHoverNotify.value ? MyExpansionTileType.normal : MyExpansionTileType.onlyIcon,
                              selected: widget.configuracionPrestamo || widget.configuracionEmpresa || widget.configuracionRecibo,
                              initialExpanded: widget.configuracionPrestamo || widget.configuracionEmpresa || widget.configuracionRecibo,
                              listaMylisttile: [
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Prestamo", icon: null, onTap: (){_gotTo("/configuracion/prestamo");}, selected: widget.configuracionPrestamo,), 
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Empresa", icon: null, onTap: (){_gotTo("/configuracion/empresa");}, selected: widget.configuracionEmpresa,), 
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Recibo", icon: null, onTap: (){_gotTo("/configuracion/recibo");}, selected: widget.configuracionRecibo,), 
                                MyListTile(type: widget.visible ? MyListTileType.normal : _showOnHoverNotify.value ? MyListTileType.normal : MyListTileType.onlyIcon, title: "Otros", icon: null, onTap: (){_gotTo("/configuracion/otro");}, selected: widget.configuracionOtro,), 
                              ]
                            ),

                          ],),
                        );
                      
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
          visible: widget.visible == false ? boxconstraint.maxWidth < ScreenSize.md ? false : true : true,
          child: MouseRegion(
            onEnter: (value){
              _showOnHoverNotify.value = true;
            },
            onExit: (value){
              _showOnHoverNotify.value = false;
            },
            child: ValueListenableBuilder(
              valueListenable: _showOnHoverNotify,
              builder: (context, value, __) {
                return _screen(width: widget.visible == false && value == false ? 65.0 : 260.0);
              }
            ),
          ),
        );
      }
    );
      
  }
}