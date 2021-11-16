import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyDateRangeDialog extends StatefulWidget {
  final Function onCancel;
  final Function(dynamic value) onOk;
  final DateTimeRange date;
  final listaFecha;
  final double width;
  MyDateRangeDialog({Key key, @required this.date, this.onCancel, this.onOk, this.listaFecha, this.width = 600}) : super(key: key);
  @override
  _MyDateRangeDialogState createState() => _MyDateRangeDialogState();
}

class _MyDateRangeDialogState extends State<MyDateRangeDialog> {
  DateTimeRange _date;
  MyDate _myDate;
  List<dynamic> _listaFecha;

  setsFields(){
    if(widget.date != _date)
      _date = widget.date;

      _seleccionarFechaSencillaSiPertenece();
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
      case MyDate.anteayer:
        var fechas = MyDate.getAnteAyer();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.ultimos2Dias:
        var fechas = MyDate.getUltimos2Dias();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.estaSemana:
        var fechas = MyDate.getEstaSemana();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.laSemanaPasada:
        var fechas = MyDate.getSemanaPasada();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.esteMes:
        var fechas = MyDate.getEsteMes();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.ultimos30Dias:
        var fechas = MyDate.getUltimos30Dias();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porDosDias:
        var fechas = MyDate.getPorDosDias();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porTresDias:
        var fechas = MyDate.getPorTresDias();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porTresDias:
        var fechas = MyDate.getPorTresDias();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porUnaSemana:
        var fechas = MyDate.getPorUnaSemana();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porDosSemanas:
        var fechas = MyDate.getPorDosSemanas();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porUnMes:
        var fechas = MyDate.getPorUnMes();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porTresMeses:
        var fechas = MyDate.getPorTresMeses();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      case MyDate.porUnAno:
        var fechas = MyDate.getPorUnAno();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
      default:
        var fechas = MyDate.getSemanaPasada();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
    }

    // setState(() {
    //   _myDate = fecha;
    //   _date = DateTimeRange(start: fechaInicial, end: fechaFinal);
    //   _fechaFinal = fechaFinal;
    // });
      _myDate = fecha;
      _date = DateTimeRange(start: fechaInicial, end: fechaFinal);
  }
 

  _seleccionarFechaSencillaSiPertenece(){
    var myDate = null;
    if(MyDate.isHoy(_date.start, _date.end))
      myDate = MyDate.hoy;
    else if(MyDate.isAyer(_date.start, _date.end))
      myDate = MyDate.ayer;
    else if(MyDate.isAnteAyer(_date.start, _date.end))
      myDate = MyDate.anteayer;
    else if(MyDate.isEstaSemana(_date.start, _date.end))
      myDate = MyDate.estaSemana;
    else if(MyDate.isSemanaPasada(_date.start, _date.end))
      myDate = MyDate.laSemanaPasada;
    else if(MyDate.isUltimo2Dias(_date.start, _date.end))
      myDate = MyDate.ultimos2Dias;
    else if(MyDate.isEsteMes(_date.start, _date.end))
      myDate = MyDate.esteMes;
    else if(MyDate.isUltimos30Dias(_date.start, _date.end))
      myDate = MyDate.ultimos30Dias;
    else if(MyDate.isPorDosDias(_date.start, _date.end))
      myDate = MyDate.porDosDias;
    else if(MyDate.isPorTresDias(_date.start, _date.end))
      myDate = MyDate.porTresDias;
    else if(MyDate.isPorUnaSemana(_date.start, _date.end))
      myDate = MyDate.porUnaSemana;
    else if(MyDate.isPorDosSemanas(_date.start, _date.end))
      myDate = MyDate.porDosSemanas;
    else if(MyDate.isPorUnMes(_date.start, _date.end))
      myDate = MyDate.porUnMes;
    else if(MyDate.isPorTresMeses(_date.start, _date.end))
      myDate = MyDate.porTresMeses;
    else if(MyDate.isPorUnAno(_date.start, _date.end))
      myDate = MyDate.porUnAno;
    else
      myDate = null;

    print("My_filter _seleccionarFechaSencillas: ${myDate == null}");
    setState(() => _myDate = myDate);
  }

  @override
  void initState() {
    // TODO: implement initState
    setsFields();
    _listaFecha = widget.listaFecha == null ? MyDate.listaFechaLarga : widget.listaFecha;
    super.initState();
  }

  
  @override
  void didUpdateWidget(covariant MyDateRangeDialog oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.date != widget.date){
      setsFields();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      // height: 500,
      // color: Colors.black,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black, width: 0.3))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _listaFecha.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                child: InkWell(
                  onTap: (){
                    _fechaChanged(e[0]);
                    widget.onOk(_date);},
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: e[0] == _myDate ? Theme.of(context).primaryColor : null,
                    ),
                    child: Text("${e[1]}", style: TextStyle(color: e[0] == _myDate ? Colors.white : null),)),
                ),
              )).toList(),
            ),
          ),
          // VerticalDivider(),
          Expanded(
            child: Theme(
              data: ThemeData(),
              child: SfDateRangePicker(
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args){print("SfDateRangePicker: ${args.value}");},
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                initialSelectedRange: widget.date != null ? PickerDateRange(widget.date.start, widget.date.end) : null,
                onSubmit: (date){
                  if(date is PickerDateRange){
                    var _fechaInicial = (date.startDate != null) ? DateTime.parse("${date.startDate.year}-${Utils.toDosDigitos(date.startDate.month.toString())}-${Utils.toDosDigitos(date.startDate.day.toString())} 00:00:00") : null;
                    var _fechaFinal = (date.endDate != null) ? DateTime.parse("${date.endDate.year}-${Utils.toDosDigitos(date.endDate.month.toString())}-${Utils.toDosDigitos(date.endDate.day.toString())} 23:59:59") : null;
                    if(_fechaInicial != null && _fechaFinal == null)
                      _fechaFinal = (date.startDate != null) ? DateTime.parse("${date.startDate.year}-${Utils.toDosDigitos(date.startDate.month.toString())}-${Utils.toDosDigitos(date.startDate.day.toString())} 23:59:59") : null;
                    widget.onOk(DateTimeRange(start: _fechaInicial, end: _fechaFinal));
                  }
                },
                onCancel: widget.onCancel,
                // initialSelectedRange: PickerDateRange(_date.start, _date.end)
                // selectionColor: Theme.of(context).primaryColor,
                // co
              ),
            ),
          ),
        ],
      )
      // Theme(
      //   data: ThemeData(accentColor: Colors.black), 
      //   child: DateRangePickerDialog(
      //   initialDateRange: _date,
      //   firstDate: DateTime.now().subtract(Duration(days: 365 * 5)), 
      //   lastDate: DateTime.now().add(Duration(days: 365 * 2)),
        
      // ),
      // )
      
    );
                        
  }
}