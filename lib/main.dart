import 'package:e_healthcare/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/splash_screen.dart';

void main() {
  runApp(EHealthcareApp());
}

class EHealthcareApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: kPrimaryColor,
        backgroundColor: kBackColor,
        primaryColor: kPrimaryColor
      ),
      // home: SplashScreen(),
      home: LoginScreen(),
    );
  }
}
