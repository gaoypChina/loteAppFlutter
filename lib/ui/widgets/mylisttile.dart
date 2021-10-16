import 'package:flutter/material.dart';

class MyListTileType {
  const MyListTileType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyListTileType normal = MyListTileType._(0);

  /// Extra-light
  static const MyListTileType onlyIcon = MyListTileType._(1);

  /// A list of all the font weights.
  static const List<MyListTileType> values = <MyListTileType>[
    normal, onlyIcon
  ];
}

class MyListTile extends StatefulWidget {
  final String title;
  final bool cargando;
  final IconData icon;
  final bool selected;
  final Function onTap;
  final bool visible;
  final MyListTileType type;
  final AnimationController controller;
  MyListTile({Key key, @required this.title, @required this.icon, this.onTap, this.selected = false, this.cargando = false, this.visible, this.type = MyListTileType.normal, this.controller}) : super(key: key);
  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  Widget _firstChild(){
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: widget.onTap,
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
    return Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.selected ? Colors.blue[50] : Colors.transparent
              ),
              child: ListTile(
                onTap: widget.onTap,
                selected: widget.selected,
                selectedTileColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                dense: true,
                leading: 
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,),
                ),
                
                title: Visibility(
                  visible: widget.type == MyListTileType.normal,
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(widget.title, style: TextStyle(fontFamily: "GoogleSans", fontWeight: FontWeight.w500,fontSize: 14.3, letterSpacing: 0.2, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700)),
                    Visibility(visible: widget.cargando, child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Visibility(
                                visible: widget.cargando,
                                child: new CircularProgressIndicator()
                                // Theme(
                                //   data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                                //   child: new CircularProgressIndicator(),
                                // ),
                              ),
                            ),
                          ),)
                  ],),
                )
              ),
            ),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return 
    // widget.type == MyListTileType.onlyIcon
    // ?
    // _firstChild()
    // :
    // _secondChild();
    AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return FractionalTranslation(
            
            translation: Offset(0.0, 0.0),
            child: 
            
            widget.controller.value <= 0.3 || widget.controller.value == null
            ? 
            _firstChild()
            : 
             _secondChild()
          );
        },
    );
    // MyAnimatedSwitcher(
    //   animation: widget.animation,
    //   child: _firstChild(),
    //   secondChild: _secondChild(),
    // );
    widget.type == MyListTileType.onlyIcon
    ?
    Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: widget.onTap,
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
    Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.selected && widget.type == MyListTileType.onlyIcon ? 10.0 : 0),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: ListTile(
              onTap: widget.onTap,
              selected: widget.selected,
              selectedTileColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              dense: true,
              leading: 
              // widget.type == MyListTileType.onlyIcon
              // ?
              // CircleAvatar(
              //   backgroundColor: widget.selected ? Colors.blue[50] : Colors.transparent,
              //   child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,) ,
              // )
              // :
              // Padding(
              //   padding: const EdgeInsets.only(left: 15.0),
              //   child: Container(
              //     width: 50,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       color: widget.selected ? Colors.blue[50] : Colors.transparent,
              //       borderRadius: BorderRadius.circular(25)
              //     ),
              //     child: Center(child: IconButton(icon: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,), onPressed: (){}, )) ,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,),
              ),
              
              title: Visibility(
                visible: widget.type == MyListTileType.normal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(widget.title, style: TextStyle(fontFamily: "GoogleSans", fontWeight: FontWeight.w500,fontSize: 14.3, letterSpacing: 0.2, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700)),
                  Visibility(visible: widget.cargando, child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Visibility(
                              visible: widget.cargando,
                              child: new CircularProgressIndicator()
                              // Theme(
                              //   data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                              //   child: new CircularProgressIndicator(),
                              // ),
                            ),
                          ),
                        ),)
                ],),
              )
            ),
      ),
    );
    
    return Container(
        decoration: BoxDecoration(
        color: widget.type == MyListTileType.normal ? widget.selected ? Colors.blue[50] : Colors.transparent : Colors.transparent,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
      ),
      child: 
      widget.type == MyListTileType.onlyIcon
          ?
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.selected ? Colors.blue[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Center(child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,)) ,
          )
          :
      ListTile(
          onTap: widget.onTap,
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          dense: true,
          leading: 
          // widget.type == MyListTileType.onlyIcon
          // ?
          // CircleAvatar(
          //   backgroundColor: widget.selected ? Colors.blue[50] : Colors.transparent,
          //   child: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,) ,
          // )
          // :
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.selected ? Colors.blue[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Center(child: IconButton(icon: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,), onPressed: (){}, )) ,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0),
          //   child: IconButton(icon: Icon(widget.icon, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700,), onPressed: (){}, ),
          // ),
          
          title: Visibility(
            visible: widget.type == MyListTileType.normal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(widget.title, style: TextStyle(fontFamily: "GoogleSans", fontWeight: FontWeight.w500,fontSize: 14.3, letterSpacing: 0.2, color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade700)),
              Visibility(visible: widget.cargando, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Visibility(
                          visible: widget.cargando,
                          child: CircularProgressIndicator()
                          // Theme(
                          //   data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                          //   child: new CircularProgressIndicator(),
                          // ),
                        ),
                      ),
                    ),)
            ],),
          )
        )
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