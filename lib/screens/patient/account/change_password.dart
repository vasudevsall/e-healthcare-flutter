import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/widgets/custom_label_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePassword extends StatefulWidget {
  final data;
  ChangePassword({
    @required this.data
  }):assert(data!=null);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';
  String retype = '';
  String displayMess = '';
  bool errorMess = false;
  bool _updating = false;

  Widget _getDrawer() {
    if(widget.data['roles'] == kUser) {
      return PatientDrawer(data: widget.data);
    }else if(widget.data['roles'] == kDoctor) {
      return DoctorDrawer(data: widget.data);
    } else {
      return PatientDrawer(data: widget.data); //TODO Manager
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _updating,
      child: UserScaffold(
        drawer: _getDrawer(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change Password',
                style: kHeadTextStyle,
              ),
              SizedBox(height: 5.0,),
              Text(
                displayMess,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: (errorMess)?Colors.red:Colors.green,
                ),
              ),
              SizedBox(height: 20.0,),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomLabelTextField(
                          validator: (value) {
                            return null;
                          },
                          iconData: FontAwesomeIcons.fingerprint,
                          labelText: 'Old Password',
                          hintText: 'Enter Old Password',
                          update: true,
                          obscureText: true,
                          onChange: (newVal) {
                            oldPassword = newVal;
                          }
                      ),

                      SizedBox(height: 20.0,),

                      CustomLabelTextField(
                          validator: (value) {
                            bool hasNumbers = value.contains(
                                new RegExp(r'[0-9]'));
                            bool hasSpecialCharacters = value.contains(
                                new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                            if (value.length < 6)
                              return "Must be at least 6 characters long";
                            if (!hasNumbers || !hasSpecialCharacters)
                              return "Must contain a number and a special character";
                            return null;
                          },
                          iconData: FontAwesomeIcons.unlockAlt,
                          labelText: 'New Password',
                          hintText: 'Enter New Password',
                          update: true,
                          obscureText: true,
                          onChange: (newVal) {
                            newPassword = newVal;
                          }
                      ),

                      SizedBox(height: 20.0,),

                      CustomLabelTextField(
                          validator: (value) {
                            if (!(value == newPassword))
                              return "Both passwords must be same";
                            return null;
                          },
                          iconData: FontAwesomeIcons.unlockAlt,
                          labelText: 'Retype Password',
                          hintText: 'Retype New Password',
                          update: true,
                          obscureText: true,
                          onChange: (newVal) {
                            retype = newVal;
                          }
                      ),

                      SizedBox(height: 20.0,),

                      ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            bool change = await _showMyDialog();

                            if (change) {
                              setState(() {
                                _updating = true;
                              });
                              LoginService loginService = LoginService();

                              try {
                                await loginService.updatePassword(
                                    oldPassword, newPassword, retype);
                                setState(() {
                                  _updating = false;
                                  displayMess =
                                  'Password changed successfully!';
                                  errorMess = false;
                                });
                              } catch (e) {
                                setState(() {
                                  _updating = false;
                                  displayMess = e.response.data['message'];
                                  errorMess = true;
                                });
                                print(e.response.data);
                              }
                            }
                          }
                        },
                        child: Text(
                          'Change Password',
                          style: GoogleFonts.libreFranklin(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: kPrimaryOther
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure ?',),
          titleTextStyle: GoogleFonts.notoSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                  style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.notoSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      ),
                      primary: Colors.green
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                  style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.notoSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      ),
                      primary: Colors.red
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
