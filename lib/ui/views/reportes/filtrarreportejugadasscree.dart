import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/main.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';

class FiltrarReporteJugadasScreen extends StatefulWidget {
  final List<Loteria> loterias;
  final Loteria loteriaSeleccionada;
  final DateTime fechaInicial;
  final DateTime fechaFinal;
  final MyDate fechaSelecionada;
  final List<Draws> sorteos;
  final Draws sorteoSeleccionado;
  final String jugada;
  final int limiteSeleccionado;
  FiltrarReporteJugadasScreen({Key key, @required this.loteriaSeleccionada, @required this.loterias, @required this.fechaSelecionada, @required this.fechaInicial, @required this.fechaFinal, @required this.sorteoSeleccionado, @required this.sorteos, @required this.jugada, this.limiteSeleccionado}) :  super(key: key);
  @override
  _FiltrarReporteJugadasScreenState createState() => _FiltrarReporteJugadasScreenState();
}

class _FiltrarReporteJugadasScreenState extends State<FiltrarReporteJugadasScreen> {
  DateFormat _dateFormat;
  Loteria _loteria;
  Draws _sorteo;
  DateTime _fechaActual = DateTime.now();
  MyDate _fecha;
  DateTime _fechaInicial;
  DateTime _fechaFinal;
  var _txtJugada = TextEditingController();
  List<int> listaLimite = [10, 20, 30, 40, 50];
  int _limite;

  _filtrar(){
    var map = {
      "jugada" : (_txtJugada.text.isNotEmpty) ? _txtJugada.text : null,
      "sorteo" : _sorteo,
      "loteria" : _loteria,
      "fecha" : _fecha,
      "fechaInicial" : _fechaInicial,
      "fechaFinal" : _fechaFinal,
      "limite" : _limite,
    };

    Navigator.pop(context, map);
  }

  _loteriaChanged(loteria){
    setState(() => _loteria = loteria);
  }

  _sorteoChanged(sorteo){
    setState(() => _sorteo = sorteo);
  }

  _limiteChanged(limite){
    setState(() => _limite = limite);
  }

  _showLoteria() async {
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
            loteriaChanged(loteria){
              setState(() => _loteria = loteria);
              _loteriaChanged(loteria);
              _back();
            }
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.loterias.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _loteria == widget.loterias[index],
                          onChanged: (data){
                            loteriaChanged(widget.loterias[index]);
                          },
                          title: Text("${widget.loterias[index].descripcion}"),
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
            sorteoChange(sorteo){
              setState(() => _sorteo = sorteo);
              _sorteoChanged(sorteo);
              _back();
            }
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.sorteos.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _sorteo == widget.sorteos[index],
                          onChanged: (data){
                            sorteoChange(widget.sorteos[index]);
                          },
                          title: Text("${widget.sorteos[index].descripcion}"),
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

  
  _showLimites() async {
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
            limiteChange(limite){
              setState(() => _limite = limite);
              _limiteChanged(limite);
              _back();
            }
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaLimite.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _limite == listaLimite[index],
                          onChanged: (data){
                            limiteChange(listaLimite[index]);
                          },
                          title: Text("${listaLimite[index]} registros por sorteo"),
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

  

 
  _fechaChanged(MyDate fecha){
    var fechaInicial;
    var fechaFinal;
    switch (fecha) {
      case MyDate.hoy:
        var fechas = MyDate.getHoy();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.ayer:
        var fechas = MyDate.getAyer();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.estaSemana:
        var fechas = MyDate.getEstaSemana();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      default:
        var fechas = MyDate.getSemanaPasada();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
    }

    setState(() {
      _fecha = fecha;
      _fechaInicial = fechaInicial;
      _fechaFinal = fechaFinal;
    });
  }
 
  _seleccionarFechaSencillaSiPertenece(){
    if(MyDate.isHoy(_fechaInicial, _fechaFinal))
      _fecha = MyDate.hoy;
    else if(MyDate.isAyer(_fechaInicial, _fechaFinal))
      _fecha = MyDate.ayer;
    else if(MyDate.isEstaSemana(_fechaInicial, _fechaFinal))
      _fecha = MyDate.estaSemana;
    else if(MyDate.isSemanaPasada(_fechaInicial, _fechaFinal))
      _fecha = MyDate.laSemanaPasada;
    else
      _fecha = null;

  }

  _fechaInicialChanged() async {
    DateTime fecha = await showDatePicker(context: context, initialDate: _fechaInicial, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if(fecha == null)
      return;
    
    if(_fechaInicial != fecha)
      setState(() {
        _fechaInicial = (fecha != null) ? fecha : _fechaInicial;
        _seleccionarFechaSencillaSiPertenece();
      });

  }

  _fechaFinalChanged() async {
    
    DateTime fecha = await showDatePicker(context: context, initialDate: _fechaFinal, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if(fecha == null)
      return;
    
    if(_fechaFinal != fecha)
      setState(() {
        _fechaFinal = (fecha != null) ? DateTime.parse("${fecha.year}-${Utils.toDosDigitos(fecha.month.toString())}-${Utils.toDosDigitos(fecha.day.toString())} 23:59:59") : _fechaFinal;
        _seleccionarFechaSencillaSiPertenece();
      });

  }


  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    // initializeDateFormatting("es_ES", null).then((_) => null);
    initializeDateFormatting();
    // _dateFormat = new DateFormat.yMMMMd(MyApp.myLocale.languageCode);
    _dateFormat = new DateFormat.yMMMMEEEEd(MyApp.myLocale.languageCode);
    _loteria = (widget.loteriaSeleccionada != null) ? widget.loteriaSeleccionada : widget.loterias[0];
    _sorteo = (widget.sorteoSeleccionado != null) ? widget.sorteoSeleccionado : widget.sorteos[0];
    _fecha = widget.fechaSelecionada;
    _fechaInicial = widget.fechaInicial;
    _fechaFinal = widget.fechaFinal;
    _txtJugada.text = widget.jugada;
    _limite = widget.limiteSeleccionado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear,),
            color: Utils.colorPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          
          title: Text("Ajustar filtros", style: TextStyle( color: Colors.black, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
              IconButton(icon: Icon(Icons.save_rounded, size: 28,), onPressed: _filtrar, color: Utils.colorPrimary,),
             
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
        
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView(children: [
              ListTile(
                leading: Icon(Icons.label),
                // title: Align(alignment: Alignment.centerLeft,child: MyContainerButton(data: [null, "Loteria"], onTap: (data){})),
                title: Row(
                    children: [
                      Text("${_loteria != null ? _loteria.descripcion : 'No hay loterias'}", style: TextStyle(fontSize: 18, color: Colors.black),),
                      Icon(Icons.arrow_drop_down, color: Colors.black54,)
                    ],
                  ),
                  onTap: _showLoteria,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(thickness: 1,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                  Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: 
                              Row(
                                children: MyDate.listaFecha.map((e) =>  Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: MyContainerButton(selected: e[0] == _fecha, data: [e[0], e[1]], onTap: (data){
                                      _fechaChanged(e[0]);
                                  },),
                                )).toList(),
                              ),
                              // Row(
                              //   children: [
                              //     Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(selected: _fecha, data: ["Hoy", "Hoy"], onTap: (data){
                              //       print("$data");
                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["Esta semana", "Esta semana"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["La semana pasada", "La semana pasada"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   ],
                              // ),
                              
                              // children: [
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                              //       print("$data");
                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: SizedBox(),
                      onTap: _fechaInicialChanged,
                      title: Text("${_dateFormat != null ? _dateFormat.format(_fechaInicial) : DateFormat('EEE, MMM d yyy').format(_fechaFinal)}"),
                    ),
                    ListTile(
                      leading: SizedBox(),
                      onTap: _fechaFinalChanged,
                      title: Text("${_dateFormat != null ? _dateFormat.format(_fechaFinal) : DateFormat('EEE, MMM d yyy').format(_fechaFinal)}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(thickness: 1,),
                    ),
                  ListTile(
                      leading: Icon(Icons.format_list_numbered_rounded),
                      title: TextFormField(
                        controller: _txtJugada,
                        autofocus: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Filtra por jugada"
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(thickness: 1,),
                    ),
                     ListTile(
                      leading: Icon(Icons.confirmation_number_outlined),
                      title: Align(alignment: Alignment.centerLeft, child: MyContainerButton(data: [_sorteo, "${_sorteo != null ? _sorteo.descripcion : 'Ninguno'}"], onTap: (data){_showSorteos();})),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(thickness: 1,),
                    ),
                     ListTile(
                      leading: Icon(Icons.stop_circle),
                      title: Align(alignment: Alignment.centerLeft, child: MyContainerButton(data: [_limite, "$_limite registros por sorteo"], textColor: Utils.colorPrimary, borderColor: Colors.grey, onTap: (data){_showLimites();})),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(thickness: 1,),
                    ),
                ],
              ),
            
            ],),
          )
        ),
    );
  }
}