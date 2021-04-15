import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {

  final bool blueColor;
  final double imageHeight;
  final double fontSize;

  Logo({
    this.blueColor = false,
    this.imageHeight = 100.0,
    this.fontSize = 30.0
  });

  @override
  Widget build(BuildContext context) {

    String imgPath = blueColor ? 'images/logo_blue.png' : 'images/logo.png';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imgPath,
          height: imageHeight,
        ),
        Text(
          '- Healthcare',
          style: GoogleFonts.roboto(
              color: blueColor ? kPrimaryColor : Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500
          ),
        )
      ],
    );
  }
}
