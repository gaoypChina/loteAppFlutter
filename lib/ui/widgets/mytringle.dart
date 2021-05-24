import 'package:flutter/material.dart';
import 'dart:math' as math;


class MyTringle extends StatelessWidget {
  final double width;
  final double height;
  final double lineWidth;
  final Color color;
  MyTringle({Key key, this.width = 60, this.height = 50, this.lineWidth = 10, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: TrianglePainter(
            strokeColor: color != null ? color : Theme.of(context).primaryColor,
            strokeWidth: 10,
            paintingStyle: PaintingStyle.fill,
          ),
          child: Container(
            //  height: 50,
            // width: 60,
            height: height,
            width: width,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: lineWidth / 2,),
          child: CustomPaint(
            painter: TrianglePainter(
              strokeColor: Colors.white,
              strokeWidth: 10,
              paintingStyle: PaintingStyle.fill,
            ),
            child: Container(
              height: height - lineWidth,
              width: width - lineWidth,
            ),
          ),
        ),
      ],
    );
              
  }
}


class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      // ..moveTo(0, y)
      ..lineTo(x, 0)
      // ..lineTo(x, 0)
      ..lineTo(x / 2, y);
  }

  Path getArrowDownPath(double x, double y) {
    return Path()
      // ..moveTo(0, y)
      ..lineTo(x, y)
      ..lineTo(x, y)
      // ..lineTo(x, y)
      // ..lineTo(0, y)
      ;
  }

  Path getArrowDown(Size size){
    var path = Path();
    var sides = 3;
    var angle = (math.pi * 2) / sides;
    var radius = 10;

    Offset center = Offset(size.width / 2, size.height / 2);

    // startPoint => (100.0, 0.0)
    Offset startPoint = Offset(radius * math.cos(0.0), radius * math.sin(0.0));

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i) + center.dx;
      double y = radius * math.sin(angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
