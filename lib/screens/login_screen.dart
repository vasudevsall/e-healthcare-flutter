import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {


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

                    SizedBox(height: 20.0,),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.0
                      ),
                      decoration: kLoginRegisterInputDecoration.copyWith(
                        hintText: 'Enter your Email'
                      ),
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
                            // TODO: Link To Register Page
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