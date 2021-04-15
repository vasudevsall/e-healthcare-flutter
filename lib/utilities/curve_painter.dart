import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = kPrimaryLighter.withOpacity(0.5);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.0,
        size.width * 0.65, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.4,
        size.width * 1.0, size.height * 0.2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    path = Path();
    paint.color = kPrimaryLight.withOpacity(0.5);

    path.moveTo(0, size.height * 0.24);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.04,
        size.width * 0.6, size.height * 0.24);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.44,
        size.width * 1.0, size.height * 0.24);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = kPrimaryColor;
    path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.1,
        size.width * 0.5, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.5,
        size.width * 1.0, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}