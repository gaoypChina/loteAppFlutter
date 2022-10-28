
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mymultiselectdialog.dart';

class MyhorizontalMultiSelectItem<T>{
  final T value;
  final dynamic child;
  final Color color;
  
  MyhorizontalMultiSelectItem({@required this.value, @required this.child, this.color,});
}

class MyhorizontalMultiSelect<T> extends StatefulWidget {
  final List<MyhorizontalMultiSelectItem> items;
  final List<MyhorizontalMultiSelectItem> selectedItems;
  final ValueChanged<List<T>> onChanged;
  final ValueChanged<T> onRemove;
  const MyhorizontalMultiSelect({Key key, this.items, this.selectedItems, this.onChanged, this.onRemove}) : super(key: key);

  @override
  State<MyhorizontalMultiSelect<T>> createState() => _MyhorizontalMultiSelectState<T>();
}

class _MyhorizontalMultiSelectState<T> extends State<MyhorizontalMultiSelect<T>> {
  Color _getColor(Color color){
    return color != null ? color.withOpacity(0.16) : Theme.of(context).primaryColor.withOpacity(0.2);
  }

  Color _getTextColor(Color color){
    return color != null ? color : Colors.blue[700];
  }

  EdgeInsets _getPadding(){
    return EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0);
  }

  BorderRadius _borderRadius(){
    return BorderRadius.circular(10.0);
  }

  _showItemsDialog() async {
   List<T> datos = await showDialog<List<T>>(
                context: context, 
                builder: (context){
                  // return MyMultiselect<Loteria>(
                  //   title: "Agregar loterias",
                  //   items: listaLoteria.map((e) => MyValue<Loteria>(value: e, child: _getLoteriaStream(e, isSmallOrMedium: isSmallOrMedium))).toList(),
                  //   initialSelectedItems: _selectedLoterias.length == 0 ? [] : _selectedLoterias.map((e) => MyValue<Loteria>(value: e, child: e.descripcion)).toList()
                  // );
                  
                  return MyMultiSelectDialog<T>(
                        // height: 400,
                        // controlAffinity: !isSmallOrMedium ? ListTileControlAffinity.trailing : ListTileControlAffinity.leading,
                        showButtonLimpiar: true,
                        showButtonSeleccionarTodos: true,
                        initialSelectedValues: widget.selectedItems != null ? widget.selectedItems.map<T>((e) => e.value).toList() : null,
                        items: widget.items.where((item) => !widget.selectedItems.contains(item)).map<MyMultiSelectDialogItem<T>>((e) => MyMultiSelectDialogItem<T>(e.value, e.child)).toList(),
                      );
                }
              );

    if(datos == null)
      return;

    widget.onChanged(datos);
  }

  Widget _addWidget(){
    return InkWell(
      onTap: _showItemsDialog,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: _getPadding(),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.3),
            borderRadius: _borderRadius()
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.add, color: Theme.of(context).primaryColor, size: 20,),
              Text("Agregar loteria"),
            ],
          ),
        ),
      ),
    );
  }

  _removeItem(MyhorizontalMultiSelectItem item){
    widget.onRemove(item.value);
  }

  Widget _selectedItemWidget(MyhorizontalMultiSelectItem item){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: _getColor(item.color),
          borderRadius: _borderRadius()
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(item.child, style: TextStyle(color: _getTextColor(item.color), fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: InkWell(child: Icon(Icons.clear, color: _getTextColor(item.color), size: 20,), onTap: () => _removeItem(item),),
            )
          ],
        ),
      ),
    );
  }


  List<Widget> _selectedItemsWidgets(){
    // List<Widget> _selectedItems = widget.selectedItems.map((e) => _selectedItemWidget(e)).toList();
    List<Widget> _selectedItems = widget.selectedItems.asMap().map((index, e) => MapEntry(index, _selectedItemWidget(e))).values.toList();
    _selectedItems.add(_addWidget());
    return _selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _selectedItemsWidgets(),
    );
  }
}