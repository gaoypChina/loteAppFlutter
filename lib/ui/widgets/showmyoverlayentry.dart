import 'package:flutter/material.dart';

OverlayEntry showMyOverlayEntry({@required BuildContext context, @required Widget Function(BuildContext context, OverlayEntry overlayEntry) builder, double right, double left = 0, double top = 0}) {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    var overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
                child: GestureDetector(
                  onTap: (){print("Todaa la pantallaaaaaaaaaaaaaaaaaaa"); _removeOverlay(overlayEntry);},
                  child: Container(
                    color: Colors.transparent,
                  ),
                )
            ),
          Positioned(
            // left: offset.dx,
            // right: 10,
            // top: offset.dy + 60,
            // top: offset.dy + 60,
            // width: 370,
            // left: offset.dx,
            // top: offset.dy + size.height,
            // left: offset.dx,
            // left: right == null ? offset.dx - (size.width + 140)  : null,
            // left: right == null ? offset.dx : null,
            left: right == null ? offset.dx + left : null,
            right: right,
            // top: offset.dy + size.height,
            top: (offset.dy + size.height) + top,
            child:
            Material(
              elevation: 4,
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      // spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 1.0), // changes position of shadow
                    ),
                  ],
                ),
                child: builder(context, overlayEntry)
              ),
            )
            
          ),
        ],
      )
    );
  
    // Overlay.of(context).insert(overlayEntry);
    WidgetsBinding.instance.addPostFrameCallback((_) => Overlay.of(context).insert(overlayEntry));
  }

  _removeOverlay(overlayEntry){
    if(overlayEntry != null) overlayEntry.remove();
  }

  