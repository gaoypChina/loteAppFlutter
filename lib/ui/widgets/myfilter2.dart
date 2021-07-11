import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';

class MyFilterSubData2 {
  Color color;
  dynamic child;
  dynamic value;
  dynamic type;
  MyFilterSubData2({@required this.child, @required this.value, this.type});
}

class MyFilterData2 {
  Color color;
  dynamic child;
  List<MyFilterSubData2> data;
  dynamic defaultValue;
  dynamic value;
  bool isMultiple;
  bool fixed;
  final ValueChanged<dynamic> onChanged;
  final bool enabled;
  MyFilterData2({@required this.child, @required this.defaultValue, this.value, @required this.data, @required this.color, this.onChanged, this.isMultiple = false, this.fixed = false, this.enabled = true});
}

class MyFilter2 extends StatefulWidget {
  final String hintText;
  final List<MyFilterData2> data;
  final List<MyFilterSubData2> values;
  final Function(dynamic) onChanged;
  final Function(MyFilterData2) onDelete;
  final Function(List<MyFilterData2>) onDeleteAll;
  final double small;
  final double medium;
  final double large;
  final double xlarge;
  const MyFilter2({ Key key, this.hintText = "Agregar filtro", @required this.data, @required this.values, @required  this.onChanged,  @required this.onDelete, @required this.onDeleteAll, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 2,}) : super(key: key);

  @override
  _MyFilter2State createState() => _MyFilter2State();
}

class _MyFilter2State extends State<MyFilter2> {

  List<MyFilterData2> _selectedValues = [];

  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  _select(){
    if(widget.values == null)
      _selectedValues = [];
    if(widget.values.length == 0)
      _selectedValues = [];
        print("MyFilter2 _select widget.values.length: ${widget.values.length}");

    _selectedValues = [];
    for (var myFilterSubData in widget.values) {
      for (var myFilterData in widget.data) {
        int index = myFilterData.data.indexWhere((element) => element == myFilterSubData);
        print("MyFilter2 _selected: ${myFilterData.data[0] == widget.values[0]} : ${myFilterData.data[0].child} == ${widget.values[0].child}");
        if(index != -1){
          if(_selectedValues.indexWhere((element) => element == myFilterData) == -1)
            _selectedValues.add(myFilterData);
        }
      }
    }
        print("MyFilter2 _select _selectedValues: ${_selectedValues.length}");
  }

  _openSecondFilter(BuildContext context, MyFilterData2 myFilterData2){
    // List<MyFilterSubData2> selectedData = _getSelectedFiltersVales(myFilterData2);
    List<MyFilterSubData2> selectedData = [];
    for (var item in widget.data) {
      List<MyFilterSubData2> selectListData = _getSelectedFiltersVales(item);
      for (var selectedItem in selectListData) {
        selectedData.add(selectedItem);
      }
    }
    showMyOverlayEntry(
      context: context, 
      builder: (context, overlay){
        _back(){
          overlay.remove();
        }

       
        
        return StatefulBuilder(
          builder: (context, setState) {
            _selectItem(MyFilterData2 myFilterData2, MyFilterSubData2 value){
              int idx = selectedData.indexWhere((element) => element == value);
              // SI EL FILTRO NO EXISTE Y ES MULTIPLE ESO QUIERE DECIR QUE SE INSERTARA
              if(idx == -1 && myFilterData2.isMultiple)
                setState(() => selectedData.add(value));
              //SI EL FILTRO EXISTE Y NO ES MULTIPLE, PUES BUSCAREMOS EL FILTRO DE SU MISMO TIPO Y LO REEMPLAZAREMOS POR EL NUEVO
              else if(!myFilterData2.isMultiple){
                idx = selectedData.indexWhere((element) => element.type == value.type);
                if(idx == -1)
                  setState(() => selectedData.add(value));
                else
                  setState(() => selectedData[idx] = value);
              }
              else
                setState(() => selectedData.removeAt(idx));
            }

        _checkBox(MyFilterData2 myFilterData2, MyFilterSubData2 e){
          e.type = myFilterData2.child;
          // return Row(children: [Checkbox(value: selectedData.indexWhere((element) => element == e.value) != -1, onChanged: (value){}), e.child is Widget ? e.child : Text("${e.child}")],);
          return CheckboxListTile(controlAffinity: ListTileControlAffinity.leading, value: selectedData.indexWhere((element) => element == e) != -1,onChanged: (value){_selectItem(myFilterData2, e);}, title: e.child is Widget ? e.child : Text("${e.child}", style: TextStyle(fontSize: 13)), dense: true,);
        }

        _normal(MyFilterData2 myFilterData2, MyFilterSubData2 e){
          e.type = myFilterData2.child;
          return ListTile(
            title: Text("${e.child}"),
            onTap: (){
              // print("MyFilter2 _openSecondFIlter _normal${widget.data[0].data[0].child} == ${e.child} : ${widget.data[0].data[0] == e}");
              print("MyFilter2 _openSecondFIlter _normal${widget.data[0].data[0].child} == ${e.child} : ${widget.data[0].data[0] == e}");
              _selectItem(myFilterData2, e);
              widget.onChanged(selectedData);
              overlay.remove();
            }
          );
          InkWell(
            onTap: (){
              // print("MyFilter2 _openSecondFIlter _normal${widget.data[0].data[0].child} == ${e.child} : ${widget.data[0].data[0] == e}");
              print("MyFilter2 _openSecondFIlter _normal${widget.data[0].data[0].child} == ${e.child} : ${widget.data[0].data[0] == e}");
              // _selectItem(e);
              widget.onChanged(selectedData);
              overlay.remove();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${e.child}"),
            )
          );
        }


            return Container(
              width: 250,
              padding: EdgeInsets.only(top: 2, left: 5, right: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: MyScrollbar(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text("${myFilterData2.child}", style: TextStyle(fontSize: 15)),
                              ),
                              IconButton(onPressed: _back, icon: Icon(Icons.clear)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // children: myFilterData2.data.map((e) => ).toList(),
                            children: myFilterData2.data.map((e) => myFilterData2.isMultiple ? _checkBox(myFilterData2, e) : _normal(myFilterData2, e)).toList(),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Visibility(
                      visible: myFilterData2.isMultiple,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                height: 2.0,
                                width: 252.5,
                                margin: const EdgeInsets.only(top: 6.0), //Same as `blurRadius` i guess
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, -1.0), //(x,y)
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                ),
                                // child: TextButton(onPressed: (){widget.onChanged(selectedData);}, child: Text("Aplicar")),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0, top: 3.0, bottom: 3.0),
                              child: TextButton(onPressed: (){widget.onChanged(selectedData); overlay.remove(); }, child: Text("Aplicar")),
                            )
                        ],
                                      ),
                      ),
                    ))
                ],
              ),
            );
          }
        );
      }
    );
  }

  _openFilter(BuildContext context){
    var tmpContext = context;
    showMyOverlayEntry(
      context: context, 
      builder: (context, overlay){
        _back(){
          overlay.remove();
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: MyScrollbar(
            child: Column(
              children: widget.data.map((e) => Visibility(
                visible: _getSelectedFiltersVales(e).length == 0,
                child: GestureDetector(
                  onTap: (){
                    _back();
                    _openSecondFilter(tmpContext, e);
                  }, 
                  child: e.child is Widget ? e.child : Text("${e.child}"),
                ),
              )).toList(),
            ),
          ),
        );
      }
    );
  }

  List<MyFilterSubData2> _getSelectedFiltersVales(MyFilterData2 myFilterData){
    
    List<MyFilterSubData2> values = [];
    for (var myFilterSubData in widget.values) {
        int index = myFilterData.data.indexWhere((element) => element == myFilterSubData);
        print("MyFilter2 _selected: ${myFilterData.data[0] == widget.values[0]} : ${myFilterData.data[0].child} == ${widget.values[0].child}");
        if(index != -1){
            values.add(myFilterData.data[index]);
        }
    }

    return values;
  }

  _listtileTitle(MyFilterData2 filter){
     var selectedValuesOfThisFilter = _getSelectedFiltersVales(filter);
     return selectedValuesOfThisFilter.length == 1 ? "${filter.child} : ${selectedValuesOfThisFilter[0].child}" : "${filter.child} ${selectedValuesOfThisFilter.length}";
  }
  

  @override
  void initState() {
    // TODO: implement initState
    _select();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyFilter2 oldWidget) {
    // TODO: implement didUpdateWidget
    // if(oldWidget.values != widget.values){
      print("MyFilter2 didUpdateWidget: old = ${oldWidget.values.length} new = ${widget.values.length}");
      if(oldWidget.values.length != widget.values.length)
        _select();
      else{
        for (var newItem in widget.values) {
          var index = oldWidget.values.indexWhere((element) => element == newItem);
          if(index != -1){
            _select();
            break;
          }
        }
      }
    // }
      // _select();
    super.didUpdateWidget(oldWidget);
  }

  
  
  @override
  Widget build(BuildContext context) {
    return MyResizedContainer(
      small: widget.small,
      medium: widget.medium,
      large: widget.large,
      xlarge: widget.xlarge,
      child: Row(
        children: [
          GestureDetector(
            onTap: _selectedValues != null ? _selectedValues.length < widget.data.length ? (){_openFilter(context);} : null : (){_openFilter(context);}, 
            child: Icon(Icons.filter_alt)
          ),
          Visibility(
            visible: _selectedValues != null ? _selectedValues.length > 0 : false,
            child: Container(
              height: 40,
              // width: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _selectedValues != null ? _selectedValues.length : 0,
                itemBuilder: (context, index){
                  // return Container(child: Text("Filtroooooooooo"),);

                  var _valueNotifierColor = ValueNotifier<Color>(Theme.of(context).primaryColor.withOpacity(0.2));
                  var _valueNotifierElevation = ValueNotifier<double>(0);
                  double _elevation = 0;

                  _addHoverColor(onEnter){
                    print("MyFIlter2 _addHoverColor");
                    _valueNotifierColor.value = Colors.white;
                    _valueNotifierElevation.value = 4;
                  }
                  _removeHoverColor_(onEnter){
                    print("MyFIlter2 _removeHoverColor_");
                      _valueNotifierColor.value = Theme.of(context).primaryColor.withOpacity(0.2);
                    _valueNotifierElevation.value = 0;
                  }

                  String title = _listtileTitle(_selectedValues[index]);

                  return MouseRegion(
                    onEnter: _addHoverColor,
                    onExit:_removeHoverColor_,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        
                        // constraints: BoxConstraints(minWidth: 20, maxWidth: (title.length / 7) <= 1 ? Utils.textSize(title, TextStyle(fontSize: 14, color: Colors.blue[700], fontWeight: FontWeight.w700)), minHeight: 10, maxHeight: 30),
                        constraints: BoxConstraints(minWidth: 20, maxWidth: textSize(title, TextStyle(fontSize: 14, color: Colors.blue[700], fontWeight: FontWeight.w700)).width + 56, minHeight: 10, maxHeight: 30),
                        child: ValueListenableBuilder(
                          valueListenable: _valueNotifierElevation,
                          builder: (context, value, __) {
                            return Material(
                              elevation: _selectedValues[index].fixed ? 4 : value,
                                borderRadius: BorderRadius.circular(15),
                              child: ListTile(
                                dense: true,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                selected: true,
                                selectedTileColor: _selectedValues[index].fixed == false ? value == 4 ? Colors.white : Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                                hoverColor: Colors.white,
                                // title: Text("${_selectedValues[index].child}", style: TextStyle(fontSize: 14, color: Colors.blue[700], fontWeight: FontWeight.w700),),
                                title: Text("$title", style: TextStyle(fontSize: 14, color: Colors.blue[700], fontWeight: FontWeight.w700),),
                                trailing: InkWell(
                                  onTap: (){
                                    if(!_selectedValues[index].fixed)
                                      widget.onDelete(_selectedValues[index]);
                                  }, 
                                  child: Icon(_selectedValues[index].fixed ? Icons.push_pin_rounded : Icons.clear, size: 20, color: Colors.blue[700])
                                ),
                                minVerticalPadding: 0,
                                onTap: !_selectedValues[index].enabled ? null : (){
                                  _openSecondFilter(context, _selectedValues[index]);
                                },
                                mouseCursor: !_selectedValues[index].enabled ? SystemMouseCursors.forbidden : null,
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
          Visibility(
            visible: _selectedValues != null ? _selectedValues.length < widget.data.length : true,
            child: Builder(
              builder: (context) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none
                      ),
                      onTap: (){_openFilter(context);},
                    ),
                  ),
                );
              }
            ),
          ),
          Visibility(visible: _selectedValues.length > 0, child: Expanded(child: Align(alignment: Alignment.topRight, child: IconButton(onPressed: (){widget.onDeleteAll(_selectedValues.where((element) => !element.fixed).toList());}, icon: Icon(Icons.clear, semanticLabel: "Quitar todos los filtros",)))))
        ],
      )
    );
  }
}