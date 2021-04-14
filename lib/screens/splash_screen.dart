import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kPrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  height: 100.0,
                ),
                Text(
                  '- Healthcare',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                spinnerMode: true,
                size: 36.0,
                customColors: CustomSliderColors(
                  trackColor: kPrimaryColor,
                  progressBarColor: Color(0xeeffffff),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}