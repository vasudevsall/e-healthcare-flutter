import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_dashboard.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/manager/manager_dashboard.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/patient_dashboard.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/widgets/custom_dropdown.dart';
import 'package:e_healthcare/widgets/custom_label_textfield.dart';
import 'package:e_healthcare/widgets/date_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UpdateInformation extends StatefulWidget {
  final data;
  UpdateInformation({
    @required this.data
  });
  @override
  _UpdateInformationState createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {

  final _formKey = GlobalKey<FormState>();
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final genders = ['Male', 'Female', 'Other'];

  String firstName;
  String lastName;
  String phone;
  String email;
  String birthDate;
  String bloodGroup;
  String gender;
  String password;
  bool cancelButton = false;
  var userData;
  String displayMess = '';
  bool error = false;
  bool _updating = false;

  Widget _getDrawer() {
    if(widget.data['roles'] == kUser) {
      return PatientDrawer(data: widget.data);
    }else if(widget.data['roles'] == kDoctor) {
      return DoctorDrawer(data: widget.data);
    } else {
      return ManagerDrawer(data: widget.data);
    }
  }

  Widget _getDashboard() {
    if(widget.data['roles'] == kUser) {
      return PatientDashboard(data: userData);
    }else if(widget.data['roles'] == kDoctor) {
      return DoctorDashboard(data: userData);
    } else {
      return ManagerDashboard(data: userData);
    }
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      firstName = widget.data['firstName'];
      lastName = widget.data['lastName'];
      phone = widget.data['phoneNumber'];
      birthDate = widget.data['birthDate'];
      email = widget.data['email'];
      bloodGroup = widget.data['bloodGroup'];
      gender = widget.data['gender'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _updating,
      child: UserScaffold(
        drawer: _getDrawer(),
        body: ListView(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
          children: [
            Text(
              'Update Information',
              style: kHeadTextStyle,
            ),
            SizedBox(height: 20.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                    iconData: FontAwesomeIcons.solidUserCircle,
                    labelText: 'First Name',
                    hintText: 'Enter First Name',
                    update: true,
                    initialValue: firstName,
                    onChange: (newVal){
                      firstName = newVal;
                    }
                  ),
                  SizedBox(height: 20.0,),
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
                      update: true,
                      initialValue: lastName,
                      onChange: (newVal){
                        lastName = newVal;
                      }
                  ),
                  SizedBox(height: 20.0,),
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
                      update: true,
                      initialValue: phone,
                      onChange: (newVal){
                        phone = newVal;
                      }
                  ),
                  SizedBox(height: 20.0,),
                  CustomLabelTextField(
                      validator: (value) {
                        bool emailValidation =
                        value.contains(new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
                        if(!emailValidation)
                          return "Invalid Email Address";
                        return null;
                      },
                      iconData: FontAwesomeIcons.at,
                      labelText: 'Email Id',
                      hintText: 'Enter Email Id',
                      update: true,
                      initialValue: email,
                      keyboardType: TextInputType.emailAddress,
                      onChange: (newVal){
                        email = newVal;
                      }
                  ),
                  SizedBox(height: 20.0,),
                  DateInput(
                    onChange: (newVal) {
                      birthDate = newVal;
                    },
                    initialValue: birthDate,
                    update: true,
                  ),
                  SizedBox(height: 20.0,),
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
                    radius: 5.0,
                    iconData: FontAwesomeIcons.venusMars,
                    labelText: 'Gender',
                    hintText: 'Select Gender',
                  ),
                  SizedBox(height: 20.0,),
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
                    radius: 5.0,
                    iconData: FontAwesomeIcons.tint,
                    labelText: 'Blood Group',
                    hintText: 'Select Blood Group',
                  ),
                  SizedBox(height: 20.0,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            bool done = await _showMyDialog();
                            if(done) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                                return _getDashboard();
                              }), (route) => false);
                            }
                          }
                        },
                        child: Text(
                          'Update Information'
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryOther
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ModalProgressHUD(
              inAsyncCall: _updating,
              child: AlertDialog(
                title: Text('Enter Password to Continue',),
                titleTextStyle: GoogleFonts.notoSans(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        displayMess,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: (error)?Colors.red:Colors.green,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      CustomLabelTextField(
                        validator: (value) {},
                        onChange: (newVal) {
                          password = newVal;
                        },
                        iconData: FontAwesomeIcons.fingerprint,
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        obscureText: true,
                        update: true,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if(!cancelButton) {
                        setState(() {
                          _updating = true;
                        });
                        try {
                          LoginService loginService = LoginService();
                          var resp = await loginService.updateUser(
                              password,
                              firstName,
                              lastName,
                              gender,
                              birthDate,
                              phone,
                              email,
                              bloodGroup);
                          print('Here');
                          setState(() {
                            cancelButton = true;
                            userData = resp.data;
                            error = false;
                            displayMess = 'Details Updated Successfully!';
                            _updating = false;
                          });
                        } catch (e) {
                          setState(() {
                            _updating = false;
                            displayMess = e.response.data['message'];
                            error = true;
                          });
                          print(e.response.data);
                        }
                      } else  {
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Text((cancelButton)?'Done':'Update'),
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
                    onPressed:(cancelButton)?null: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                        textStyle: GoogleFonts.notoSans(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                        ),
                        primary: Colors.red
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
