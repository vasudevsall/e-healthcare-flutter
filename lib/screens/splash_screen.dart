import 'package:e_healthcare/screens/login_screen.dart';
import 'package:e_healthcare/utilities/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:e_healthcare/widgets/logo.dart';
import 'package:e_healthcare/services/login_service.dart';

class SplashScreen extends StatelessWidget {

  void checkLogin(BuildContext context) async {
    LoginService loginService = LoginService();
    try {
      var response = await loginService.verifyLogin();
      print('Here');
      RouteHelper routeHelper = RouteHelper();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        routeHelper.dashboardWidgetHelper(response.data)
      ));
    } catch(e) {
      print(e);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
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