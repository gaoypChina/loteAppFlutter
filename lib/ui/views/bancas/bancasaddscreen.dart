import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/core/services/loteriaservice.dart';
import 'package:loterias/ui/views/bancas/bancasscreen.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/mytogglebuttons.dart';


class BancasAddScreen extends StatefulWidget {
  final Banca data;
  BancasAddScreen({Key key, this.data}) : super(key: key);
  @override
  _BancasAddScreenState createState() => _BancasAddScreenState();
}

class _BancasAddScreenState extends State<BancasAddScreen> {
  var _cargandoNotify = ValueNotifier<bool>(false);
  var _formKey = GlobalKey<FormState>();
  Future _future;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  bool _status = true;
  Banca _data;
  List<Draws> _sorteos;
  List<Loteria> _loterias;
  List<Draws> listaSorteo;
  List<Loteria> listaLoteria;

  _init() async {
    var parsed = await BancaService.index(context: context, retornarLoterias: true, retornarUsuarios: true, retornarDias: true, retornarGrupos: true, retornarMonedas: true, retornarFrecuencias: true);
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((json) => Draws.fromMap(json)).toList() : [];
    _data = widget.data;
    _txtDescripcion.text = (_data != null) ? _data.descripcion : '';
    _txtCodigo.text = (_data != null) ? _data.codigo : '';
    _status = (_data != null) ? _data.status == 1 ? true : false : true;
    // _sorteos = _data != null ? _data.sorteos : [];

    _setsSorteos();
    _setsLoteriasSeleccionadas();

    if(_data == null)
      _data = Banca();
  }

  _setsSorteos(){
    _sorteos = [];
    if(_data != null){
      if(_data.sorteos != null){
        for (var sorteo in _data.sorteos) {
          var s = listaSorteo.firstWhere((element) => element.descripcion == sorteo.descripcion, orElse: () => null);
          if(s != null)
            _sorteos.add(s);
          print("LoteriasAddScreen _init sorteos: ${s != null} : ${s != null ? s.descripcion : ''}");
        }
      }
    }
  }

  _setsLoteriasSeleccionadas(){
    _loterias = [];
    if(_data != null){
      if(_data.loteriaSuperpale != null){
        for (var loteria in _data.loteriaSuperpale) {
          var l = listaLoteria.firstWhere((element) => element.descripcion == loteria.descripcion, orElse: () => null);
          if(l != null)
            _loterias.add(l);
          print("LoteriasAddScreen _init loteriasSeleccionadas: ${l != null} : ${l != null ? l.descripcion : ''}");
        }
      }
    }
  }

  _guardar() async {
      try {
        if(!_formKey.currentState.validate())
          return;

        _data.descripcion = _txtDescripcion.text;
        _data.abreviatura = _txtCodigo.text;
        _data.status = _status ? 1 : 0;
        _data.sorteos = _sorteos;
        _data.loteriaSuperpale = _loterias;
        _cargandoNotify.value = true;
        var parsed = await LoteriaService.guardar(context: context, data: _data);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        _back(parsed);
      } on Exception catch (e) {
        print("_showDialogGuardar _erroor: $e");
        _cargandoNotify.value = false;
      }
    }

    _back(Map<String, dynamic> parsed){
      Loteria data;
      if(parsed["data"] != null)
        data = Loteria.fromMap(parsed["data"]);

      Navigator.pop(context, data);
    }

    _statusScreen(isSmallOrMedium){
      if(isSmallOrMedium)
        return MySwitch(leading: Icon(Icons.check_box), medium: 1, title: "Activo", value: _status, onChanged: _statusChanged);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: MyDropdown(title: "Estado", hint: "${_status ? 'Activa' : 'Desactivada'}", isSideTitle: true, xlarge: 1.6, elements: [[true, "Activa"], [false, "Desactivada"]], onTap: _statusChanged,),
      );
    }

    _statusChanged(data){
      setState(() => _status = data);
    }

    _sorteosScreen(bool isSmallOrMedium){
      if(isSmallOrMedium)
        return ListTile(
          leading: Icon(Icons.ballot),
          title: Text(_sorteos.length > 0 ? _sorteos.map((e) => e.descripcion).join(", ") : "Agregar sorteos"),
          onTap: () async {
            var sorteosRetornados = await showDialog(
              context: context, 
              builder: (context){
                return MyMultiselect(
                  title: "Agregar sorteos",
                  items: listaSorteo.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
                  initialSelectedItems: _sorteos.length == 0 ? [] : _sorteos.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
                );
              }
            );

            if(sorteosRetornados != null)
              setState(() => _sorteos = List.from(sorteosRetornados));
          },
        );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySubtitle(title: "Sorteos", padding: EdgeInsets.only(top: 15, bottom: 4),),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: MyDescripcon(title: "Son los sorteos que se podran jugar en esta loteria.", fontSize: 14,),
          ),
          MyToggleButtons(
            items: listaSorteo.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
            selectedItems: _sorteos != null ? _sorteos.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList() : [],
            onTap: (value){
              int index = _sorteos.indexWhere((element) => element == value);
              if(index != -1)
                setState(() => _sorteos.removeAt(index));
              else
                setState(() => _sorteos.add(value));
            },
          )
          // ToggleButtons(
          //           borderColor: Colors.black,
                    
          //           // fillColor: Colors.grey,
          //           // borderWidth: 2,
          //           // selectedBorderColor: Colors.black,
          //           // selectedColor: Colors.white,
          //           borderWidth: 0.5,
          //           // selectedColor: Colors.pink,
          //           // selectedBorderColor: Colors.black,
          //           fillColor: Colors.grey[300],
          //           borderRadius: BorderRadius.circular(10),
          //           constraints: BoxConstraints(minHeight: 34, minWidth: 48),
          //           children: listaSorteo.map((e) => Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 18.0),
          //             child: Text(e.descripcion, style: TextStyle(fontWeight: FontWeight.w600),),
          //           )).toList(),
          //           // children: [Text("Hola"), Text("Hola")],
          //           onPressed: (int index) {
          //               setState(() {
          //               // for (int i = 0; i < isSelected.length; i++) {
          //               //     isSelected[i] = i == index;
          //               // }
          //               isSelected[index] = !isSelected[index];
          //               });
          //           },
          //           isSelected: isSelected,
          //           ),
        ],
      );
    }

    _loteriasCompanerasScreen(bool isSmallOrMedium){
      if(isSmallOrMedium)
        return ListTile(
          leading: Icon(Icons.ballot),
          title: Text(_loterias.length > 0 ? _loterias.map((e) => e.descripcion).join(", ") : "Agregar loterias companeras"),
          onTap: () async {
            var loteriasRetornadas = await showDialog(
              context: context, 
              builder: (context){
                return MyMultiselect(
                  title: "Agregar loterias",
                  items: listaLoteria.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
                  initialSelectedItems: _loterias.length == 0 ? [] : _loterias.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
                );
              }
            );

            if(loteriasRetornadas != null)
              setState(() => _loterias = List.from(loteriasRetornadas));
          },
        );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySubtitle(title: "Loterias", padding: EdgeInsets.only(top: 15, bottom: 4),),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 15.0),
          //   child: MyDescripcon(title: "Son los sorteos que se podran jugar en esta loteria.", fontSize: 14,),
          // ),
          MyToggleButtons(
            items: listaLoteria.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList(),
            selectedItems: _loterias != null ? _loterias.map((e) => MyToggleData(value: e, child: "${e.descripcion}")).toList() : [],
            onTap: (value){
              int index = _loterias.indexWhere((element) => element == value);
              if(index != -1)
                setState(() => _loterias.removeAt(index));
              else
                setState(() => _loterias.add(value));
            },
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: ToggleButtons(
          //             borderColor: Colors.black,
                      
          //             // fillColor: Colors.grey,
          //             // borderWidth: 2,
          //             // selectedBorderColor: Colors.black,
          //             // selectedColor: Colors.white,
          //             borderWidth: 0.5,
          //             // selectedColor: Colors.pink,
          //             // selectedBorderColor: Colors.black,
          //             fillColor: Colors.grey[300],
          //             borderRadius: BorderRadius.circular(10),
          //             constraints: BoxConstraints(minHeight: 34, minWidth: 48),
          //             children: listaLoteria.map((e) => Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 18.0),
          //               child: Text(e.descripcion, style: TextStyle(fontWeight: FontWeight.w600),),
          //             )).toList(),
          //             // children: [Text("Hola"), Text("Hola")],
          //             onPressed: (int index) {
          //                 setState(() {
          //                 // for (int i = 0; i < isSelected.length; i++) {
          //                 //     isSelected[i] = i == index;
          //                 // }
          //                 isSelectedLoteria[index] = !isSelectedLoteria[index];
          //                 });
          //             },
          //             isSelected: isSelectedLoteria,
          //             ),
          
          // ),
        ],
      );
    }


  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      inicio: true,
      cargando: false,
      cargandoNotify: _cargandoNotify,
      isSliverAppBar: true,
      bottomTap: isSmallOrMedium ? null : _guardar,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: 
          isSmallOrMedium ? 
          SizedBox.shrink() 
          : "Agregar loteria",
          subtitle: isSmallOrMedium ? '' : "Agrega y administra todas tus loterias.",
          // actions: [
          //   MySliverButton(title: "Guardar", onTap: _guardar)
          // ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

            return SliverList(delegate: SliverChildListDelegate([
                  Form(
                    key: _formKey,
                    child: Wrap(
                      children: [
                        MySubtitle(title: "Datos", showOnlyOnLarge: true,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                          child: MyTextFormField(
                            leading: isSmallOrMedium ? SizedBox.shrink() : null,
                            isSideTitle: isSmallOrMedium ? false : true,
                            type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            fontSize: isSmallOrMedium ? 28 : null,
                            controller: _txtDescripcion,
                            title: !isSmallOrMedium ? "Loteria" : "",
                            hint: "Agregar loteria",
                            medium: 1,
                            xlarge: 1.6,
                            isRequired: true,
                            
                          ),
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                          child: MyTextFormField(
                            leading: isSmallOrMedium ? Icon(Icons.code, color: Colors.black.withOpacity(0.7),) : null,
                            isSideTitle: isSmallOrMedium ? false : true,
                            type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            controller: _txtCodigo,
                            title: !isSmallOrMedium ? "Abreviatura" : "",
                            hint: "Abreviatura",
                            medium: 1,
                            xlarge: 1.6,
                            isRequired: true,
                            
                          ),
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        _statusScreen(isSmallOrMedium),
                        MyDivider(showOnlyOnSmall: true,),
                        _sorteosScreen(isSmallOrMedium),
                        MyDivider(showOnlyOnSmall: true,),
                        _loteriasCompanerasScreen(isSmallOrMedium),
                        MyDivider(showOnlyOnSmall: true,),
                        // MyDropdown(
                        //   title: "Estado",
                        //   medium: 1,
                        //   hint: "${_status == 1 ? 'Activado' : 'Desactivado'}",
                        //   elements: [["Activado", "Activado"], ["Desactivado", "Desactivado"]],
                        //   onTap: (data){
                        //     setState(() => _status = (data == 'Activado') ? 1 : 0);
                        //   },
                        // )
                      ],
                    ),
                  ), 
                  
                ]));
          }
        )
         
      )
    );
  }
}