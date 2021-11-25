import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/searchdata.dart';
import 'package:loterias/main.dart';
import 'package:loterias/ui/widgets/mydrawer.dart';

import 'myappbar.dart';
import 'mybottom.dart';
import 'mybutton.dart';


myScaffold({@required BuildContext context, key, @required bool cargando, @required ValueNotifier<bool> cargandoNotify, Widget myNestedScrollBar, List<Widget> body, sliverBody, bool dashboard = false, bool inicio = false, bool transacciones = false, bool monitoreo = false, bool registrarPremios = false, bool reporteJugadas = false, bool ventasPorFecha = false, bool historicoVentas = false, bool ventas = false, bool pendientesPago = false, bool balancebancos = false, bool bloqueosPorLoteria = false, bool bloqueosPorJugadas = false, bool sesiones = false, bool horariosloterias = false, bool monedas = false, bool balanceBancas = false, bool usuarios = false, bool bancas = false, bool loterias = false, bool ajustes = false, bool grupos = false, bool entidades = false, bool resizeToAvoidBottomInset = true, bool isSliverAppBar = false, bottomTap, String textBottom = "Guardar", bool showDrawerOnSmallOrMedium = false, floatingActionButton, bool showDrawer = true, ValueNotifier valueNotifyDrawer, Function onDrawerChanged, ValueChanged<SearchData> appBarDuplicarTicket}){
  Widget widget = SizedBox();
  var _defaultValueNotifyDrawer = ValueNotifier(DRAWER_IS_OPEN);
  var _valueNotifierAppBarPago = ValueNotifier<dynamic>(null);
  Future<Pago> _futurePago;
  AnimationController drawerAnimationController;
  // if(myNestedScrollBar != null)
  //   widget = myNestedScrollBar;
    // MyNestedScrollBar(
    //     headerSliverBuilder: [SliverToBoxAdapter(child: Container(width: 200, height: 200, color: Colors.blue),)],
    //     body: Container(child: Text("Holaaa"), color: Colors.red),
    //   );

    _initDrawerNotifier() async {
      if(valueNotifyDrawer != null){
        if(_defaultValueNotifyDrawer.value != valueNotifyDrawer.value){
          _defaultValueNotifyDrawer.value = valueNotifyDrawer.value;
        }
      }else{
        if(_defaultValueNotifyDrawer.value != DRAWER_IS_OPEN){
          _defaultValueNotifyDrawer.value = DRAWER_IS_OPEN;
        }
      }
    }

    _drawerWidget(bool value){
      return MyDrawer(
        isExpanded: value, 
        // type: value == false ? MyDrawerType.onlyIcons : MyDrawerType.normal, 
        dashboard: dashboard, inicio: inicio, transacciones: transacciones, reporteJugadas: reporteJugadas, monitoreo: monitoreo, registrarPremios: registrarPremios, ventasPorFecha: ventasPorFecha, historicoVentas: historicoVentas, ventas: ventas, 
        pendientesPago: pendientesPago, balancebancos: balancebancos, bloqueosPorLoteria: bloqueosPorLoteria, bloqueosPorJugadas: bloqueosPorJugadas, sesiones: sesiones, 
        balanceBancas: balanceBancas, usuarios: usuarios, horariosloterias: horariosloterias, monedas: monedas, entidades: entidades, bancas: bancas, loterias: loterias, grupos: grupos, ajustes: ajustes,
        onMouseEnter: (){
          if(drawerAnimationController != null)
            drawerAnimationController.forward();
        },
        onMouseExit: (){
          print("MyScaffold onMouseExit onlyIcons: ${drawerAnimationController != null}");
          if(drawerAnimationController != null)
            drawerAnimationController.reverse();
        },
      );
    }

    Widget _getBodyOrSliverBody(bool value){
      Widget bodyOrSliverBodyWidget;
      if(sliverBody == null)
        bodyOrSliverBodyWidget = Column(crossAxisAlignment: CrossAxisAlignment.start, children: body,);
      else{
        bodyOrSliverBodyWidget = Padding(padding: EdgeInsets.only(left: !Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? value == false ? 50 : 0 : 0), child: sliverBody);
      }

      if(value)
        bodyOrSliverBodyWidget = Expanded(child: bodyOrSliverBodyWidget);

      return bodyOrSliverBodyWidget;
    }

    if(myNestedScrollBar != null)
      widget = myNestedScrollBar;
    else if(body != null || sliverBody != null)
      // widget = Row(
      //   children: [
      //   showDrawer
      //   ?
      //   ValueListenableBuilder(
      //     valueListenable: valueNotifyDrawer != null ? valueNotifyDrawer :  _defaultValueNotifyDrawer, 
      //     builder: (_, value, __){
      //       print("MyScaffold _defaultValueNotifyDrawer: $value");
      //       return MyDrawer(visible: value, inicio: inicio, transacciones: transacciones, reporteJugadas: reporteJugadas, monitoreo: monitoreo, registrarPremios: registrarPremios, ventasPorFecha: ventasPorFecha, historicoVentas: historicoVentas, ventas: ventas, pendientesPago: pendientesPago, balancebancos: balancebancos, bloqueosPorLoteria: bloqueosPorLoteria, bloqueosPorJugadas: bloqueosPorJugadas, sesiones: sesiones, balanceBancas: balanceBancas, usuarios: usuarios, horariosloterias: horariosloterias, monedas: monedas);
      //     }
      //   )
      //   :
      //   SizedBox.shrink()
      //   ,
      //   ValueListenableBuilder(
      //     valueListenable: valueNotifyDrawer != null ? valueNotifyDrawer : _defaultValueNotifyDrawer, 
      //     builder: (_, value, __){
      //       if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
      //         return SizedBox();

      //       if(value == false)
      //         return SizedBox(width: 0);
      //       else{
      //         return SizedBox(width: 15);
      //       }
      //     }
      //   ),
      //   // Visibility(visible: !Utils.isSmallOrMedium(MediaQuery.of(context).size.width), child: SizedBox(width: 50)), 
      //   Expanded(
      //     child:
      //     (sliverBody != null)
      //     ?
      //     sliverBody
      //     :
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: body,
      //     ),
      //   )
      // ]);

    widget = ValueListenableBuilder(
        valueListenable: valueNotifyDrawer != null ? valueNotifyDrawer :  _defaultValueNotifyDrawer, 
        builder: (_, value, __) {

          Widget bodyOrSliverBodyWidget = _getBodyOrSliverBody(value);

          
          List<Widget> widgets = [
           
            ValueListenableBuilder(
              valueListenable: valueNotifyDrawer != null ? valueNotifyDrawer : _defaultValueNotifyDrawer, 
              builder: (_, value, __){
                if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
                  return SizedBox();
      
                if(value == false)
                  return SizedBox(width: 0);
                else{
                  return SizedBox(width: 15);
                }
              }
            ),
            // Visibility(visible: !Utils.isSmallOrMedium(MediaQuery.of(context).size.width), child: SizedBox(width: 50)), 
            bodyOrSliverBodyWidget
          ];


          if(showDrawer){
            //Si value == true eso quiere decir que se retornara un Row Widget porque el usuario quiere que el drawer este visible
            //asi que el drawer debe insertarse al principio de los widgets, en caso contrario el drawer debe insertarse al final
            //ya que el widget a retornar es un Stack Widget
            if(value)
              widgets.insert(0, _drawerWidget(value));
            else
              widgets.add(_drawerWidget(value));
          }
            

          

          return 
          value
          ?
          Row(
            children: widgets
          )
          :
          Stack(
            children: widgets
          )
          ;
          // :
          // Stack(
          //   children: [
          //     row,
          //     // MyDrawer(
          //     //   visible: value, inicio: inicio, transacciones: transacciones, reporteJugadas: reporteJugadas, monitoreo: monitoreo, registrarPremios: registrarPremios, ventasPorFecha: ventasPorFecha, historicoVentas: historicoVentas, 
          //     //   ventas: ventas, pendientesPago: pendientesPago, balancebancos: balancebancos, bloqueosPorLoteria: bloqueosPorLoteria, 
          //     //   bloqueosPorJugadas: bloqueosPorJugadas, sesiones: sesiones, balanceBancas: balanceBancas, usuarios: usuarios, horariosloterias: horariosloterias, monedas: monedas, entidades: entidades, bancas: bancas, loterias: loterias, grupos: grupos, ajustes: ajustes
          //     //   animationBuilder: (context, animationController, widget){
          //     //     drawerAnimationController = animationController;
          //     //     return widget;
          //     //   },
          //     //   onMouseExit: (){
          //     //   print("MyScaffold onMouseExit normal: ${drawerAnimationController != null}");
          //     //   if(drawerAnimationController != null)
          //     //     drawerAnimationController.reverse();
          //     // },
          //     // )
          //   ],
          // );
        }
      );
    

    

    print("MyScaffold widget: ${myNestedScrollBar == null}");

    _onMenuTap() async {
      if(!Utils.isSmallOrMedium(MediaQuery.of(context).size.width)){
        if(valueNotifyDrawer != null){
          // valueNotifyDrawer.value = !valueNotifyDrawer.value;
          if(onDrawerChanged != null)
            onDrawerChanged();
        }else{
          _defaultValueNotifyDrawer.value = !_defaultValueNotifyDrawer.value;
          DRAWER_IS_OPEN = _defaultValueNotifyDrawer.value;
          await Utils.setMenuStatus(isOpen: _defaultValueNotifyDrawer.value);
        }
      }
      // else
      //   key.currentState.openDrawer();
    }

    _drawerScreen(){
      if(showDrawerOnSmallOrMedium == false && Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return null;

      return MyDrawer(isForSmallScreen: true, isExpanded: true, inicio: inicio, transacciones: transacciones, reporteJugadas: reporteJugadas, monitoreo: monitoreo, registrarPremios: registrarPremios, ventasPorFecha: ventasPorFecha, historicoVentas: historicoVentas, ventas: ventas, pendientesPago: pendientesPago, balancebancos: balancebancos, bloqueosPorLoteria: bloqueosPorLoteria, bloqueosPorJugadas: bloqueosPorJugadas, sesiones: sesiones, balanceBancas: balanceBancas, usuarios: usuarios, horariosloterias: horariosloterias, monedas: monedas);
    }

  _initDrawerNotifier();

  Future<Pago> _getPago() async {
    var c = await DB.create();
    var pago = await c.getPagoPendiente();
    return pago;
  }

  _futurePago = _getPago();

  return Scaffold(
        // resizeToAvoidBottomInset: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? true : false,
        key: key,
          backgroundColor: Colors.white,
          // drawer: Drawer( child: ListView(children: [
          //   ListTile(
          //     leading: Icon(Icons.home),
          //     title: Text("Inicio"),
          //   )
          // ],),),
          drawer: _drawerScreen(),
          // appBar: (isSliverAppBar == true && (ScreenSize.isMedium(MediaQuery.of(context).size.width) || ScreenSize.isSmall(MediaQuery.of(context).size.width))) ? null : myAppBar(context: context, cargando: cargando, onTap: _onMenuTap),
          appBar: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) 
          ? 
          SHOW_PAYMENT_APPBAR
          ?
          PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: AppBar(
              automaticallyImplyLeading: false, 
              backgroundColor: Colors.pink, 
              elevation: 0, 
              title: FutureBuilder<Pago>(
                future: _futurePago,
                builder: (context, snapshot) {
                  var message = 'Tiene factura pendiente';
                  if(snapshot.data != null){
                    if(snapshot.data.fechaDiasGracia != null)
                      message = 'Pagar antes del ' + MyDate.dateRangeToNameOrString(DateTimeRange(start: snapshot.data.fechaDiasGracia, end: snapshot.data.fechaDiasGracia));
                  }
                  return Text("$message", style: TextStyle(fontSize: 18));
                }
              ),
            ),
          ) 
          :
          null
          // : myAppBar(context: context, cargando: cargando, onTap: _onMenuTap),
          : MyAppBar(cargando: cargando, onTap: _onMenuTap, appBarDuplicarTicket: appBarDuplicarTicket,),
          body: (myNestedScrollBar != null) ? myNestedScrollBar : widget,
          bottomNavigationBar:  myBottomWidget(context: context, onTap: bottomTap, text: textBottom, cargando: cargandoNotify),
          floatingActionButton: floatingActionButton,
          // body: MyNestedScrollBar(
          //   headerSliverBuilder: [SliverToBoxAdapter(child: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.blue),), SliverToBoxAdapter(child: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.red),)],
          //   body: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.yellow),
          // )
      );
   
  
}
