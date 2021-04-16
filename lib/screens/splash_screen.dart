import 'dart:io';

import 'package:e_healthcare/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:e_healthcare/widgets/logo.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatelessWidget {

  void checkLogin(BuildContext context) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar=PersistCookieJar(storage : FileStorage(appDocPath));
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));

    var response;

    try {
      response = await dio.get(
        'https://e-healthcare-rest.herokuapp.com/login-success',
      );
      print('Logged In');
    } catch(e) {
      print('Not Logged In');
      print(e.response.statusCode);
      if(e.response.statusCode == 401) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return Scaffold(
      body: Container(
        color: kPrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Logo(),
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