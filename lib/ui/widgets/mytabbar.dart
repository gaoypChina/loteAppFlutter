import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
  final TabController controller;
  final bool isScrollable;
  final List<dynamic> tabs;
  final unselectedLabelStyle;
  final labelColor;
  final unselectedLabelColor;
  final indicator;
  final EdgeInsetsGeometry labelPadding;
  MyTabBar({Key key, @required this.controller, @required this.tabs, this.isScrollable = true, this.unselectedLabelStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.w600), this.labelColor = Colors.black, this.unselectedLabelColor, this.indicator, this.labelPadding}) : super(key: key);
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  var _indicator;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   _indicator = (widget.indicator == null) ? CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 5) : widget.indicator;
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index){
        if(index == 1){
          // setState(() => _tabController.index = _tabController.previousIndex);
        }
        print("TabBar onTap: $index");
      },
      controller: widget.controller,
      isScrollable: widget.isScrollable,
      // labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      unselectedLabelStyle: widget.unselectedLabelStyle,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      // indicatorWeight: 4.0,
      // indicator: CircleTabIndicator(color: Utils.colorPrimaryBlue, radius: 5),
      indicator: (widget.indicator != null) ? widget.indicator : CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 5),
      labelPadding: widget.labelPadding,
      // UnderlineTabIndicator(
      //   borderSide: BorderSide(color: Color(0xDD613896), width: 8.0),

      //   insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
      // ),
      
      // tabs: listaTab.map((e) => Tab(child: Text(e, style: TextStyle(fontFamily: "GoogleSans")),)).toList()
      tabs: widget.tabs.map((e) => Tab(child: (e is Widget) ? e : Text(e, style: TextStyle(fontFamily: "GoogleSans")),)).toList()
      // [
      //   AbsorbPointer(
      //     absorbing: false,
      //     child: Tab(
      //       // icon: const Icon(Icons.home),
      //       // child: Text('Mensajes'),
      //       child: Text('Prestamo',),

            
      //     ),
      //   ),
      //   new Tab(
      //     // icon: const Icon(Icons.my_location),
      //     child: Text('Garante y Cobrador',),
      //   ),
      //   new Tab(
      //     // icon: const Icon(Icons.my_location),
      //     child: Text('Gastos',),
      //   ),
      //   new Tab(
      //     // icon: const Icon(Icons.my_location),
      //     child: Text('Garantias',),
      //   ),
      //   // new Tab(
      //   //   // icon: const Icon(Icons.my_location),
      //   //   child: Text('Referencias',),
      //   // ),
      // ],
    );
          
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: circleOffset, height: cfg.size.height / 9, width: cfg.size.width), Radius.circular(5)), _paint);
    // canvas.drawCircle(circleOffset, radius, _paint);
  }
}
