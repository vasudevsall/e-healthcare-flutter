import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/change_forgot_password.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:e_healthcare/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VerifyOtp extends StatefulWidget {

  final String username;
  VerifyOtp({
    @required this.username
  });

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {

  bool _processing = false;
  String msg = '';
  bool error = false;
  String otp = '';


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
                    Text('Please enter the OTP mailed to you', style: kLabelTextStyle, textAlign: TextAlign.center,),
                    SizedBox(height: 20.0,),
                    CustomLabelTextField(
                      validator: (value){},
                      onChange: (newVal) {
                        otp = newVal;
                      },
                      labelText: 'Enter OTP',
                      iconData: FontAwesomeIcons.key,
                    ),
                    RoundedButton(
                      onPressed: () async {
                        if(otp == '') {
                          setState(() {
                            msg = 'Please enter OTP to continue';
                            error = true;
                          });
                        }
                        setState(() {
                          _processing = true;
                        });
                        try {
                          LoginService loginService = LoginService();
                          var resp = await loginService.validateOtp(widget.username, int.parse(otp));
                          setState(() {
                            _processing = false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return ChangeForgotPassword(username: widget.username, otp: int.parse(resp.data));
                          }));
                        } catch(e) {
                          print(e);
                          setState(() {
                            msg = e.response.data['message'];
                            error = true;
                            _processing = false;
                          });
                        }
                      },
                      color: kPrimaryColor,
                      text: 'Verify Otp',
                    ),
                    RoundedButton(
                      onPressed: () async {
                        setState(() {
                          _processing = true;
                        });
                        try {
                          LoginService loginService = LoginService();
                          await loginService.sendOtp(widget.username);
                          setState(() {
                            msg = 'OTP resent';
                            error = false;
                            _processing = false;
                          });
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
                      text: 'Resend Otp',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
