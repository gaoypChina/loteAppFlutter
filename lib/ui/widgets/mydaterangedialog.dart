import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mycirclebutton.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyDateRangeDialog extends StatefulWidget {
  final Function onCancel;
  final Function(dynamic value) onOk;
  final dynamic date;
  final listaFecha;
  final double width;
  final DateRangePickerSelectionMode selectionMode;
  final bool showLeftStringDate;
  final bool isSimpleDialog;
  MyDateRangeDialog({Key key, @required this.date, this.onCancel, this.onOk, this.listaFecha, this.width = 600, this.selectionMode = DateRangePickerSelectionMode.range, this.showLeftStringDate = true, this.isSimpleDialog = false}) : super(key: key);
  @override
  _MyDateRangeDialogState createState() => _MyDateRangeDialogState();
}

class _MyDateRangeDialogState extends State<MyDateRangeDialog> {
  dynamic _date;
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
    var myDate;
    
    if(widget.selectionMode !=  DateRangePickerSelectionMode.range)
      return;
      
    if(_date == null)
      myDate = _date;
    else if(MyDate.isHoy(_date.start, _date.end))
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

  _myDateWidget(){
    return Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black, width: 0.3))
      ),
      child: SingleChildScrollView(
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
    );
  }

  _screen(){
    return Container(
      width: widget.width,
      // height: 500,
      // color: Colors.black,
      child: Row(
        children: [
         Visibility(visible: widget.showLeftStringDate, child:  _myDateWidget()),
          // VerticalDivider(),
          widget.isSimpleDialog
          ?
          Expanded(child: _simpleDates())
          :
          Expanded(
            child: Theme(
              data: ThemeData(),
              child: SfDateRangePicker(
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args){print("SfDateRangePicker: ${args.value}");},
                selectionMode: widget.selectionMode,
                showActionButtons: true,
                initialSelectedDates: widget.selectionMode == DateRangePickerSelectionMode.multiple ? widget.date != null ? widget.date is List<DateTime> ? widget.date : [] : [] : [],
                initialSelectedRange: widget.selectionMode == DateRangePickerSelectionMode.range ? widget.date != null ? PickerDateRange(widget.date.start, widget.date.end) : null : null,
                onSubmit: (date){
                  if(date is PickerDateRange){
                    var _fechaInicial = (date.startDate != null) ? DateTime.parse("${date.startDate.year}-${Utils.toDosDigitos(date.startDate.month.toString())}-${Utils.toDosDigitos(date.startDate.day.toString())} 00:00:00") : null;
                    var _fechaFinal = (date.endDate != null) ? DateTime.parse("${date.endDate.year}-${Utils.toDosDigitos(date.endDate.month.toString())}-${Utils.toDosDigitos(date.endDate.day.toString())} 23:59:59") : null;
                    if(_fechaInicial != null && _fechaFinal == null)
                      _fechaFinal = (date.startDate != null) ? DateTime.parse("${date.startDate.year}-${Utils.toDosDigitos(date.startDate.month.toString())}-${Utils.toDosDigitos(date.startDate.day.toString())} 23:59:59") : null;
                    widget.onOk(DateTimeRange(start: _fechaInicial, end: _fechaFinal));
                  }
                  if(date is List<DateTime>)
                    widget.onOk(date);
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

  Widget _simpleDates(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: MyResizedContainer(small: 1.7, child: MySubtitle(title: "Desde", fontSize: 14, padding: EdgeInsets.symmetric(vertical: 5.0),)),
        ),
        // MyCircleButton(
        //   child: MyDate.dateRangeToNameOrString(_date), 
        //   onTap: _fechaInicialChanged,
        // ),
        InkWell(
           child: MyResizedContainer(
            small: 1.7,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Center(child: Text(MyDate.dateRangeToNameOrString(DateTimeRange(start: MyDate.toFechaInicial(_date.start), end: MyDate.toFechaFinal(_date.start))),)), 
            )
           ),
          onTap: _fechaInicialChanged
         ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: MyResizedContainer(small: 1.7, child: MySubtitle(title: "Hasta", fontSize: 14, padding: EdgeInsets.symmetric(vertical: 5.0))),
        ),
         InkWell(
           child: MyResizedContainer(
            small: 1.7,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Center(child: Text(MyDate.dateRangeToNameOrString(DateTimeRange(start: MyDate.toFechaInicial(_date.end), end: MyDate.toFechaFinal(_date.end))),)), 
            )
           ),
          onTap: _fechaFinalChanged
         ),
         Expanded(
           child: Padding(
             padding: const EdgeInsets.only(bottom: 12.0),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(onPressed: widget.onCancel, child: Text("Cancelar", style: TextStyle(color: Colors.grey),)),
                TextButton(onPressed: (){widget.onOk(_date);}, child: Text("Ok",)),
              ],
             ),
           ),
         )
      ],
    );
  }

  _fechaInicialChanged() async {
    print("Hola");
    var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));
    if(date == null)
      return;


    if(date != null && date is DateTime)
      setState(() {
        _date = DateTimeRange(
          start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
          end: DateTime.parse("${_date.end.year}-${Utils.toDosDigitos(_date.end.month.toString())}-${Utils.toDosDigitos(_date.end.day.toString())} 23:59:59")
        );
      });

  }

  _fechaFinalChanged() async {
    print("Mydaterangedialog _fechaFinalChanged: Hola");
    var date = await showDatePicker(context: context, initialDate: _date.end, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));
    if(date == null)
      return;


    if(date != null && date is DateTime)
      setState(() {
        _date = DateTimeRange(
          start: DateTime.parse("${_date.start.year}-${Utils.toDosDigitos(_date.start.month.toString())}-${Utils.toDosDigitos(_date.start.day.toString())} 00:00"),
          end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
        );
      });

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
    return _screen();           
  }
}