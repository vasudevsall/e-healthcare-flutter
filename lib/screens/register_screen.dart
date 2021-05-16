import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:e_healthcare/widgets/custom_dropdown.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:e_healthcare/widgets/date_input.dart';
import 'package:e_healthcare/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final genders = ['Male', 'Female', 'Other'];

  String username = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String birthDate = '';
  String gender;
  String bloodGroup;
  String password = '';
  String retype = '';
  String mess = '';
  bool _registering = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _registering,
      child: Scaffold(
        body: Container(
          color: kBackColor,
          child: ListView(
            padding: EdgeInsets.all(0.0),
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
              Text(
                mess,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[

                      CustomLabelTextField(
                        validator: (value) {
                          if(value.length < 5 || value.length > 20) {
                            return 'Length should be between 5 and 20';
                          }
                          return null;
                        },
                        iconData: Icons.person,
                        labelText: 'Username',
                        hintText: 'Enter Username',
                        onChange: (newVal) {
                          username = newVal;
                        },
                      ),

                      SizedBox(height: 15.0,),

                      CustomLabelTextField(
                        validator: (value) {
                          bool hasNumbers = value.contains(new RegExp(r'[0-9]'));
                          bool hasSpecialCharacters = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                          if(value.length <= 0)
                            return "Required field";
                          if(hasNumbers || hasSpecialCharacters)
                            return "Numbers/Special characters not allowed";
                          return null;
                        },
                        iconData: Icons.face,
                        labelText: 'First Name',
                        hintText: 'Enter First Name',
                        onChange: (newVal) {
                          firstName = newVal;
                        }
                      ),

                      SizedBox(height: 15.0,),

                      CustomLabelTextField(
                        validator: (value) {
                          bool hasNumbers = value.contains(new RegExp(r'[0-9]'));
                          bool hasSpecialCharacters = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                          if(value.length <= 0)
                            return "Required field";
                          if(hasNumbers || hasSpecialCharacters)
                            return "Numbers/Special characters not allowed";
                          return null;
                        },
                        iconData: Icons.house,
                        labelText: 'Last Name',
                        hintText: 'Enter Last Name',
                        onChange: (newVal) {
                          lastName = newVal;
                        }
                      ),

                      SizedBox(height: 15.0,),

                      CustomLabelTextField(
                        validator: (value) {
                          if(value.length != 10) {
                            return "Must have 10 digits";
                          }
                          if(value.startsWith('0')) {
                            return "Must not start with 0";
                          }
                          return null;
                        },
                        iconData: Icons.phone,
                        labelText: 'Phone Number',
                        hintText: 'Enter Phone Number',
                        keyboardType: TextInputType.number,
                        onChange: (newVal) {
                          phoneNumber = newVal;
                        }
                      ),

                      SizedBox(height: 15.0,),

                      CustomLabelTextField(
                        validator: (value) {
                          bool emailValidation =
                            value.contains(new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
                          if(!emailValidation)
                            return "Invalid Email Address";
                          return null;
                        },
                        iconData: Icons.email,
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        keyboardType: TextInputType.emailAddress,
                        onChange: (newVal) {
                          email = newVal;
                        }
                      ),

                      SizedBox(height: 15.0,),

                      DateInput(
                        onChange: (newVal) {
                          birthDate = newVal;
                        }
                      ),

                      SizedBox(height: 15.0,),

                      CustomDropdownButton(
                        value: gender,
                        items: genders.map((gender) {
                          return DropdownMenuItem(
                            child: Center(
                              child: Text(gender,),
                            ),
                            value: gender[0],
                          );
                        }).toList(),
                        onChange: (newVal) {
                          setState(() {
                            gender = newVal[0];
                          });
                        },
                        iconData: Icons.person,
                        labelText: 'Gender',
                        hintText: 'Select Gender',
                      ),

                      SizedBox(height: 15.0,),

                      CustomDropdownButton(
                        value: bloodGroup,
                        items: bloodGroups.map((bloodGroup) {
                          return DropdownMenuItem(
                            child: Center(
                              child: Text(bloodGroup,),
                            ),
                            value: bloodGroup,
                          );
                        }).toList(),
                        onChange: (newVal) {
                          setState(() {
                            bloodGroup = newVal;
                          });
                        },
                        iconData: Icons.local_hospital,
                        labelText: 'Blood Group',
                        hintText: 'Select Blood Group',
                      ),

                      SizedBox(height: 15.0,),

                      CustomLabelTextField(
                          validator: (value) {
                            bool hasNumbers = value.contains(new RegExp(r'[0-9]'));
                            bool hasSpecialCharacters = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                            if(value.length < 6)
                              return "Must be at least 6 characters long";
                            if(!hasNumbers || !hasSpecialCharacters)
                              return "Must contain a number and a special character";
                            return null;
                          },
                          iconData: Icons.fingerprint,
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          obscureText: true,
                          onChange: (newVal) {
                            password = newVal;
                          }
                      ),

                      SizedBox(height: 15.0,),

                      CustomLabelTextField(
                        validator: (value) {
                          if(!(value == password))
                            return "Both passwords must be same";
                          return null;
                        },
                        iconData: Icons.lock,
                        labelText: 'Retype Password',
                        hintText: 'Retype Password',
                        obscureText: true,
                        onChange: (newVal) {
                          retype = newVal;
                        }
                      ),

                      SizedBox(height: 20.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RoundedButton(
                            color: kPrimaryColor,
                            text: 'Sign Up',
                            onPressed: () async {
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  _registering = true;
                                });
                                LoginService loginService = LoginService();

                                try {
                                  await loginService.registerUser
                                  (
                                      username, password, firstName, lastName,
                                      gender, birthDate, phoneNumber, email, bloodGroup
                                  );

                                  setState(() {
                                    _registering = false;
                                  });

                                  Navigator.pop(context, true);
                                } catch(e) {
                                  print(e);
                                  setState(() {
                                    _registering = false;
                                    mess = e.response.toString();
                                  });
                                }
                              }
                            }
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
