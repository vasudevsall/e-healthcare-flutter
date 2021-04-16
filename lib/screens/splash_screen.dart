import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:http/http.dart' as http;
import 'package:e_healthcare/widgets/logo.dart';

class SplashScreen extends StatelessWidget {

  void checkLogin() async {
    print('Hello');
    var url = Uri.parse('https://e-healthcare-rest.herokuapp.com/login-verify');
    try {
      var response = await http.get(url);
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogin();
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