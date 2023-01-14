import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';


class MyButtonType {
  const MyButtonType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyButtonType normal = MyButtonType._(0);

  /// Extra-light
  static const MyButtonType roundedWithOnlyBorder = MyButtonType._(1);

  /// Light
  static const MyButtonType rounded = MyButtonType._(2);

  /// No responsive
  static const MyButtonType noResponsive = MyButtonType._(3);
  static const MyButtonType listTile = MyButtonType._(4);

  /// A list of all the font weights.
  static const List<MyButtonType> values = <MyButtonType>[
    normal, roundedWithOnlyBorder, rounded, noResponsive, listTile
  ];
}


class MyButton extends StatefulWidget {
  final dynamic title;
  final bool enabled;
  final double small;
  final double medium;
  final double large;
  final double xlarge;
  final EdgeInsets padding;
  final EdgeInsets paddingSmallScreen;

  final Function function;
  final Color color;
  final Color textColor;
  final MyButtonType type;
  final double letterSpacing;
  final Widget leading;
  final Widget trailing;
  final bool cargando;
  final ValueNotifier<bool> cargandoNotify;
  final double fontSize;
  final bool isResponsive;
  MyButton({Key key, this.title = "", this.function, this.enabled = true, this.fontSize = 14, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 5, this.padding = const EdgeInsets.only(top: 9.0, bottom: 9.0, right: 23, left: 23.0), this.paddingSmallScreen = const EdgeInsets.only(top: 9.0, bottom: 9.0, right: 18, left: 18.0), this.color, this.textColor, this.type = MyButtonType.normal, this.leading, this.trailing, this.letterSpacing = 0.4, this.cargando = false, this.cargandoNotify, this.isResponsive = true}) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {

  Color _color(){
    if(widget.cargando)
      return Colors.grey[300];
      
    switch (widget.type) {
      case MyButtonType.rounded:
        if(widget.color == null){
          // return (widget.enabled) ? Utils.colorPrimaryBlue : Colors.grey[300];
          return (widget.enabled) ? null : Colors.grey[300];
        }else{
          return (widget.enabled) ? widget.color : Colors.grey[300];
        }
        break;
      case MyButtonType.roundedWithOnlyBorder:
        if(widget.color == null){
          return  Colors.white;
        }else{
          return  widget.color;
        }
        break;
      case MyButtonType.listTile:
        if(widget.color == null){
          return  Theme.of(context).primaryColor.withOpacity(0.2);
        }else{
          return  widget.color;
        }
        break;
      default:
      if(widget.color == null){
        // return (widget.enabled) ? Utils.colorPrimaryBlue : Colors.grey[300];
        return (widget.enabled) ? Theme.of(context).primaryColor : Colors.grey[300];
      }else{
        return (widget.enabled) ? widget.color : Colors.grey[300];
      }
    }
  }

  Color _textColor(){
    switch (widget.type) {
      case MyButtonType.roundedWithOnlyBorder:
        if(widget.textColor == null){
          return (widget.enabled) ? Colors.blue : Colors.grey;
        }else{
          return (widget.enabled) ? widget.textColor : Colors.grey;
        }
        break;
      case MyButtonType.listTile:
        if(widget.textColor == null){
          return (widget.enabled) ? Theme.of(context).primaryColor : Colors.grey;
        }else{
          return (widget.enabled) ? widget.textColor : Colors.grey;
        }
        break;
      default:
        if(widget.textColor == null){
          return (widget.enabled) ? Colors.white : Colors.grey;
        }else{
          return (widget.enabled) ? widget.textColor : Colors.grey;
        }
    }
  }

  _circularProgressIndicator(){
    return SizedBox(height: 12, width: 12, child: CircularProgressIndicator());
  }

  _buttonNormal(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 34,
      padding: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? widget.paddingSmallScreen : widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: widget.cargando ? _circularProgressIndicator() : Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),)
      )
    );
    return InkWell(
    onTap: widget.function,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? widget.paddingSmallScreen : widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),)
    )
  );
  }

  _buttonListTile(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? widget.paddingSmallScreen : widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          widget.leading != null ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: widget.leading,
          ) : SizedBox.shrink(),
          Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),),
          widget.trailing != null ? 
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: widget.trailing,
          ) : SizedBox.shrink()
        ],
      )
    );
    return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      child: ListTile(
        selected: true,
        selectedTileColor: _color(),
        leading: widget.leading,
        title: Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),),
      ),
    );
    return InkWell(
    onTap: widget.function,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? widget.paddingSmallScreen : widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.circular(5)
      ),
      child: ListTile(
      leading: widget.leading,
      title: Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w400),),
    )
      // Row(
      //   children: [
      //     widget.leading != null ? widget.leading : SizedBox.shrink(),
      //     Expanded(child: Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),)),
      //   ],
      // )
    )
  );
  }

   _buttonNoResponsive(){
  //   return InkWell(
  //   onTap: widget.function,
  //   child: AnimatedContainer(
  //     duration: Duration(milliseconds: 200),
  //     padding: widget.padding,
  //     decoration: BoxDecoration(
  //       color: _color(),
  //       borderRadius: BorderRadius.circular(5)
  //     ),
  //     child: Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),)
  //   )
  // );
  var text = Text(widget.title, style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600),);
  return InkWell(
    onTap: widget.function,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? widget.paddingSmallScreen : widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.circular(5)
      ),
      child: 
      widget.cargandoNotify == null
      ?
      widget.cargando
      ?
      CircularProgressIndicator()
      :
      text
      :
      ValueListenableBuilder(
        valueListenable: widget.cargandoNotify,
        builder: (context, value, __){
          return !value
          ?
          text
          :
          CircularProgressIndicator();
        }
      )
    )
  );
  }


  _buttonRoundedWithOnlyBorder(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]
      ),
      child: (widget.leading == null) 
      ? 
      widget.title is Widget
      ?
      Center(child: widget.title,)
      :
      Center(child: Text(widget.title.toUpperCase(), style: TextStyle(fontSize: widget.fontSize, color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600, letterSpacing: widget.letterSpacing),))
      :
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.leading,
           Center(child: Text(widget.title.toUpperCase(), style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600, letterSpacing: widget.letterSpacing),))

        ],
      )
    ); 
  }

  _buttonRounded(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _color(),
        border: Border.all(color: _color().withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // color: _color().withOpacity(0.4),
            color: _color(),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]
      ),
      child: Center(
        child: 
         (widget.cargandoNotify == null) 
            ? 
            (widget.cargando)
            ?
            CircularProgressIndicator(color: _textColor(),) 
            : 
            Text(widget.title.toUpperCase(), style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600, letterSpacing: widget.letterSpacing),)
        :
        ValueListenableBuilder(
          valueListenable: widget.cargandoNotify,
          builder: (_, value, __){
            return (value) 
            ? 
            CircularProgressIndicator(backgroundColor: widget.textColor,) 
            : 
            Text(widget.title.toUpperCase(), style: TextStyle(color: _textColor(), fontFamily: "GoogleSans", fontWeight: FontWeight.w600, letterSpacing: widget.letterSpacing),);
          },
        )
      )
    ); 
  }


  Widget _screen(){
    // if(!widget.isResponsive)
    //   return _buttonNoResponsive();

    switch (widget.type) {
      case MyButtonType.roundedWithOnlyBorder:
        return _buttonRoundedWithOnlyBorder();
        break;
      case MyButtonType.rounded:
        return _buttonRounded();
        break;
      case MyButtonType.noResponsive:
        return _buttonNoResponsive();
        break;
      case MyButtonType.listTile:
        return _buttonListTile();
        break;
      default:
        return _buttonNormal();
    }
  }

  _responsiveOrNoResponsiveScreen(){
    return InkWell(
    onTap: widget.cargando ? null : widget.function,
    child: 
    widget.isResponsive == false
    ?
    _screen()
    :
    MyResizedContainer(
      small: widget.small,
      medium: widget.medium,
      large: widget.large,
      xlarge: widget.xlarge,
      child: _screen()
    )
  ); 
  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // if(widget.cargandoNotify != null)
    //   widget.cargandoNotify.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("mybutton2 build");
    return _responsiveOrNoResponsiveScreen();
  }
}