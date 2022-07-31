import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/horariosservice.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytogglebuttons.dart';

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({ Key key }) : super(key: key);

  @override
  _HorariosScreenState createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  var _cargandoNotify = ValueNotifier<bool>(false);
  List<Loteria> listaLoteria = [];
  Loteria selectedLoteria;
  List<Dia> listaDia = [];
  List<Dia> _dias = [];
  Future _future;

  _init() async {
    var parsed = await HorariosService.index(context: context);
    print("HorariosScreen _init: $parsed");
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    selectedLoteria = listaLoteria != null ? listaLoteria.length > 0 ? listaLoteria[0] : null : null;
    _dias = selectedLoteria != null ? selectedLoteria.dias.length > 0 ? List<Dia>.from(selectedLoteria.dias) : [] : [];
  }

   _guardar() async {
    if(_cargandoNotify.value)
      return;

      try {
        // if(!_formKey.currentState.validate())
        //   return;

        _cargandoNotify.value = true;
        var parsed = await HorariosService.guardar(context: context, data: listaLoteria);
        print("_showDialogGuardar parsed: $parsed");
        
        _cargandoNotify.value = false;
        Utils.showAlertDialog(context: context, title: "Mensaje", content: "Se ha guardado correctamente");
        // _back(parsed);
      } on Exception catch (e) {
        print("_showDialogGuardar _erroor: $e");
        // _cargandoNotify.value = false;
      }
    }

   _horaAperturaChanged(Dia dia) async {
    var diaLoteriaSeleccionada = selectedLoteria != null ? selectedLoteria.dias.firstWhere((element) => element.id == dia.id, orElse: () => null) : null;
     TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(diaLoteriaSeleccionada != null ? diaLoteriaSeleccionada.horaApertura : dia.horaApertura));
      final now = new DateTime.now();
      if(t == null)
        return;

     setState((){
      //  dia.horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute);
      int idx = selectedLoteria == null ? -1 : selectedLoteria.dias.indexWhere((element) => element.id == dia.id);
      if(idx != -1)
        selectedLoteria.dias[idx].horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute);
     });
     print("_horaAperturaChanged: ${t.format(context)}");
    }

    _horaCierreChanged(Dia dia) async {
    var diaLoteriaSeleccionada = selectedLoteria != null ? selectedLoteria.dias.firstWhere((element) => element.id == dia.id, orElse: () => null) : null;
     TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(diaLoteriaSeleccionada != null ? diaLoteriaSeleccionada.horaCierre : dia.horaCierre));
      if(t == null)
        return;

      final now = new DateTime.now();
     setState((){
      //  dia.horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute);
       int idx = selectedLoteria == null ? -1 : selectedLoteria.dias.indexWhere((element) => element.id == dia.id);
       if(idx != -1)
        selectedLoteria.dias[idx].horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute);
     });
     print("_horaCierreChanged: ${t.format(context)}");
    }


  _horaAperturaTodosChanged() async {
      TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(Utils.dateTimeToDate(DateTime.now(), "01:00"))));
      if(t == null)
        return;
      final now = new DateTime.now();
      if(selectedLoteria == null)
        return;

      if(selectedLoteria.dias.length == 0)
        return;

      selectedLoteria.dias.forEach((element) {
        setState(() => element.horaApertura = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
      });
    }

    _horaCierreTodosChanged() async {
      TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(Utils.dateTimeToDate(DateTime.now(), "23:00"))));
      if(t == null)
        return;
      final now = new DateTime.now();

      if(selectedLoteria == null)
        return;

      if(selectedLoteria.dias.length == 0)
        return;

      selectedLoteria.dias.forEach((element) {
        setState(() => element.horaCierre = new DateTime(now.year, now.month, now.day, t.hour, t.minute));
      });
    }

    _horaAperturaString(Dia dia){
      if(selectedLoteria == null)
        return "";

      int idx = selectedLoteria.dias.indexWhere((element) => element.id == dia.id);
      if(idx == -1)
        return "";

      print("HorariosScreen _horaAperturaString: ${TimeOfDay.fromDateTime(selectedLoteria.dias[idx].horaApertura).format(context)}");
      return TimeOfDay.fromDateTime(selectedLoteria.dias[idx].horaApertura).format(context);
    }

    _horaCierreString(Dia dia){
      if(selectedLoteria == null)
        return "";

      int idx = selectedLoteria.dias.indexWhere((element) => element.id == dia.id);
      if(idx == -1)
        return "";

      print("HorariosScreen _horaCierreString: ${TimeOfDay.fromDateTime(selectedLoteria.dias[idx].horaCierre).format(context)}");
      return TimeOfDay.fromDateTime(selectedLoteria.dias[idx].horaCierre).format(context);
    }

    _minutosExtrasString(Dia dia){
      if(selectedLoteria == null)
        return "Min. extras";

      int idx = selectedLoteria.dias.indexWhere((element) => element.id == dia.id);
      if(idx == -1)
        return "Min. extras";

      print("HorariosScreen _minutosExtrasString: ${selectedLoteria.dias[idx].minutosExtras}");
      return "${selectedLoteria.dias[idx].minutosExtras != null ? selectedLoteria.dias[idx].minutosExtras : 'Min. extras'}";
    }


  _horariosColumnChildren(bool isSmallOrMedium){
    // print("_horariosColumnCHildren isSmallOrMedium: $isSmallOrMedium");
      var children = listaDia.map((e) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isSmallOrMedium ? 20 : 0),
            child: Visibility(
              visible: selectedLoteria.dias.indexWhere((element) => element.id == e.id) != -1,
              child: Wrap(
                alignment: isSmallOrMedium ? WrapAlignment.spaceBetween : WrapAlignment.start,
                crossAxisAlignment: isSmallOrMedium ? WrapCrossAlignment.center : WrapCrossAlignment.start,
                children: [
                  Visibility(
                    visible: isSmallOrMedium,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 8.0 : 0),
                      child: MyResizedContainer( medium: 1, xlarge: 8, child: Text("${e.descripcion}", style: TextStyle(fontSize: isSmallOrMedium ? 20 : null),)),
                    ),
                  ), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 5),
                    child: MyResizedContainer(medium:  3.2, large: 6, xlarge: 9, small: 2.8, child: Container(child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: InkWell(child: Center(child: Text("${_horaAperturaString(e)}", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))), onTap: (){_horaAperturaChanged(e);},),
                    ))),
                  ), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 5),
                    child: MyResizedContainer(medium:  3.2,  xlarge: 9, small: 2.8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: InkWell(child: Center(child: Text("${_horaCierreString(e)}", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),)), onTap: (){_horaCierreChanged(e);},))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 5),
                    child: MyResizedContainer(medium:  3.2,  xlarge: 9, small: 4.0, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2)
                      ),
                      child: InkWell(child: Center(child: Text("${_minutosExtrasString(e)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),)), onTap: (){_horaCierreTodosChanged();},))),
                  )
                ],
              ),
            ),
          )
          ).toList();

        //INSERT CAMPOS PARA CAMBIAR TODOS LOS HORARIOS
        if(selectedLoteria != null){
          if(selectedLoteria.dias.length > 1){
            children.insert(0, Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isSmallOrMedium ? 20 : 0),
              child: Wrap(
                alignment: isSmallOrMedium ? WrapAlignment.spaceBetween : WrapAlignment.start,
                children: [
                  Visibility(
                    visible: isSmallOrMedium,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 8.0 : 0),
                      child: MyResizedContainer( xlarge: 8, medium: 1, child: Text("Cambiar todos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallOrMedium ? 20 : null),)),
                    ),
                  ), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(medium: 3.2, large: 6, xlarge: 9, small: 2.8, child: Container(child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: InkWell(child: Center(child: Text("Todos", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))), onTap: (){_horaAperturaTodosChanged();},),
                    ))),
                  ), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(medium: 3.2,  xlarge: 9, small: 2.8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: InkWell(child: Center(child: Text("Todos", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),)), onTap: (){_horaCierreTodosChanged();},))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0 : 5.0),
                    child: MyResizedContainer(medium: 3.2,  xlarge: 9, small: 4.0, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2)
                      ),
                      child: InkWell(child: Center(child: Text("Todos", style: TextStyle(fontWeight: FontWeight.bold),)), onTap: (){_horaCierreTodosChanged();},))),
                  )
                ],
              ),
            ));

          }
        }
        if(!isSmallOrMedium)
          children.insert(0, Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                  // MyResizedContainer( xlarge: 8, child: Center(child: MySubtitle(title: "Dias",))), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: MyResizedContainer( xlarge: 9, child:  Center(child: MySubtitle(title: "Apertura", mainAxisAlignment: MainAxisAlignment.center,))),
                  ), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: MyResizedContainer( xlarge: 9, child:  Center(child: MySubtitle(title: "Cierre", mainAxisAlignment: MainAxisAlignment.center,))),
                  ), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: MyResizedContainer( xlarge: 9, child:  Center(child: MySubtitle(title: "Min. extras", mainAxisAlignment: MainAxisAlignment.center,))),
                  ), 
              ],
            ),
          ));

        return children;
    }


  _horariosScreen(bool isSmallOrMedium){
      return MyScrollbar(
          child: MyResizedContainer(
          medium: 1,
          large: 1.6,
          xlarge: 2,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: _horariosColumnChildren(isSmallOrMedium),
          ),
        ),
      );
      // return MyTable(
      //   columns: [Center(child: Text("Dias")), Center(child: Text("Apertura")), Center(child: Text("Cierre"))], 
      //   rows: listaDia.map((e) => [e, "${e.descripcion}", InkWell(child: Text("${TimeOfDay.fromDateTime(e.horaApertura).format(context)}"), onTap: (){_horaAperturaChanged(e);},), InkWell(child: Text("${TimeOfDay.fromDateTime(e.horaCierre).format(context)}"), onTap: (){_horaCierreChanged(e);},)]).toList()
      // );
    }

  _diaChanged(bool value, Dia dia){
    if(value){
      if(selectedLoteria == null)
        return;

      if(selectedLoteria.dias.indexWhere((element) => element.id == dia.id) == -1)
        setState(() => selectedLoteria.dias.add(Dia(id: dia.id, descripcion: dia.descripcion, wday: dia.wday, created_at: dia.created_at, horaApertura: dia.horaApertura, horaCierre: dia.horaCierre, minutosExtras: dia.minutosExtras)));
    }else{
      if(selectedLoteria == null)
        return;

      setState(() => selectedLoteria.dias.removeWhere((element) => element.id == dia.id));
    }
  }


  _diasScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    Padding(
      padding: EdgeInsets.only(left: isSmallOrMedium ? 20.0 : 0, right: isSmallOrMedium ? 20.0 : 0, bottom: 5.0),
      child: MyDropdown(
        medium: 1,
        title: "",
        hint: "${selectedLoteria != null ? selectedLoteria.dias.length > 0 ? selectedLoteria.dias.length != listaDia.length ? selectedLoteria.dias.map((e) => e.descripcion).toList().join(", ") : 'Todos los dias' : 'Seleccionar dias...' : 'Seleccionar dias...'}",
        onTap: () async {
          var diasSeleccionadosDynamic = await showDialog(
            context: context, 
            builder: (context){
              return MyMultiselect(
                title: "Selecc. dias",
                items: listaDia.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
                initialSelectedItems: selectedLoteria != null ? selectedLoteria.dias != null ? selectedLoteria.dias.map((e) => MyValue(value: listaDia.firstWhere((element) => element.id == e.id, orElse: () => null), child: "${e.descripcion}")).toList() : [] : [],
              );
            }
          );
    
          if(diasSeleccionadosDynamic == null)
            return;
    
          if(diasSeleccionadosDynamic == null)
            return;
    
          if(diasSeleccionadosDynamic.length == 0){
            setState(() => selectedLoteria.dias = []);
            return;
          }
    
          List<Dia> diasSeleccionados = List<Dia>.from(diasSeleccionadosDynamic);
          diasSeleccionados = diasSeleccionados.map((e) => Dia(
            id: e.id, 
            descripcion: e.descripcion,
            wday: e.wday,
            created_at: e.created_at,
            horaApertura: e.horaApertura,
            horaCierre: e.horaCierre,
            minutosExtras: e.minutosExtras,
          )
          ).toList();
    
          List<Dia> diasSeleccionadosToAdd = [];
          List<Dia> diasSeleccionadosToRemove = [];
          
          for (var dia in diasSeleccionados) {
            if(selectedLoteria.dias.indexWhere((element) => element.id == dia.id) == -1)
              diasSeleccionadosToAdd.add(dia);
          }
          for (var diaLoteria in selectedLoteria.dias) {
            if(diasSeleccionados.indexWhere((e) => e.id == diaLoteria.id) == -1)
              diasSeleccionadosToRemove.add(diaLoteria);
          }
    
          // if(diasSeleccionadosTmp.length > 0)
            setState((){
              selectedLoteria.dias.addAll(diasSeleccionadosToAdd);
              for (var item in diasSeleccionadosToRemove) {
                selectedLoteria.dias.remove(item);
              }
    
              if(selectedLoteria.dias.length > 0)
                selectedLoteria.dias.sort((a, b) => a.id.compareTo(b.id));
            });
        },
      ),
    )
    :
    MyResizedContainer(
      xlarge: 4,
      large: 4,
      child: Column(
        children: listaDia.asMap().map((key, value){
          if(key != 0)
            return MapEntry(key, CheckboxListTile(value: selectedLoteria != null ? selectedLoteria.dias.indexWhere((element) => value.id == element.id) != -1 : false, onChanged: (onChanged){_diaChanged(onChanged, value);}, title: Text("${value.descripcion}"), controlAffinity: ListTileControlAffinity.leading,));
        
          return MapEntry(key, Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: MySubtitle(title: "Dias",),
              ),
              CheckboxListTile(value: selectedLoteria != null ? selectedLoteria.dias.indexWhere((element) => value.id == element.id) != -1 : false, onChanged: (onChanged){_diaChanged(onChanged, value);}, title: Text("${value.descripcion}"), controlAffinity: ListTileControlAffinity.leading,)
            ],
          ));
        }).values.toList(),
      ),
    )
    ;
                
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
      cargando: false, 
      cargandoNotify: _cargandoNotify,
      bottomTap: isSmallOrMedium ? null : _guardar,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: 
          isSmallOrMedium ? 
          SizedBox.shrink() 
          : "Horarios loterias",
          subtitle: isSmallOrMedium ? '' : "Agrega y administra todas tus horarios.",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true, cargandoNotifier: _cargandoNotify,)
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

            return SliverFillRemaining(child: MyScrollbar(
              child: Wrap(children: [
                MyToggleButtons(
                      onTap: (data){
                        var d = listaLoteria.firstWhere((element) => element.id == data, orElse: () => null);
                        setState(() => selectedLoteria = d);
                        // setState(() {
                        //   selectedLoteriaComision = d;
                        //   print("hola comi: ${selectedLoteriaComision.descripcion}");
                        //   var comision = selectedLoteriaComision.id != 0 ? _comisiones.firstWhere((element) => element.idLoteria == selectedLoteriaComision.id) : Comision();
                        //   _txtDirecto.text = comision.directo != null ? "${comision.directo}" : '';
                        //   _txtPale.text = comision.pale != null ? "${comision.pale}" : '';
                        //   _txtTripleta.text = comision.tripleta != null ? "${comision.tripleta}" : '';
                        //   _txtSuperpale.text = comision.superPale != null ? "${comision.superPale}" : '';
                        //   _txtPick3Box.text = comision.pick3Box != null ? "${comision.pick3Box}" : '';
                        //   _txtPick3Straight.text = comision.pick3Straight != null ? "${comision.pick3Straight}" : '';
                        //   _txtPick4Box.text = comision.pick4Box != null ? "${comision.pick4Box}" : '';
                        //   _txtPick4Straight.text = comision.pick4Straight != null ? "${comision.pick4Straight}" : '';
                        //   listaDia.
                        // });
                      },
                      // items: _loterias.map((e) => MyToggleData(value: e, child: e.descripcion)).toList(),
                      items: listaLoteria.map<MyToggleData>((e) => MyToggleData(value: e.id, child: e.descripcion)).toList(),
                      selectedItems: selectedLoteria != null ? [MyToggleData(value: selectedLoteria.id, child: "${selectedLoteria.descripcion}")] : [],
                    ),
                _diasScreen(isSmallOrMedium),
                _horariosScreen(isSmallOrMedium)
              ],),
            ));
          }
        )
      )
    );
  }
}