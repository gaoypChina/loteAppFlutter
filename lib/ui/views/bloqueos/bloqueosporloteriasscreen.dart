import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bloqueosservice.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';

class BloqueosPorLoteriasScreen extends StatefulWidget {
  const BloqueosPorLoteriasScreen({ Key key }) : super(key: key);

  @override
  _BloqueosPorLoteriasScreenState createState() => _BloqueosPorLoteriasScreenState();
}

class _BloqueosPorLoteriasScreenState extends State<BloqueosPorLoteriasScreen> {
  Future _future;
  List<Banca> listaBanca = [];
  List<Loteria> listaLoteria = [];
  List<Draws> listaSorteo = [];
  List<Dia> listaDia = [];
  List<Moneda> listaMoneda = [];
  List<String> listaTipo = ["General", "Por banca"];
  String _selectedTipo = "General";
  Moneda _selectedMoneda;
  List<Banca> _bancas = [];
  List<Dia> _dias = [];
  List<Loteria> _loterias = [];
  List<Draws> _sorteos = [];
  bool _descontarDelBloqueoGeneral = true;
  var _cargandoNotify = ValueNotifier<bool>(false);


  _init() async {
    var parsed = await BloqueosService.index(context: context);
    listaBanca = (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((json) => Draws.fromMap(json)).toList() : [];
    listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];

    if(listaMoneda.length > 0)
      _selectedMoneda = listaMoneda[0];

    if(listaDia.length > 0)
      _dias = List.from(listaDia);

    print("BloqueosPorLoteriaScreen: ${parsed}");
  }

  _guardar() async {
    if(_selectedTipo == "Por banca" && _bancas.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay bancas seleccionadas");
      return;
    }

    if(_loterias.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay loterias seleccionadas");
      return;
    }

    _sorteos = listaSorteo.where((element) => element.monto != null).toList();    

    if(_sorteos.length == 0){
      Utils.showAlertDialog(context: context, title: "Error", content: "No hay campos llenos");
      return;
    }

    _cargandoNotify.value = true;

    try {
      var parsed;
       if(_selectedTipo == "Por banca")
        parsed = await BloqueosService.guardar(context: context, bancas: _bancas, dias: _dias, loterias: _loterias, sorteos: _sorteos, descontarDelBloqueoGeneral: _descontarDelBloqueoGeneral, moneda: _selectedMoneda);
      else
        parsed = await BloqueosService.guardarGeneral(context: context, dias: _dias, loterias: _loterias, sorteos: _sorteos, moneda: _selectedMoneda);

      setState(() {
        _bancas = [];
        _loterias = [];
        _sorteos = [];
        _dias = List.from(listaDia);
        for (var sorteo in listaSorteo) {
          sorteo.monto = null;
        }
      });
      Utils.showAlertDialog(context: context, title: "Correctamente", content: "Se ha guardado correctamente");
      _cargandoNotify.value = false;
    } on Exception catch (e) {
      _cargandoNotify.value = false;
    }

  }

  _tipoChanged(value){
    setState(() => _selectedTipo = value);
  }

  _monedaChanged(value){
    setState(() => _selectedMoneda = value);
  }

  _diaChanged(Dia dia){
    int index = listaDia.indexWhere((element) => element.id == dia.id);
    if(index == -1)
      setState(() => _dias.add(dia));
    else
      setState(() => _dias.remove(dia));
  }

  _descontarDelBloqueoGeneralChanged(value){
    setState(() => _descontarDelBloqueoGeneral = value);
  }

  _bancasChanged() async {
    var dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar bancas",
          items: listaBanca.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    if(dataRetornada != null)
      setState(() => _bancas = List.from(dataRetornada));
  }

  _diasChanged() async {
    var dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar dias",
          items: listaDia.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: _dias.length == 0 ? [] : _dias.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    if(dataRetornada != null)
      setState(() => _dias = List.from(dataRetornada));
  }

  _loteriasChanged() async {
    var dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar loterias",
          items: listaLoteria.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: _loterias.length == 0 ? [] : _loterias.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    if(dataRetornada != null)
      setState(() => _loterias = List.from(dataRetornada));
  }

  _getSorteoAbreviatura(String descripcion){
    List<String> arrayOfString =descripcion.split(" ");
    String abreviatura = "";
    for (var item in arrayOfString) {
      abreviatura += item.substring(0, 1);
    }
    return abreviatura;
  }

  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      cargando: false,
      cargandoNotify: _cargandoNotify,
      isSliverAppBar: true,
      bottomTap: isSmallOrMedium ? null : _guardar,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Reglas",
          subtitle: "",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, showOnlyOnSmall: true,)
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(),),
              );
            else
              return SliverList(delegate: SliverChildListDelegate([
                // Center(
                //   child: MyResizedContainer(
                //     xlarge: 2,
                //     large: 2,
                //     medium: 1.5,
                //     child: Wrap(
                //       children: [
                //         MyDropdownButton(
                //           isSideTitle: true,
                //           title: "Tipo regla",
                //           value: _selectedTipo,
                //           items: listaTipo.map((e) => [e, e]).toList(),
                //           onChanged: _tipoChanged
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyDropdownButton(
                    leading: isSmallOrMedium ? Icon(Icons.article) : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                    title: isSmallOrMedium ? "" : "Tipo regla del bloqueo *",
                    value: _selectedTipo,
                    items: listaTipo.map((e) => [e, e]).toList(),
                    onChanged: _tipoChanged,
                    helperText: isSmallOrMedium ? null : "${_selectedTipo == 'General' ? 'Aplicara el bloqueo a todas las bancas sin distinción.' : 'Se aplicara el bloqueo solo a las bancas selccionadas'}",
                  ),
                ),
                MyDivider(showOnlyOnSmall: true,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                  child: MyDropdownButton(
                    leading: isSmallOrMedium ? Icon(Icons.attach_money) : null,
                    isSideTitle: isSmallOrMedium ? false : true,
                    type: isSmallOrMedium ? MyDropdownType.noBorder : MyDropdownType.border,
                    title: isSmallOrMedium ? "" : "Moneda del bloqueo *",
                    value: _selectedMoneda,
                    items: listaMoneda.map((e) => [e, e.descripcion]).toList(),
                    onChanged: _monedaChanged,
                    helperText: isSmallOrMedium ? null : "Solo se aplicara a las bancas que pertenezcan a la moneda seleccionada. las demas seran ignoradas",
                  ),
                ),
                MyDivider(showOnlyOnSmall: true,),
                Visibility(
                  visible: _selectedTipo == "Por banca",
                  child: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: isSmallOrMedium ? 0 : 15.0),
                        child: 
                        isSmallOrMedium
                        ?
                        ListTile(
                          leading: Icon(Icons.account_balance),
                          title: Text("${_bancas.length > 0 ? _bancas.length != listaBanca.length ? _bancas.map((e) => e.descripcion).toList().join(", ") : 'Todas las bancas' : 'Seleccionar las bancas...'}"),
                          onTap: _bancasChanged,
                        )
                        :
                        MyDropdown(
                          xlarge: 1.35,
                          medium: 1,
                          small: 1,
                          isSideTitle: true,
                          title: "Bancas del bloqueo *",
                          helperText: "Seran las bancas afectadas por el bloqueo deseado",
                          hint: "${_bancas.length > 0 ? _bancas.map((e) => e.descripcion).toList().join(", ") : 'Seleccionar las bancas...'}",
                          onTap: _bancasChanged,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: 
                        isSmallOrMedium
                        ?
                        MySwitch(title: "Descontar del bloqueo general", value: _descontarDelBloqueoGeneral, onChanged: _descontarDelBloqueoGeneralChanged, leading: Icon(Icons.local_offer), small: 1, medium: 1,)
                        :
                        MyCheckBox(
                          xlarge: 1.35,
                          medium: 1,
                          small: 1,
                          isSideTitle: true,
                          title: "Descontar",
                          titleSideCheckBox: "Descontar del bloqueo general",
                          helperText: "El monto se descontará del monto del bloqueo general. De no marcar esta casilla pues las bancas seleccionadas tendran un bloqueo aparte del bloqueo general",
                          value: _descontarDelBloqueoGeneral,
                          onChanged: _descontarDelBloqueoGeneralChanged,
                        ),
                      ),
                      MyDivider(showOnlyOnSmall: true,)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: 
                  isSmallOrMedium
                  ?
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text("${_dias.length > 0 ? _dias.length != listaDia.length ? _dias.map((e) => e.descripcion).toList().join(", ") : 'Todos los dias' : 'Seleccionar dias...'}"),
                    onTap: _diasChanged,
                  )
                  :
                  MyDropdown(
                    xlarge: 1.35,
                    medium: 1,
                    small: 1,
                    isSideTitle: true,
                    color: Colors.white,
                    onlyBorder: true,
                    textColor: Colors.black,
                    title: "Dias del bloqueo *",
                    helperText: "Seran los dias afectadas por el bloqueo deseado",
                    hint: "${_dias.length > 0 ? _dias.length != listaDia.length ? _dias.map((e) => e.descripcion).toList().join(", ") : 'Todos los dias' : 'Seleccionar dias...'}",
                    onTap: _diasChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: 
                  isSmallOrMedium
                  ?
                  ListTile(
                    leading: Icon(Icons.sports_golf),
                    title: Text("${_loterias.length > 0 ? _loterias.length != listaLoteria.length ? _loterias.map((e) => e.descripcion).toList().join(", ") : 'Todas las loterias' : 'Seleccionar loterias...'}"),
                    onTap: _loteriasChanged,
                  )
                  :
                  MyDropdown(
                    xlarge: 1.35,
                    medium: 1,
                    small: 1,
                    isSideTitle: true,
                    title: "Loterias del bloqueo *",
                    helperText: "Seran las loterias afectadas por el bloqueo deseado",
                    hint: "${_loterias.length > 0 ? _loterias.length != listaLoteria.length ? _loterias.map((e) => e.descripcion).toList().join(", ") : 'Todas las loterias' : 'Seleccionar loterias...'}",
                    onTap: _loteriasChanged,
                  ),
                ),

                MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 15),),
                MyDivider(showOnlyOnSmall: true,),
                Wrap(
                  children: [
                    // MyResizedContainer(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       MySubtitle(title: "Dias", showOnlyOnLarge: true,),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: listaDia.map((e) => CheckboxListTile(controlAffinity: ListTileControlAffinity.leading, title: Text(e.descripcion),value: _dias.indexWhere((element) => element.id == e.id) != -1,onChanged: (value){_diaChanged(e);},)).toList(),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    MySubtitle(title: "Sorteos", padding: EdgeInsets.only(top: 15, bottom: 8), showOnlyOnLarge: true,),
                    Visibility(
                      visible: !isSmallOrMedium,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: MyDescripcon(title: "Llena los sorteos que desea bloquear, solo los campos llenos serán bloqueados.", fontSize: 14,),
                      ),
                    ),
                    Column(
                      children: listaSorteo.map((e){
                      var controller = TextEditingController();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: MyTextFormField(
                            medium: 1,
                            small: 1,
                            leading: isSmallOrMedium ? Text(_getSorteoAbreviatura(e.descripcion)) : null,
                            isSideTitle: isSmallOrMedium ? false : true,
                            title: isSmallOrMedium ? "" : e.descripcion,
                            hint: isSmallOrMedium ? e.descripcion : "",
                            type: isSmallOrMedium ? MyType.noBorder : MyType.border,
                            controller: controller,
                            isDigitOnly: true,
                            onChanged: (data){
                              e.monto = Utils.toDouble(data);
                            },
                          ),
                      );
                    }).toList(),
                    )
                  ],
                )
                
              ]));
          }
        )
      )
    );
  }
}