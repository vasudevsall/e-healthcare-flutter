import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/utilities/curve_painter.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:e_healthcare/widgets/custom_dropdown.dart';
import 'package:e_healthcare/widgets/custom_label_textfield.dart';
import 'package:e_healthcare/widgets/date_input.dart';
import 'package:e_healthcare/widgets/logo.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBackColor,
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: [
            CustomPaint(
              child: Container(
                padding: EdgeInsets.only(top: 35.0),
                height: 180.0,
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
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[

                    CustomLabelTextField(
                      validator: (value) {
                        if(value.length < 5 || value.length > 20) {
                          return 'Minimum characters 5';
                        }
                        // TODO correct validation
                        return null;
                      },
                      iconData: Icons.person,
                      labelText: 'Username',
                      hintText: 'Enter Username',
                      onChange: (newVal) {
                        // TODO implement username onChange
                      },
                    ),

                    SizedBox(height: 15.0,),

                    CustomLabelTextField(
                      validator: (value) {
                        // TODO validate first name
                        return null;
                      },
                      iconData: Icons.face,
                      labelText: 'First Name',
                      hintText: 'Enter First Name',
                      onChange: (newVal) {
                        // TODO implement first name onChange
                      }
                    ),

                    SizedBox(height: 15.0,),

                    CustomLabelTextField(
                      validator: (value) {
                        // TODO validate last name
                        return null;
                      },
                      iconData: Icons.house,
                      labelText: 'Last Name',
                      hintText: 'Enter Last Name',
                      onChange: (newVal) {
                        // TODO implement lastName onChange
                      }
                    ),

                    SizedBox(height: 15.0,),

                    CustomLabelTextField(
                      validator: (value) {
                        // TODO validate phone number
                        return null;
                      },
                      iconData: Icons.phone,
                      labelText: 'Phone Number',
                      hintText: 'Enter Phone Number',
                      keyboardType: TextInputType.number,
                      onChange: (newVal) {
                        // TODO implement phone NUmber onChange
                      }
                    ),

                    SizedBox(height: 15.0,),

                    CustomLabelTextField(
                      validator: (value) {
                        // TODO validate Email
                        return null;
                      },
                      iconData: Icons.email,
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      onChange: (newVal) {
                        // TODO implement email onChange
                      }
                    ),

                    SizedBox(height: 15.0,),

                    DateInput(
                      onChange: (newVal) {
                        // TODO implement date onChange
                      }
                    ),

                    SizedBox(height: 15.0,),

                    CustomDropdownButton(
                      value: null,// TODO gender value correction
                      items: genders.map((gender) {
                        return DropdownMenuItem(
                          child: Center(
                            child: Text(gender,),
                          ),
                          value: gender[0],
                        );
                      }).toList(),
                      onChange: (newVal) {
                        //TODO implement gender onChange
                      },
                      iconData: Icons.person,
                      labelText: 'Gender',
                      hintText: 'Select Gender',
                    ),

                    SizedBox(height: 15.0,),

                    CustomDropdownButton(
                      value: null,// TODO blood group value correction
                      items: bloodGroups.map((bloodGroup) {
                        return DropdownMenuItem(
                          child: Center(
                            child: Text(bloodGroup,),
                          ),
                          value: bloodGroup,
                        );
                      }).toList(),
                      onChange: (newVal) {
                        //TODO implement bloodGroup onChange
                      },
                      iconData: Icons.local_hospital,
                      labelText: 'Blood Group',
                      hintText: 'Select Blood Group',
                    ),

                    SizedBox(height: 15.0,),

                    CustomLabelTextField(
                        validator: (value) {
                          // TODO validate password
                          return null;
                        },
                        iconData: Icons.fingerprint,
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        obscureText: true,
                        onChange: (newVal) {
                          // TODO implement password onChange
                        }
                    ),

                    SizedBox(height: 15.0,),

                    CustomLabelTextField(
                      validator: (value) {
                        // TODO validate first name
                        return null;
                      },
                      iconData: Icons.face,
                      labelText: 'Retype Password',
                      hintText: 'Retype Password',
                      obscureText: true,
                      onChange: (newVal) {
                        // TODO implement password onChange
                      }
                    ),

                    SizedBox(height: 20.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RoundedButton(
                          color: kPrimaryColor,
                          text: 'Sign Up',
                          onPressed: () {
                            // TODO Sign Up implementation
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
    );
  }
}
