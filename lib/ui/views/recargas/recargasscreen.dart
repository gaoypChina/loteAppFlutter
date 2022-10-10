import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/ticketimagev2.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/proveedor.dart';
import 'package:loterias/core/models/recarga.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/recargasservice.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/ui/views/recargas/recargasadialogddscreen.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycirclebutton.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class RecargasScreen extends StatefulWidget {
  const RecargasScreen({Key key}) : super(key: key);

  @override
  State<RecargasScreen> createState() => _RecargasScreenState();
}

class _RecargasScreenState extends State<RecargasScreen> {
  StreamController<List<Recarga>> _streamControllerRecargas;
  DateTimeRange _date;
  int _idGrupoAsignadoAEsteUsuario;
  int _idBancaAsignadaAEsteUsuario;
  List<Recarga> listaRecarga = [];
  List<Banca> listaBanca = [];
  List<Grupo> listaGrupo = [];
  List<Proveedor> listaProveedor = [];
  Banca _banca;
  Grupo _grupo;
  Proveedor _proveedor;
  bool _tienePermisoJugarComoCualquierBanca = false;
  var _yaSeIniciaronLosDatosNotifier = ValueNotifier<bool>(false);
  PageController _pageControllerOpcionesDialog;

  _init() async {
    _date = MyDate.getTodayDateRange();

    _tienePermisoJugarComoCualquierBanca = await Db.existePermiso("Jugar como cualquier banca");

    _idGrupoAsignadoAEsteUsuario = await Db.idGrupo();

    _idBancaAsignadaAEsteUsuario = await Db.idBanca();

    var parsed = await RecargaService.index(context: context);

    listaRecarga = Recarga.fromMapList(parsed["recargas"]);
    listaBanca = Banca.fromMapList(parsed["bancas"]);
    listaGrupo = Grupo.fromMapList(parsed["grupos"]);
    listaProveedor = Proveedor.fromMapList(parsed["proveedores"]);

    listaBanca.insert(0, Banca.getBancaTodas);
    listaGrupo.insert(0, Grupo.getGrupoTodos);
    listaProveedor.insert(0, Proveedor.getProveedorTodos);

    _banca = listaBanca[0];
    _grupo = listaGrupo[0];
    _proveedor = listaProveedor[0];

    if(_idGrupoAsignadoAEsteUsuario != null)
      _grupo = listaGrupo.firstWhere((element) => element.id == _idGrupoAsignadoAEsteUsuario, orElse: () => null);

    _yaSeIniciaronLosDatosNotifier.value = true;

    _streamControllerRecargas.add(listaRecarga);
  }

  _search({bool cargaSilenciosa = false}) async {

    // try {
      if(!cargaSilenciosa)
        _streamControllerRecargas.add(null);

      var parsed = await RecargaService.search(context: context, 
      idBanca: !_tienePermisoJugarComoCualquierBanca ? _idBancaAsignadaAEsteUsuario : _banca.id != 0 ? _banca.id : null, 
      idGrupo: _idGrupoAsignadoAEsteUsuario != null ? _idGrupoAsignadoAEsteUsuario : _grupo.id != 0 ? _grupo.id : null,
      fechaDesde: _date.start, fechaHasta: _date.end,
      idProveedor: _grupo.id != 0 ? _grupo.id : null
    );
  
      listaRecarga = Recarga.fromMapList(parsed["recargas"]);
      _streamControllerRecargas.add(listaRecarga);
    // } on Exception catch (e) {
    //   // TODO
    // }
   
  }

  _dateChanged(DateTimeRange value){
    setState(() {_date = value; _search();});
  }

  _bancaChanged(Banca value){
    setState(() {_banca = value; _search();});
  }

  _grupoChanged(Grupo value){
    setState(() {_grupo = value; _search();});
  }

  _proveedorChanged(Proveedor value){
    setState(() {_proveedor = value; _search();});
  }
  
   dynamic _dateWidget(bool isSmallOrMedium){
    if(isSmallOrMedium)
    return MyCircleButton(
      child: MyDate.dateRangeToNameOrString(_date), 
      onTap: (){
        _back(){
          Navigator.pop(context);
        }
        showMyModalBottomSheet(
          context: context, 
          myBottomSheet2: MyBottomSheet2(
            child: MyDateRangeDialog(
              date: _date,
              onCancel: _back,
              onOk: (date){
                _dateChanged(date);
                _back();
              },
            ), 
          height: 350
          )
        );
      }
    );

  

    return Container(
      width: 180,
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MyDropdown(
              title: null, 
              leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              hint: "${MyDate.dateRangeToNameOrString(_date)}",
              onTap: (){
                showMyOverlayEntry(
                  context: context,
                  right: 20,
                  builder: (context, overlay){
                    _cancel(){
                      overlay.remove();
                    }
                    return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){_dateChanged(date); overlay.remove();},);
                  }
                );
              },
            ),
          );
        }
      ),
    );
              
  }

   _myFilterWidget(bool isSmallOrMedium){
    return MyFilterV2(
      padding: !isSmallOrMedium ? EdgeInsets.symmetric(horizontal: 15, vertical: 10) : null,
      item: [
        MyFilterItem(
          // color: Colors.blue[800],
          enabled: _tienePermisoJugarComoCualquierBanca,
          visible: _tienePermisoJugarComoCualquierBanca,
          hint: "${_banca != null ? 'Banca:  ' + _banca.descripcion: 'Banca...'}", 
          data: listaBanca.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
          onChanged: (banca) => _bancaChanged(banca)
        ),
        MyFilterItem(
          // color: Colors.green[700],
          enabled: _idGrupoAsignadoAEsteUsuario == null,
          visible: _tienePermisoJugarComoCualquierBanca,
          hint: "${_grupo != null ? 'Grupo:  ' + _grupo.descripcion: 'Grupo...'}", 
          data: listaGrupo.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
          onChanged: (grupo) => _grupoChanged(grupo)
        ),
        MyFilterItem(
          // color: Colors.orange[700],
          hint: "${_proveedor != null ? 'Proveedor:  ' + _proveedor.nombre : 'Proveedor...'}", 
          data: listaProveedor.map((e) => MyFilterSubItem(child: e.nombre, value: e)).toList(),
          onChanged: (proveedor) => _proveedorChanged(proveedor)
        ),
      ],
    );
    
  }

  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: MyCollapseChanged(
        child: ValueListenableBuilder<bool>(
          valueListenable: _yaSeIniciaronLosDatosNotifier,
          builder: (context, yaSeIniciaronLosDatos, __) {
            if(!yaSeIniciaronLosDatos)
              return SizedBox.shrink();

            return Row(
              children: [
              _dateWidget(isSmallOrMedium),
                Expanded(child: _myFilterWidget(isSmallOrMedium))
              ],
            );
          }
        )
        
          
        ,
      ),
    )
    :
    "Visualiza informes detallados y personalizables sobre los tickets creados por cada banca";
  }

  _showDialogAnularRecarga({Recarga data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea anular la recarga realizada al numero ", boldText: "${data.numero} ?",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  await RecargaService.anular(context: context, recarga: data);
                  _search(cargaSilenciosa: true);
                  setState(() => cargando = false);
                  Navigator.pop(context);
                } on dynamic catch (e) {
                  print("_showDialogEliminar error: $e");
                  setState(() => cargando = false);
                }
              }
            );
          }
        );
      }
    );
  }

  showDialogOpciones(Recarga recarga) async {
    int valorVerRecarga = 1;
    int valorReimprimir = 2;
    int valorCompartir = 3;
    int valorEnviarPorWhatsApp = 4;
    int valorAnularRecarga = 5;

    var value = await showMenu(
      context: context, 
      position: RelativeRect.fromLTRB(100, 100, 100, 100), 
      items: [
          PopupMenuItem(
            value: 1,
            child: Text("Ver"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Reimprimir"),
          ),
          PopupMenuItem(
             value: 3,
            child: Text("Compartir"),
          ),
          PopupMenuItem(
             value: 4,
            child: Text("Enviar por WhatsApp"),
          ),
          PopupMenuItem(
            value: valorAnularRecarga,
            child: Text("Anular"),
          ),
        ],
    );

    if(value == valorAnularRecarga)
      _showDialogAnularRecarga(data: recarga);
    else{

      if(value == valorReimprimir)
        RecargaService.imprimir(context, recarga);
      else if(value == valorCompartir)
        await RecargaService.compartirTicket(context, recarga);
      else if(value == valorEnviarPorWhatsApp)
        await RecargaService.compartirTicket(context, recarga, false);

    }

    return;

    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Opciones"),
          content: PageView(
            controller: _pageControllerOpcionesDialog,
            children: [
              ListView(
                children: [
                  ListTile(
                    title: Text("Ver"),
                    onTap: (){},
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    _streamControllerRecargas = BehaviorSubject();
    _pageControllerOpcionesDialog = PageController();
    _init();

    super.initState();
  }

  _irAVentanaRecargasAddSCreen() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context){
         return RecargasDialogAddScreen();
       }));

    _search(cargaSilenciosa: true);
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);

    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.add), onPressed: _irAVentanaRecargasAddSCreen,) : null,
      isSliverAppBar: true,
      sliverBody: MySliver(
      sliverAppBar: MySliverAppBar(
        title: "Recargas",
        expandedHeight: isSmallOrMedium ? 105 : 85,
        subtitle: _subtitle(isSmallOrMedium),
      ), 
      sliver: StreamBuilder<List<Recarga>>(
        stream: _streamControllerRecargas.stream,
        builder: (context, snapshot) {

          if(snapshot.hasError)
            return SliverFillRemaining(
              child: MyEmpty(
                title: "Error",
                titleButton: "Volver a cargar",
                onTap: () => _init(),
                color: Colors.red,
              ),
            );
            
          if(snapshot.data == null)
            return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );

          if(snapshot.data.isEmpty)
            return SliverFillRemaining(
              child: MyEmpty(
                title: "No hay recargas realizadas",
                titleButton: "No hay datos",
                onTap: null,
                icon: Icons.send_to_mobile,
              ),
            );

          return SliverList(delegate: SliverChildBuilderDelegate(
            (context, index){
              return Padding(
                padding: snapshot.data.length - 1 == index ? const EdgeInsets.only(bottom: 50.0) : const EdgeInsets.all(0.0),
                child: ListTile(
                  isThreeLine: true,
                  onTap: () => showDialogOpciones(snapshot.data[index]),
                  leading: CircleAvatar(
                    backgroundColor: Utils.fromHex("${snapshot.data[index].proveedor.colorDeFondo}"),
                    radius: 15,
                  ),
                  title: Text("${snapshot.data[index].codigoDeAutorizacion}", style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: Text("${Utils.toCurrency(snapshot.data[index].monto)}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(text: TextSpan(
                        style: TextStyle(color: Colors.black54),
                        children: [
                          // TextSpan(text: "${snapshot.data[index].numero}", style: TextStyle(fontWeight: FontWeight.bold)),
                          // TextSpan(text: "  •  "),
                          // TextSpan(text: "${snapshot.data[index].usuario.usuario}"),
                          // TextSpan(text: "  •  "),
                          TextSpan(text: "${snapshot.data[index].banca.descripcion}"),
                          TextSpan(text: "  •  "),
                          // TextSpan(text: "${snapshot.data[index].proveedor.nombre}", style: TextStyle(color: Utils.fromHex(snapshot.data[index].proveedor.colorDeFondo), fontWeight: FontWeight.bold)),
                          // TextSpan(text: "  •  "),
                          TextSpan(text: "${Utils.toFormatoRD(snapshot.data[index].numero)}"),
                        ]
                      )),
                      Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: DateTime.parse(Utils.dateTimeToDate(snapshot.data[index].created_at, '00:00')), end: DateTime.parse(Utils.dateTimeToDate(snapshot.data[index].created_at, '23:59:59'))))}  ${Utils.toDosDigitos(snapshot.data[index].created_at.hour.toString())}:${Utils.toDosDigitos(snapshot.data[index].created_at.minute.toString())}")
                    ],
                  ),
                ),
              );
            },
            childCount: snapshot.data.length
          ));

        }
      )
    )
  
    );
  }
}