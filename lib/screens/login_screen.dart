import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/loggedin_screen.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/utilities/route_helper.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_healthcare/screens/register_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  final String message;
  final bool error;

  LoginScreen({
    this.message = '',
    this.error = false
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String mess = '';
  bool error = false;
  String username = '';
  String password = '';
  bool _loggingIn = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      mess = widget.message;
      error = widget.error;
    });
  }

  void login(BuildContext context) async {
    setState(() {
      _loggingIn = true;
    });

    LoginService loginService = LoginService();
    try {
      await loginService.loginUser(username, password);

      var response = await loginService.verifyLogin();

      RouteHelper routeHelper = RouteHelper();
      setState(() {
        _loggingIn = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          routeHelper.dashboardWidgetHelper(response.data)
      ));
    } catch(e) {
      setState(() {
        mess = 'Invalid Username/Password';
        error = true;
        _loggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loggingIn,
      child: Scaffold(
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
                        mess,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: (error) ? Colors.redAccent : Colors.green,
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
                            onPressed: () async {
                              var success = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterScreen())
                              );

                              if(success == true)
                                setState(() {
                                  mess = "Successfully registered, login using username/password";
                                  error = false;
                                });
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
      ),
    );
  }
}