import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/verify_otp.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:e_healthcare/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  String username = '';
  String msg = '';
  bool error = false;

  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _processing,
      child: Scaffold(
        body: Container(
          color: kBackColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              CustomPaint(
                child: Container(
                  padding: EdgeInsets.only(top: 50.0),
                  height: 220.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Logo(
                        imageHeight: 70.0,
                        fontSize: 20.0,
                      ),
                    ],
                  ),
                ),
                painter: CurvePainter(reverse: true),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: (error)?Colors.redAccent:Colors.green,
                        fontWeight: FontWeight.w500
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.0,),
                    CustomLabelTextField(
                      validator: (value){},
                      onChange: (newVal) {
                        username = newVal;
                      },
                      labelText: 'Enter Username',
                      hintText: 'Enter Username',
                      iconData: FontAwesomeIcons.solidUserCircle,
                    ),
                    RoundedButton(
                      onPressed: () async {
                        if(username == '') {
                          setState(() {
                            msg = 'Please enter username to continue';
                            error = true;
                          });
                        }
                        setState(() {
                          _processing = true;
                        });
                        try {
                          LoginService loginService = LoginService();
                          await loginService.sendOtp(username);
                          setState(() {
                            _processing = false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return VerifyOtp(username: username);
                          }));
                        } catch(e) {
                          setState(() {
                            msg = e.response.data['message'];
                            error = true;
                            _processing = false;
                          });
                          print(e.response);
                        }
                      },
                      color: kPrimaryColor,
                      text: 'Send OTP',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
