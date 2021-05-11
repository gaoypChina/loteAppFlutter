import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';

class MyFilterData {
  Color color;
  String text;
  dynamic value;
  dynamic defaultValue;
  final ValueChanged<dynamic> onChanged;
  MyFilterData({@required this.text, @required this.defaultValue, @required this.value, @required this.color, this.onChanged});
}

class MyFilter extends StatefulWidget {
  final int showListNormalCortaLarga;
  final DateTimeRange value;
  final ValueChanged<DateTimeRange> onChanged;
  final EdgeInsets paddingContainer;
  final String filterTitle;
  final List<MyFilterData> data;
  final Function onDeleteAll;
  MyFilter({Key key, @required this.value, @required this.onChanged, this.showListNormalCortaLarga = 1, this.paddingContainer = const EdgeInsets.symmetric(vertical: 10, horizontal: 20), this.filterTitle = "Filtro", this.data = const [], this.onDeleteAll}) : super(key: key);
  @override
  _MyFilterState createState() => _MyFilterState();
}

class _MyFilterState extends State<MyFilter> {
  MyDate _myDate;
  DateTimeRange _fecha;
  List<MyFilterData> _data = [];
  bool _showFilterScreen = false;
  _init(){

    _fecha = widget.value;
    _seleccionarFechaSencillaSiPertenece();
    _fillDataList();
  }

  _fillDataList(){
    _data = [];
    if(_myDate == null)
      _data.insert(0, MyFilterData(color: Utils.colorPrimary, value: MyDate.datesToString(_fecha.start, _fecha.end), defaultValue: MyDate.hoy, text: MyDate.datesToString(_fecha.start, _fecha.end)));
    
    print("_fillDataList: ${MyDate.datesToString(_fecha.start, _fecha.end)}");
    for (var data in widget.data) {
      if(data.value != data.defaultValue)
        _data.add(data);
    }

    _showFilterScreen = (_data.length == 0) ? false : true;
  }

   _fechaChanged(MyDate fecha){
     print("_fechaChanged ${fecha.toString()}");
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
      default:
        var fechas = MyDate.getEsteMes();
        fechaInicial = fechas[0];
        fechaFinal = fechas[1];
        break;
    }
    // _fecha = DateTimeRange(start: fechaInicial, end: fechaFinal);
    widget.onChanged(DateTimeRange(start: fechaInicial, end: fechaFinal));
   }

  _seleccionarFechaSencillaSiPertenece(){
    var myDate = null;
    if(MyDate.isHoy(_fecha.start, _fecha.end))
      myDate = MyDate.hoy;
    else if(MyDate.isAyer(_fecha.start, _fecha.end))
      myDate = MyDate.ayer;
    else if(MyDate.isAnteAyer(_fecha.start, _fecha.end))
      myDate = MyDate.anteayer;
    else if(MyDate.isEstaSemana(_fecha.start, _fecha.end))
      myDate = MyDate.estaSemana;
    else if(MyDate.isSemanaPasada(_fecha.start, _fecha.end))
      myDate = MyDate.laSemanaPasada;
    else if(MyDate.isUltimo2Dias(_fecha.start, _fecha.end))
      myDate = MyDate.ultimos2Dias;
    else if(MyDate.isEsteMes(_fecha.start, _fecha.end))
      myDate = MyDate.esteMes;
    else
      myDate = null;

    print("My_filter _seleccionarFechaSencillas: ${myDate == null}");
    setState(() => _myDate = myDate);
  }

  _getRowOfDates(){
    var listaFecha = [];
    switch (widget.showListNormalCortaLarga) {
      case 1:
        listaFecha = MyDate.listaFecha;
        break;
      case 2:
        listaFecha = MyDate.listaFechaCorta;
        break;
      default:
        listaFecha = MyDate.listaFechaLarga;
        break;
    }

    return Row(
      children: listaFecha.map((e) =>  Padding(
        padding: const EdgeInsets.all(4.0),
        child: MyContainerButton(selected: e[0] == _myDate, data: [e[0], e[1]], onTap: (data){
          setState((){
            _fechaChanged(e[0]);
          });
        },),
      )).toList(),
    );
  }

  _dateFilter(){
    return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
            child: Icon(Icons.date_range, color: Colors.grey,),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:  _getRowOfDates()
              ),
            ),
          ),
        ],
      );
                  
  }

  _filterScreen(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.filterTitle.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${widget.filterTitle}", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
          ),
        ),
        Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
                child: Icon(Icons.filter_alt, color: Colors.grey,),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: 
                    Row(
                      children: _data.map((e) =>  Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: MyContainerButton(
                          padding: widget.paddingContainer,
                          selected: false,
                          data: [e.value, e.text], 
                          icon: Icons.clear,
                          textColor: e.color,
                          borderColor: e.color,
                          iconColor: Colors.pink,
                          onTap: (data){
                            e.onChanged(e.value);
                        },),
                      )).toList(),
                    )
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: (){
                  widget.onDeleteAll();
                },
              )
            ],
          ),
          
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyFilter oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.value != widget.value){
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return _showFilterScreen ? _filterScreen() : _dateFilter();
  }
}