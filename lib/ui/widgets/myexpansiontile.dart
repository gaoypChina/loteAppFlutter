import 'package:flutter/material.dart';

import 'mylisttile.dart';

class MyExpansionTileType {
  const MyExpansionTileType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyExpansionTileType normal = MyExpansionTileType._(0);

  /// Extra-light
  static const MyExpansionTileType onlyIcon = MyExpansionTileType._(1);

  /// A list of all the font weights.
  static const List<MyExpansionTileType> values = <MyExpansionTileType>[
    normal, onlyIcon
  ];
}

class MyExpansionTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> listaMylisttile;
  final bool initialExpanded;
  final bool selected;
  final MyExpansionTileType type;
  final AnimationController controller;
  MyExpansionTile({Key key, @required this.title, @required this.icon, @required this.listaMylisttile, this.initialExpanded = false, this.selected = false, this.type = MyExpansionTileType.normal, this.controller}) : super(key: key);
  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  Widget _firstChild(){
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: (){},
        child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.selected ? Colors.blue[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Center(child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,)) ,
          ),
        ),
    );
  }

  Widget _secondChild(){
    return Container(
      color: Colors.transparent,
      child: ExpansionTile(
        initiallyExpanded: widget.initialExpanded,
        leading: Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: Icon(widget.icon,),
        ),
        title: Text(widget.title, style: TextStyle(fontFamily: "GoogleSans", fontSize: 14.3, fontWeight: FontWeight.w500 )),
        children: widget.listaMylisttile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return FractionalTranslation(
            
            translation: Offset(0.0, 0.0),
            child: 
            widget.controller.value <= 0.3 
            ? 
            _firstChild()
            : 
             _secondChild()
          );
        },
    );
    // MyAnimatedSwitcher(animation: widget.animation, child: _firstChild(), secondChild: _secondChild(),);

    widget.type == MyExpansionTileType.onlyIcon
    ?
    Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: (){},
        child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.selected ? Colors.blue[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Center(child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,)) ,
          ),
        ),
    )
    :
    Container(
      color: Colors.transparent,
      child: ExpansionTile(
        initiallyExpanded: widget.initialExpanded,
        leading: Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: Icon(widget.icon,),
        ),
        title: Text(widget.title, style: TextStyle(fontFamily: "GoogleSans", fontSize: 14.3, fontWeight: FontWeight.w500 )),
        children: widget.listaMylisttile,
      ),
    );
  }
}


class MyAnimatedSwitcher extends AnimatedWidget {
  final Widget child;
  final Widget secondChild;
  const MyAnimatedSwitcher({Key key, @required Animation<double> animation, @required this.child, @required this.secondChild})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
     return
     animation.value == 0
      ?
       child
      :
      secondChild;
    // return Container(
    //   // height: MediaQuery.of(context).size.height,
    //   // width: animation.value,
    //   child:
     
    // );
  }
}