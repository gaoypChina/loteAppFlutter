import 'package:flutter/material.dart';

import '../../main.dart';

class MyOverlayEntry extends StatefulWidget {
  @override
  _MyOverlayEntryState createState() => _MyOverlayEntryState();
}

class _MyOverlayEntryState extends State<MyOverlayEntry> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver is the global variable we created before
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}