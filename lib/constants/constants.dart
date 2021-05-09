import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

/*Color Constants*/

const Color kPrimaryColor = Color(0xff16697a);
const Color kPrimaryLight = Color(0xff2c8498);
const Color kPrimaryLighter = Color(0xff489fb5);
const Color kPrimaryOther = Color(0xff82c8cc);
const Color kPurpleColor = Color(0xff2e294e);
const Color kSecondColor = Color(0xffffa62b);
const Color kRedColor = Color(0xffff5a5f);
const Color kDarkBackColor = Color(0xff2d383a);
const Color kBackColor = Color(0xffefefef);

/*Color Constants end*/

/* Login Register constants*/

const kLoginRegisterInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(10.0),
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kPrimaryLight, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kPrimaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

/* Login register constants */

/* Dashboard constants */

BoxDecoration kDashBoxDecoration = BoxDecoration(
  color: kPrimaryOther,
  borderRadius: BorderRadius.circular(15.0),
);

TextStyle kDashBoxHeadTextStyle = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w700,
  fontSize: 16.0,
);

TextStyle kHeadTextStyle = GoogleFonts.notoSans(
    fontSize: 18.0,
    color: kPrimaryColor,
    fontWeight: FontWeight.w700
);

TextStyle kSubTextStyle = GoogleFonts.montserrat(
    fontSize: 12.0,
    color: kPrimaryLight
);

Widget kDashBoxSpinner = SleekCircularSlider(
  appearance: CircularSliderAppearance(
    spinnerMode: true,
    size: 36.0,
    customColors: CustomSliderColors(
      trackColor: kPrimaryOther,
      progressBarColor: Color(0xeeffffff),
    ),
  ),
);

/* Dashboard Constants */

/* URL Constants */
const kURL = 'https://e-healthcare-mobile.herokuapp.com';