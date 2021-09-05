import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/services/balanceservice.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:rxdart/rxdart.dart';

class BalanceBancosScreen extends StatefulWidget {
  const BalanceBancosScreen({ Key key }) : super(key: key);

  @override
  _BalanceBancosScreenState createState() => _BalanceBancosScreenState();
}

class _BalanceBancosScreenState extends State<BalanceBancosScreen> {
  var _txtSearch = TextEditingController();
  StreamController<List<Entidad>> _streamController;
  DateTimeRange _date;
  List<Entidad> listaData = [];

  _getBalance() async {
   try{
    //  setState(() => _cargando = true);
    print("_getMonitoreo fechaInicial: ${_date.start.toString()}");
    print("_getMonitoreo fechaFinal: ${_date.end.toString()}");
    _streamController.add(null);
    var parsed = await BalanceService.bancos(context: context, fechaHasta: _date.start);
    listaData = (parsed["data"] != null) ? parsed["data"].map<Entidad>((json) => Entidad.fromMap(json)).toList() : [];
    _streamController.add(listaData);

    // setState(() => _cargando = false);
   } on Exception catch(e){
      // setState(() => _cargando = false);
    // _streamControllerMonitoreo.add([]);
   }
  }

  _dataScreen(AsyncSnapshot<List<Entidad>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: 
          snapshot.data.asMap().map((key, e){
            var valueNotify = ValueNotifier<bool>(false);
            return MapEntry(
              key,
              key == 0
              ?
              Column(
                children: [
                  Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // color: Colors.amber,
                          color: Colors.grey[100],
                          child: ListTile(
                            leading: Text('ID'),
                            title: Text('Banco'),
                            trailing: Text('Balance'),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Text("${key + 1}"),
                      title: Text("${e.nombre}"),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${e.moneda != null ? e.moneda.descripcion : ''}"),
                          // Text("${e.sorteos}"),
                        ],
                      ),
                      // onTap: (){_agregarOEditar(data: e);},
                      trailing: Text("${Utils.toCurrency(e.balance)}"),
                    ),
                  ),
                ],
              )
              
              :
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Text("${key + 1}"),
                  title: Text("${e.nombre}"),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${e.moneda != null ? e.moneda.descripcion : ''}"),
                      // Text("${e.sorteos}"),
                    ],
                  ),
                  // onTap: (){_agregarOEditar(data: e);},
                  trailing: Text("${Utils.toCurrency(e.balance)}"),
                ),
              )
            );
          }).values.toList()
          // snapshot.data.map((e) => ListTile(
          //   leading: _avatarScreen(e),
          //   title: Text("${e.descripcion}"),
          //   isThreeLine: true,
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("${e.abreviatura}"),
          //       // Text("${e.sorteos}"),
          //     ],
          //   ),
          //   onTap: (){_agregarOEditar(data: e);},
          //   trailing: Row(
          //     children: [
          //       ValueListenableBuilder<bool>(
          //         valueListenable: valueNotify,
          //         builder: (context, value, __) {
          //           return Row(
          //             children: [
          //               Checkbox(value: e.pordefecto == 1, onChanged: (value) async {
          //                 try {
          //                   valueNotify.value = !valueNotify.value;
          //                   var parsed = await MonedasService.pordefecto(context: context, data: e);
          //                   listaData = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
          //                   valueNotify.value = false;
          //                   _streamController.add(listaData);
          //                 } on Exception catch (e) {
          //                   valueNotify.value = false;
          //                 }
          //               }),
          //               Visibility(visible: value, child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator()))
          //             ],
          //           );
          //         }
          //       ),
          //       IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          //     ],
          //   ),
          // )).toList(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: MyTable(
        customTotals: SizedBox(),
        showColorWhenImpar: true,
        columns: ["#", "Entidad", "Balance"], 
        rows: 
        // snapshot.data.map((e) => [
        //   e, 
        //   Text("${e.descripcion}", style: TextStyle(color: Utils.fromHex(e.color), fontWeight: FontWeight.w700),), 
        //   "${e.abreviatura}", 
        //   "${e.equivalenciaDeUnDolar}", 
        //   ValueListenableBuilder<Object>(
        //     stream: null,
        //     builder: (context, snapshot) {
        //       return Checkbox(value: e.pordefecto == 1, onChanged: (value){});
        //     }
        //   )
        // ]).toList(),
        snapshot.data.asMap().map((key, e) {
          var valueNotify = ValueNotifier<bool>(false);
          return MapEntry(
            key, 
            [
              e, 
              "${key + 1}",
              "${e.nombre}",
              MyTableCell(
                value: e,
                color: (Utils.toDouble(e.balance.toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                child: Center(child: Text("${Utils.toCurrency(e.balance)}", style: TextStyle(fontWeight: FontWeight.bold))),
                // padding: EdgeInsets.symmetric(vertical: 5),
              ), 
            ]
          );
        }).values.toList(),
        isScrolled: true
      ),
    );
  }

  _search(String data){
    print("SucursalesSCreen _search: $data");
    if(data.isEmpty)
      _streamController.add(listaData);
    else
      {
        var element = listaData.where((element) => element.nombre.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${element.length}");
        _streamController.add(listaData.where((element) => element.nombre.toLowerCase().indexOf(data) != -1).toList());
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _date = MyDate.getTodayDateRange();
    _getBalance();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Balance bancos",
          actions: [
            MySliverButton(
              title: "", 
              iconWhenSmallScreen: Icons.date_range,
              showOnlyOnSmall: true,
              onTap: () async {
                var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

              if(date != null)
                setState(() {
                  _date = DateTimeRange(
                    start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
                    end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
                  );
                  _getBalance();
                });
              },
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return MyDropdown(title: null, 
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: () async {
                        var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

                      if(date != null)
                        setState(() {
                          _date = DateTimeRange(
                            start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
                            end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
                          );
                          _getBalance();
                        });
                      },
                    );
                  }
                ),
              ), 
              onTap: (){}
              ),
          ],
        ), 
        sliver: StreamBuilder<List<Entidad>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

            if(snapshot.data.length == 0 && isSmallOrMedium)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay datos", icon: Icons.bakery_dining_sharp, titleButton: "No hay entidades",),));


            return SliverList(delegate: SliverChildListDelegate([
               MySubtitle(title: "${listaData.length} Entidades", showOnlyOnLarge: true,),
              Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _mydropdown(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 18.0),
                      child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
                    ))
                ],
              ),
               _dataScreen(snapshot, isSmallOrMedium),
              SizedBox(height: snapshot.data.length > 6 ? 70 : 0),
            ]));
          }
        )
      
      )
    );
  }
}