import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';

import 'mydivider.dart';

class MySliver extends StatefulWidget {
  final MySliverAppBar sliverAppBar;
  final Widget sliver;
  final Widget sliverFillRemaining;

  MySliver({Key key, @required this.sliverAppBar, @required this.sliver, this.sliverFillRemaining}) : super(key: key);

  @override
  _MySliverState createState() => _MySliverState();
}

class _MySliverState extends State<MySliver> {
  ScrollController _controller = ScrollController();

  _slivers(){
    var slivers = [
          widget.sliverAppBar,
          widget.sliver,
          
          // SliverFillRemaining(),
          // SliverList(delegate: SliverChildListDelegate(widget.elements))
        ];
    if(widget.sliverFillRemaining != null)
      slivers.add(widget.sliverFillRemaining);

    return slivers;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // _controller.addListener(() {
  //   //   print("MySliver scrollcontroller: ${_controller.offset}");
  //   // });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
          controller: _controller,
          child: CupertinoScrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: CustomScrollView(
              slivers: _slivers()
            ),
          ),
        );
      
  }
}

class MySliverButton extends StatefulWidget {
  final dynamic title;
  final dynamic iconWhenSmallScreen;
  final Function onTap;
  final bool isFlatButton;
  final bool visibleOnlyWhenSmall;
  final EdgeInsets padding;
  final double fontSize;
  final Color color;
  final bool showOnlyOnSmall;
  final bool showOnlyOnLarge;
  MySliverButton({Key key, @required this.title, this.iconWhenSmallScreen, @required this.onTap, this.isFlatButton = false, this.visibleOnlyWhenSmall = false, this.padding = const EdgeInsets.symmetric(horizontal: 10), this.fontSize = 14, this.color, this.showOnlyOnSmall = false, this.showOnlyOnLarge = false}) : super(key: key);

  @override
  _MySliverButtonState createState() => _MySliverButtonState();
}

class _MySliverButtonState extends State<MySliverButton> {

  _iconScreen(){
    if(widget.showOnlyOnLarge){
    if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
      return SizedBox.shrink();
    }

    return (widget.iconWhenSmallScreen is IconData) ? IconButton(icon: Icon(widget.iconWhenSmallScreen), onPressed: widget.onTap) : widget.iconWhenSmallScreen;
  }

  _buttonScreen(){
    if(widget.showOnlyOnSmall){
      if(!Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    if(widget.showOnlyOnLarge){
      if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    if(widget.visibleOnlyWhenSmall)
      return SizedBox.shrink();

    if(widget.title is Widget)
      return widget.title;

    if(widget.isFlatButton)
      return Padding(
        padding: widget.padding,
        child: TextButton(onPressed: widget.onTap, child: Text((widget.title is Widget) ? "" : widget.title, style: TextStyle(color: widget.color, fontSize: widget.fontSize, fontFamily: "GoogleSans", fontWeight: FontWeight.w600))),
      );

    return Align(
      alignment: Alignment.centerRight,
          child: Padding(
         padding: EdgeInsets.only(left: 5, right: 15.0),
         child: MyButton(
           type: MyButtonType.noResponsive,
           title: (widget.title is Widget) ? "" : widget.title,
           function: widget.onTap,
           color: widget.color,
         )
        //  myButton(
        //     text: (widget.title is Widget) ? "" : widget.title,
        //     function: widget.onTap,
        //   ),
        ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return 
    (Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        ?
        (widget.iconWhenSmallScreen != null)
        ?  
        _iconScreen()
        :
        _buttonScreen()
        :
        _buttonScreen();
    // LayoutBuilder(
    //   builder: (context, boxconstraint) {
    //     return 
    //     (ScreenSize.isMedium(boxconstraint.maxWidth) || ScreenSize.isSmall(boxconstraint.maxWidth))
    //     ?
    //     _iconScreen()
    //     :
    //     _buttonScreen();
    //   }
    // );
  }
}

class MySliverAppBar extends StatefulWidget {
  final dynamic title;
  final dynamic subtitle;
  final double expandedHeight;
  final bool cargando;
  final List<MySliverButton> actions;
  final bool disableLeading;
  final double titleMinFontSizeForLargeScreen;
  final double titleMinFontSizeForSmallScreen;
  final EdgeInsets titlePadding;
  final String backRouteName;
  MySliverAppBar({Key key, this.title, this.subtitle = "", this.expandedHeight = 85, this.cargando = false, this.actions = const [], this.disableLeading = false, this.titleMinFontSizeForLargeScreen = 20, this.titleMinFontSizeForSmallScreen = 18, this.titlePadding = const EdgeInsets.all(0), this.backRouteName}) : super(key: key);

  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  var _txtSearch = TextEditingController();
  

  Widget _titleScreen(BoxConstraints boxconstraint){
    print("MySliver _titleScreen: ${boxconstraint.biggest}");
    // if(widget.backRouteName != null)
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Visibility(
    //         visible: boxconstraint.biggest.height < 57 == false,
    //         child: InkWell(
    //           onTap: () => Navigator.pop(context),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             // Icon(Icons.arrow_back_rounded),
    //             Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.5), size: 20,),
    //             Text("${widget.backRouteName}", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.5)),),
    //           ],
    //       ),
    //         )),
    //       Padding(
    //         padding: widget.titlePadding,
    //         child: AnimatedDefaultTextStyle(
    //         duration: Duration(milliseconds: 300), 
    //         style: TextStyle(fontSize: Utils.isSmallOrMedium(boxconstraint.maxWidth) ? boxconstraint.biggest.height < 57 && widget.subtitle != null ? widget.titleMinFontSizeForSmallScreen : 20 : boxconstraint.biggest.height < 57 && widget.subtitle != null ? widget.titleMinFontSizeForLargeScreen : 32, color: Utils.fromHex("#202124"), fontFamily: 'GoogleSans', fontWeight: FontWeight.w500, letterSpacing: 0.2),
    //         child: Text(widget.title, )
    //         ),
    //       )
    //     ],
    //   );

    return Padding(
      padding: widget.titlePadding,
      child: AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 300), 
      style: TextStyle(fontSize: Utils.isSmallOrMedium(boxconstraint.maxWidth) ? boxconstraint.biggest.height < 57 && widget.subtitle != null ? widget.titleMinFontSizeForSmallScreen : 20 : boxconstraint.biggest.height < 57 && widget.subtitle != '' ? widget.titleMinFontSizeForLargeScreen : 32, color: Utils.fromHex("#202124"), fontFamily: 'GoogleSans', fontWeight: FontWeight.w500, letterSpacing: 0.2),
      child: widget.title is Widget ? widget.title : Text(widget.title, )
      ),
    );
  }
  Widget _titleSmallScreen(isSmallOrMedium){
    if(isSmallOrMedium){
      return widget.title is Widget ? widget.title : Text("${widget.title}", style: TextStyle(fontSize: 20, color: Utils.fromHex("#202124"), fontFamily: 'GoogleSans', fontWeight: FontWeight.w600, letterSpacing: 0.2),);
    }
    else
      return LayoutBuilder(
        builder: (context, boxconstraint) {
          print("_titleSmallScreen: ${boxconstraint.biggest.height}");
          return _titleScreen(boxconstraint);
        }
      );
  }

  _subtitle(bool isSmallOrMedium){
    if(widget.subtitle is MyCollapseChanged)
      return widget.subtitle;

    if(widget.subtitle is Widget)
      return MyCollapseChanged(child: widget.subtitle, actionWhenCollapse: isSmallOrMedium ? MyCollapseAction.padding30 : MyCollapseAction.hide,);
    
    return Visibility(
      visible: widget.subtitle != "",
      child:  MyCollapseChanged(child: Text(widget.subtitle, style: TextStyle(color: Utils.fromHex("#5f6368"), fontFamily: "GoogleSans", fontSize: 14, letterSpacing: 0.4),), actionWhenCollapse: isSmallOrMedium ? MyCollapseAction.padding30 : MyCollapseAction.hide,)
    );
  }
  
  _flexibleSpace(bool isSmallOrMedium){
    return LayoutBuilder(
        builder: (context, boxconstraint) {
          print("Pruebasliver: ${boxconstraint.biggest.height}");
          return Align(
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              child: 
              // (ScreenSize.isMedium(MediaQuery.of(context).size.width) || ScreenSize.isSmall(MediaQuery.of(context).size.width))
              // ?
              Padding(
                padding: EdgeInsets.only( bottom: isSmallOrMedium ? 10 : 0, left: Utils.isSmallOrMedium(boxconstraint.maxWidth) ? 0 : 0.0, top: boxconstraint.biggest.height <= 57 ? 10 : 14,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _actionsScreen(isSmallOrMedium)
                    // SizedBox(height: boxconstraint.biggest.height < 57 ? 20 : 10,),
                    _subtitle(isSmallOrMedium),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 25.0, top: 20),
                    //   child: Divider(color: Colors.grey.shade300, thickness: 0.9, height: 1,),
                    // ),
                    (Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
                    ?
                    SizedBox.shrink()
                    :
                    MyDivider(padding: EdgeInsets.only(right: 25, top: 15),)
                  ],
                ),
              )
              // :
              // Padding(
              //   padding: const EdgeInsets.only(top: 53.0),
              //   child: MyHeader(title: "Clientes", subtitle: widget.subtitle,),
              // )

            ),
          );
        }
      );
      
  }

  _actionsScreen(isSmallOrMedium){
    return isSmallOrMedium ? widget.actions : widget.actions;
  }

  @override
  Widget build(BuildContext context) {
    
        var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
        return SliverAppBar(
          onStretchTrigger: (){
            print("Holaaa sliver trigger");
            return;
          },
          
          automaticallyImplyLeading: isSmallOrMedium,
          // automaticallyImplyLeading: false,
          // backgroundColor: Colors.white,
          pinned: true,
          // floating: true,
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(0),
          //   child: _flexibleSpace(),
          // ),
          titleSpacing: 0.0,
          // title: _titleSmallScreen(isSmallOrMedium),
          actions: _actionsScreen(isSmallOrMedium),
          title: widget.title is MyCollapseChanged ? widget.title : MyCollapseChanged(child: _titleSmallScreen(isSmallOrMedium), actionWhenCollapse: isSmallOrMedium ? MyCollapseAction.hide : MyCollapseAction.nothing,),
          // title: _titleSmallScreen(isSmallOrMedium),
          // leading: Container(
          //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(Icons.arrow_back),
          //       Text("prestamos", style: TextStyle(color: Colors.grey),),
          //     ],
          //   )
          // ),
          // title: Container(
          //   padding: EdgeInsets.symmetric(vertical: 2),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[50],
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   child: Wrap(
          //     children: [
          //       Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.5)),
          //       Text("prestamos", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.5)),),
          //     ],
          //   )
          // ),
          // title: Container(
          //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   child: Text("prestamos", style: TextStyle(color: Colors.grey),)
          // ),
          // LayoutBuilder(
          //   builder: (context, boxconstraint) {
          //     return _titleScreen(boxconstraint);
          //   }
          // ),
          // actions: widget.actions,
          // expandedHeight: (widget.subtitle != "") ? (widget.backRouteName != null) ? widget.expandedHeight + 12 : widget.expandedHeight : (widget.backRouteName != null) ? 80 : null,
          expandedHeight: (widget.subtitle != "") ?  widget.expandedHeight : null,
          // flexibleSpace: MyColapseChanged(child: _flexibleSpace(isSmallOrMedium), actionWhenCollapse: isSmallOrMedium ? MyCollapseAction.padding30 : MyCollapseAction.hide,)
          flexibleSpace: _flexibleSpace(isSmallOrMedium)
          
          
        );
      
  }
}


