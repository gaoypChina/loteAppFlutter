import 'package:flutter/material.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';

class MyFilter extends StatefulWidget {
  final String title;
  final List<MyFilterData> data;
  final Function onDeleteAll;
  final EdgeInsets paddingContainer;
  MyFilter({Key key, @required this.title, @required this.data, @required this.onDeleteAll, this.paddingContainer = const EdgeInsets.symmetric(vertical: 10, horizontal: 20)}) : super(key: key);
  @override
  _MyFilterState createState() => _MyFilterState();
}

class _MyFilterState extends State<MyFilter> {
  MyFilterData _selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.title.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${widget.title}", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
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
                      children: widget.data.map((e) =>  Padding(
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
    )
            ;
  }
}

class MyFilterData {
  Color color;
  String text;
  dynamic value;
  final ValueChanged<dynamic> onChanged;
  MyFilterData({@required this.text, @required this.value, @required this.color, this.onChanged});
}