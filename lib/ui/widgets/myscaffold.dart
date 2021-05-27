import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mydrawer.dart';

import 'myappbar.dart';
import 'mybutton.dart';


myScaffold({@required BuildContext context, key, @required bool cargando, @required ValueNotifier<bool> cargandoNotify, Widget myNestedScrollBar, List<Widget> body, sliverBody, bool inicio = false, bool clientes = false, bool rutas = false, bool gastos = false, bool cajas = false, bool bancos = false, bool prestamos = false, bool configuracionPrestamo = false, bool configuracionEmpresa = false, bool configuracionRecibo = false, bool configuracionOtro = false, bool cuentas = false, bool roles = false, bool garantias = false, bool pagos = false, bool sucursales = false, bool usuarios = false, bool resizeToAvoidBottomInset = true, bool isSliverAppBar = false, bottomTap, String textBottom = "Guardar", bool showDrawerOnSmallOrMedium = false, floatingActionButton}){
  Widget widget = SizedBox();
  var _valueNotifyDrawer = ValueNotifier(true);
  // if(myNestedScrollBar != null)
  //   widget = myNestedScrollBar;
    // MyNestedScrollBar(
    //     headerSliverBuilder: [SliverToBoxAdapter(child: Container(width: 200, height: 200, color: Colors.blue),)],
    //     body: Container(child: Text("Holaaa"), color: Colors.red),
    //   );

    if(myNestedScrollBar != null)
      widget = myNestedScrollBar;
    else if(body != null || sliverBody != null)
      widget = Row(
        children: [
        ValueListenableBuilder(
          valueListenable: _valueNotifyDrawer, 
          builder: (_, value, __){
            return MyDrawer(visible: value, inicio: inicio, clientes: clientes, cajas: cajas, rutas: rutas, gastos: gastos, bancos: bancos, prestamos: prestamos, configuracionPrestamo: configuracionPrestamo, configuracionEmpresa: configuracionEmpresa, configuracionRecibo: configuracionRecibo, configuracionOtro: configuracionOtro, cuentas: cuentas, roles: roles, sucursales: sucursales, usuarios: usuarios, garantias: garantias, pagos: pagos);
          }
        ),
        ValueListenableBuilder(
          valueListenable: _valueNotifyDrawer, 
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
        Expanded(
          child:
          (sliverBody != null)
          ?
          sliverBody
          :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: body,
          ),
        )
      ]);
    

    print("MyScaffold widget: ${myNestedScrollBar == null}");

    _onMenuTap(){
      if(!Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
      _valueNotifyDrawer.value = !_valueNotifyDrawer.value;
      // else
      //   key.currentState.openDrawer();
    }

    _drawerScreen(){
      if(showDrawerOnSmallOrMedium == false && Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return null;

      return MyDrawer(isForSmallScreen: true, visible: true, inicio: inicio, clientes: clientes, cajas: cajas, rutas: rutas, gastos: gastos, bancos: bancos, prestamos: prestamos, configuracionPrestamo: configuracionPrestamo, configuracionEmpresa: configuracionEmpresa, configuracionRecibo: configuracionRecibo, configuracionOtro: configuracionOtro, cuentas: cuentas, roles: roles, sucursales: sucursales, usuarios: usuarios, garantias: garantias, pagos: pagos);
    }

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
      appBar: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? null : myAppBar(context: context, cargando: cargando, onTap: _onMenuTap),
      body: (myNestedScrollBar != null) ? myNestedScrollBar : widget,
      bottomNavigationBar:  myBottomWidget(context: context, onTap: bottomTap, text: textBottom, cargando: cargandoNotify),
      floatingActionButton: floatingActionButton,
      // body: MyNestedScrollBar(
      //   headerSliverBuilder: [SliverToBoxAdapter(child: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.blue),), SliverToBoxAdapter(child: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.red),)],
      //   body: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.yellow),
      // )
  );
  
}

Widget myBottomWidget({@required BuildContext context, Function onTap, String text, ValueNotifier<bool> cargando}){

  _back(){
    Navigator.pop(context);
  }

  return (onTap == null)
  ?
  null
  :
  Container(
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              offset: Offset(0.0, -1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ValueListenableBuilder(
                      valueListenable: cargando,
                      builder: (_, value, __) {
                        return Wrap(children: [
                          value
                          ?
                          CircularProgressIndicator()
                          :
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextButton(onPressed: _back, child: Text("Cancelar", style: TextStyle(color: Utils.fromHex("#3c4043"), fontFamily: "GoogleSans"),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15),
                            child: MyButton(
                              title: text,
                              function: onTap,
                              cargando: value,
                              type: MyButtonType.noResponsive,
                            ),
                          ),
                          
                        ],);
                      }
                    ),
                  )
                )
              ],
            ),
      );
      
}