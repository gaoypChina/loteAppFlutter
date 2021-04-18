import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/ajustesservice.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';

class AjustesScreen extends StatefulWidget {
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _txtConsorcio = TextEditingController();
  bool _cargando = false;
  Future _future;
  List<Tipo> listaTipo = [];
  Ajuste _ajuste;
  Tipo _tipo;
  bool _imprimirNombreConsorcio = true;
  
  Future _init() async{
    var parsed = await AjustesService.index(scaffoldKey: _scaffoldKey);
    _setAllFields(parsed);
    print("AjustesScreen _init cargo: $parsed");
  }

  _setAllFields(var parsed){
    _ajuste = (parsed["data"] != null) ? Ajuste.fromMap(parsed["data"]) : null;
    _txtConsorcio.text = (_ajuste != null) ? _ajuste.consorcio : null;
    listaTipo = parsed["tipos"].map<Tipo>((e) => Tipo.fromMap(e)).toList();
    _tipo = (_ajuste != null) ? listaTipo.firstWhere((element) => element.id == _ajuste.tipoFormatoTicket.id) : listaTipo[0];
    _imprimirNombreConsorcio = (_ajuste != null) ? _ajuste.imprimirNombreConsorcio == 1 : true; 
  }

  _guardar() async {
    try {
      setState(() => _cargando = true);
      _ajuste.consorcio = _txtConsorcio.text;
      _ajuste.tipoFormatoTicket = _tipo;
      _ajuste.imprimirNombreConsorcio = (_imprimirNombreConsorcio) ? 1 : 0;
      var parsed = await AjustesService.guardar(scaffoldKey: _scaffoldKey, ajuste: _ajuste);
      _ajuste = parsed;
      setState(() => _cargando = false);
      Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Se ha guardado correctamente");
    } on Exception catch (e) {
          // TODO
      setState(() => _cargando = false);
    }
  }

  _tipoChanged(sorteo){
    setState(() => _tipo = sorteo);
  }

  _showSorteos() async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            _back(){
              Navigator.pop(context);
            }
            tipoChange(tipo){
              setState(() => _tipo = tipo);
              _tipoChanged(tipo);
              _back();
            }
            return Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaTipo.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _tipo == listaTipo[index],
                          onChanged: (data){
                            tipoChange(listaTipo[index]);
                          },
                          title: Text("${listaTipo[index].descripcion}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  _imprimirNombreConsorcioChanged(value){
    setState(() => _imprimirNombreConsorcio = value);
  }

  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear,),
            color: Utils.colorPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          
          title: Text("Ajustes", style: TextStyle( color: Colors.black, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
             Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Visibility(
                        visible: _cargando,
                        child: Theme(
                          data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                          child: new CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(icon: Icon(Icons.save_rounded, size: 28,), onPressed: _guardar, color: Utils.colorPrimary,),

            //  Padding(
            //    padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //    child: Container(
            //      child: Center(
            //        child: ElevatedButton(
            //           onPressed: _filtrar, 
            //           child: Text("Filtrar", style: TextStyle(letterSpacing: 1.2),),
            //           style: ElevatedButton.styleFrom(
            //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //             primary: Utils.colorPrimary
            //           ),
            //         ),
            //      ),
            //    ),
            //  ) 
              // ElevatedButton(child: Text("Guardar"), 
              // onPressed: _guardar,
              // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utils.colorPrimary)),)
          ],
        ),
       body: FutureBuilder<void>(
         future: _future,
         builder: (context, snapshot) {
           print("_futureBUildeer snapshot: ${snapshot.hasData} : ${snapshot.connectionState}");
           if(snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());

           return SafeArea(child: ListView(
             children: [
               ListTile(
                 leading: SizedBox(),
                 title: TextFormField(
                   controller: _txtConsorcio,
                   keyboardType: TextInputType.multiline,
                   maxLines: null,
                   style: TextStyle(fontSize: 24),
                   decoration: InputDecoration(
                     hintStyle: TextStyle(fontSize: 24),
                     hintText: "Agregar consorcio",
                     border: InputBorder.none
                   ),
                 ),
               ),
               Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
                // SwitchListTile(
                //   // leading: Icon(Icons.print_rounded),
                //   title: Text("Imprimir nombre consorcio"),
                //   value: true,
                //   onChanged: (value){},
                // ),
                ListTile(
                  leading: Icon(Icons.print_rounded),
                  title: Text("Imprimir consorcio"),
                  trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirNombreConsorcio, onChanged: _imprimirNombreConsorcioChanged),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
                 ListTile(
                  leading: Icon(Icons.confirmation_number_outlined),
                  trailing: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.pink,), onPressed: (){}),
                  title: Align(alignment: Alignment.centerLeft, child: MyContainerButton(data: [_tipo, "${_tipo != null ? _tipo.descripcion : 'Ninguno'}"], onTap: (data){_showSorteos();})),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
             ],
           ));
         }
       ),
    );
  }
}