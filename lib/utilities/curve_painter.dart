import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CurvePainter extends CustomPainter {

  final bool reverse;
  CurvePainter({
    this.reverse = false
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;
    List<Color> colors = [
      kPrimaryLighter.withOpacity(0.5),
      kPrimaryLight.withOpacity(0.5),
      kPrimaryColor
    ];
    const heightIncreaseCoefficient = [0.0, 0.04, 0.1];

    if(!reverse) {
      for (int i = 0; i < 3; i++) {
        paint.color = colors[i];
        var path = Path();

        path.moveTo(0, size.height * (0.4 + heightIncreaseCoefficient[i]));
        path.quadraticBezierTo(size.width * (0.4 - (0.05 * i)),
            size.height * (0.0 + heightIncreaseCoefficient[i]),
            size.width * (0.65 - (0.05 * i)),
            size.height * (0.4 + heightIncreaseCoefficient[i]));
        path.quadraticBezierTo(size.width * (0.9 - (0.05 * i)),
            size.height * (0.8 + heightIncreaseCoefficient[i]),
            size.width * 1.0,
            size.height * (0.3 + heightIncreaseCoefficient[i]));
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        canvas.drawPath(path, paint);
      }
    } else {
      for(int i=0; i<3; i++) {
        paint.color = colors[i];
        var path = Path();

        path.moveTo(0, size.height *  (0.8 - heightIncreaseCoefficient[i]));
        path.quadraticBezierTo(size.width * (0.4 - (0.05*i)), size.height * (1.0 - heightIncreaseCoefficient[i]),
            size.width * (0.65 - (0.05 * i)), size.height * (0.8 - heightIncreaseCoefficient[i]));
        path.quadraticBezierTo(size.width * (0.9 - (0.05*i)), size.height * (0.6 - heightIncreaseCoefficient[i]),
            size.width * 1.0, size.height * (0.8 - heightIncreaseCoefficient[i]));
        path.lineTo(size.width, 0);
        path.lineTo(0, 0);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}