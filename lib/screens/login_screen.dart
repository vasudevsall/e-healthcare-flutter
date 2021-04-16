import 'dart:io';

import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/splash_screen.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_healthcare/screens/register_screen.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String errMess = '';
  String username = '';
  String password = '';

  void login(BuildContext context) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar=PersistCookieJar(storage : FileStorage(appDocPath));
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));

    var formData = {
      'username': username,
      'password': password
    };

    var response;

    try {
      response = await dio.post(
        'https://e-healthcare-rest.herokuapp.com/login', data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) { return status < 500; },
          responseType: ResponseType.json
        ),
      );

      response = await dio.get(
        'https://e-healthcare-rest.herokuapp.com/login-success',
      );

      print(response.data);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
    } catch(e) {
      print(e.response.data);
      print(e.response.statusCode);
      print(e.message);
      if(e.response.statusCode == 401) {
        setState(() {
          errMess = 'Invalid Username/Password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: kBackColor,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: Image.asset('images/logo_blue.png'),
                      ),
                    ),

                    SizedBox(height: 10.0,),
                    Text(
                      errMess,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.0
                      ),
                      decoration: kLoginRegisterInputDecoration.copyWith(
                        hintText: 'Enter your username'
                      ),
                      onChanged: (newVal) {
                        username = newVal;
                      },
                    ),
                    SizedBox(height: 8.0,),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          fontSize: 14.0
                      ),
                      decoration: kLoginRegisterInputDecoration.copyWith(
                          hintText: 'Enter your Password'
                      ),
                      onChanged: (newVal) {
                        password = newVal;
                      },
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // TODO: Link to Forgot Password Page
                            },
                            splashColor: Colors.lightBlueAccent.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    RoundedButton(
                      onPressed: () {
                        // TODO: Login Implementation
                        login(context);
                      },
                      color: kPrimaryColor,
                      text: 'Login',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'New User?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen())
                            );
                          },
                          child: Text(
                            'Register Here',
                            style: TextStyle(
                              fontSize: 12.0
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ),
            CustomPaint(
              child: Container(
                height: 120.0,
              ),
              painter: CurvePainter(),
            ),
          ],
        ),
      ),
    );
  }
}