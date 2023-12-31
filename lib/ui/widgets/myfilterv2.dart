import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';

class MyFilterSubItem {
  dynamic child;
  dynamic value;
  MyFilterSubItem({@required this.child, this.value});
}

class MyFilterItem {
  Color color;
  List<MyFilterSubItem> data;
  dynamic defaultValue;
  dynamic value;
  String hint;
  bool isMultiple;
  bool fixed;
  final ValueChanged<dynamic> onChanged;
  final bool enabled;
  final bool visible;
  MyFilterItem({this.hint, @required this.data, this.color, this.onChanged, this.isMultiple = false, this.fixed = false, this.enabled = true, this.visible = true});
}

class MyFilterV2 extends StatefulWidget {
  final List<MyFilterItem> item;
  final EdgeInsets padding;
  final double textFontSize;

  const MyFilterV2({ Key key, this.item, this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 8), this.textFontSize}) : super(key: key);

  @override
  State<MyFilterV2> createState() => _MyFilterV2State();
}

class _MyFilterV2State extends State<MyFilterV2> {
  bool _isSmallOrMedium = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: widget.item.length,
      itemBuilder: (context, index){
        return Visibility(
          visible: widget.item[index].visible,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: MyDropdown(
              enabled: widget.item[index].enabled,
              isExpanded: false,
              title: null,
              leading: SizedBox.shrink(),
              // textColor: Colors.black,
              // color: Colors.grey[200],
              hintFontSize: widget.textFontSize,
              textColor: widget.item[index].color != null ? widget.item[index].color : null,
              color: widget.item[index].color != null ? widget.item[index].color.withOpacity(0.2) : null,
              padding: widget.padding != null ? widget.padding : const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              hint: widget.item[index].hint,
              resized: false,
              elements: widget.item[index].data.map((e) => [e.value, e.child is Widget ? e.child : Text("${e.child}")]).toList(),
              onTap: (value){
                if(widget.item[index].onChanged != null)
                  widget.item[index].onChanged(value);
              },
            ),
          ),
        );
      }
    );
  }

  _esVentanaGrande(){
    return _isSmallOrMedium == false;
  }
}