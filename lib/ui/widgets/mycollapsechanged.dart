import 'package:flutter/material.dart';

class MyCollapseAction {
  const MyCollapseAction._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyCollapseAction hide = MyCollapseAction._(0);

  /// Extra-light
  static const MyCollapseAction padding10 = MyCollapseAction._(1);

  /// Light
  static const MyCollapseAction padding20 = MyCollapseAction._(2);

  static const MyCollapseAction padding30 = MyCollapseAction._(3);

  /// nothing
  static const MyCollapseAction nothing = MyCollapseAction._(4);

  static const MyCollapseAction hideWithOpacity = MyCollapseAction._(5);

  /// A list of all the font weights.
  static const List<MyCollapseAction> values = <MyCollapseAction>[
    hide, padding10, padding20, padding30, nothing, hideWithOpacity
  ];
}

class MyCollapseChanged extends StatefulWidget {
  final Widget child;
  final MyCollapseAction actionWhenCollapse;
  const MyCollapseChanged({
    Key key,
    @required this.child,
    this.actionWhenCollapse = MyCollapseAction.hide
  }) : super(key: key);
  @override
  _MyCollapseChangedState createState() {
    return new _MyCollapseChangedState();
  }
}
class _MyCollapseChangedState extends State<MyCollapseChanged> {
  ScrollPosition _position;
  bool _isNotCollapsed;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
      context.dependOnInheritedWidgetOfExactType();
    print(settings.minExtent);
    bool visible = settings == null || settings.currentExtent > settings.minExtent+10;
    if (_isNotCollapsed != visible) {
      setState(() {
        _isNotCollapsed = visible;
      });
    }
  }

  _screen(){
    if(widget.actionWhenCollapse == MyCollapseAction.hide)
      return Visibility(
        visible: _isNotCollapsed,
        child: widget.child,
      );
    else if(widget.actionWhenCollapse == MyCollapseAction.hideWithOpacity)
      return AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: _isNotCollapsed?1:0,
          child: widget.child,
        );
    else if(widget.actionWhenCollapse == MyCollapseAction.padding10)
      return AnimatedPadding(
          duration: Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: _isNotCollapsed ? 0: 10),
          child: widget.child,
        );
    else if(widget.actionWhenCollapse == MyCollapseAction.padding20)
      return AnimatedPadding(
          duration: Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: _isNotCollapsed ? 0: 20),
          child: widget.child,
        );
    else if(widget.actionWhenCollapse == MyCollapseAction.padding30)
      return AnimatedPadding(
          duration: Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: _isNotCollapsed ? 0: 30),
          child: widget.child,
        );
    else
      return widget.child;
    
  }
  @override
  Widget build(BuildContext context) {
    return _screen();   
  }
}