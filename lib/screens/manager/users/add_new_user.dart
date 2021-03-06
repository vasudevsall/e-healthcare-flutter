import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/constants/user_constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:e_healthcare/services/manage_user_service.dart';
import 'package:e_healthcare/widgets/custom_dropdown.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:e_healthcare/widgets/date_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddNewUser extends StatefulWidget {
  final data;
  final bool doctor;
  AddNewUser({
    @required this.data,
    this.doctor = false,
  });
  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {

  String displayMessage = '';
  bool displayError = false;
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String birthDate = '';
  String gender;
  String bloodGroup;
  bool _registering = false;

  /* For doctor */
  List specialityList = [];
  String speciality;
  int morningHours;
  int afternoonHours;
  String qualification;
  int experience;

  void _getSpecialities() async {
    try {
      InformationService informationService = InformationService();
      var resp = await informationService.getAllSpecialities();
      setState(() {
        specialityList = resp.data;
      });
    } catch(e) {
      print("Add Doctor = " + e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.doctor) {
      _getSpecialities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _registering,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: ListView(
          padding: kScreenPadding,
          children: [
            Text(
              (widget.doctor)?'Add New Doctor':'Add New Patient',
              style: kHeadTextStyle,
            ),
            SizedBox(height: 10.0,),
            Text(
              displayMessage,
              style: GoogleFonts.notoSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: (displayError)?Colors.redAccent:Colors.green
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                    update: true,
                    onChange: (newVal) {
                      username = newVal;
                    },
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
                      iconData: FontAwesomeIcons.solidUserCircle,
                      labelText: 'First Name',
                      hintText: 'Enter First Name',
                      update: true,
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
                      onChange: (newVal){
                        phoneNumber = newVal;
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
                    update: true,
                  ),
                  SizedBox(height: 20.0,),
                  CustomDropdownButton(
                    value: gender,
                    items: genderList,
                    onChange: (newVal) {
                      setState(() {
                        gender = newVal;
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
                    items: bloodGroupList,
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
                  (widget.doctor)?_doctorInformation():Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            setState(() {
                              _registering = true;
                            });
                            try {
                              ManageUserService manageUserService = ManageUserService();
                              var resp = await manageUserService.addANewUser(
                                  username, firstName, lastName, gender, birthDate, phoneNumber, email, bloodGroup
                              );

                              setState(() {
                                _registering = false;
                                displayError = false;
                                displayMessage = resp.data;
                              });
                            } catch(e) {
                              setState(() {
                                displayMessage = e.response.data['message'];
                                displayError = true;
                                _registering = false;
                              });
                              print("Add Patient:" + e.response.data);
                            }
                          }
                        },
                        child: Text(
                            'Add User'
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _doctorInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdownButton(
          items: _generateSpecialityList(),
          onChange: (newVal) {
            setState(() {
              speciality = newVal;
            });
          },
          value: speciality,
          radius: 5.0,
          hintText: 'Select Doctor Speciality',
          iconData: FontAwesomeIcons.userTag,
          labelText: 'Speciality',
        ),
        SizedBox(height: 20.0,),
        CustomLabelTextField(
          validator: (value) {return null;},
          onChange: (newVal) {
            morningHours = int.parse(newVal);
          },
          iconData: FontAwesomeIcons.sun,
          labelText: 'Morning',
          hintText: 'Enter Morning Appointment Hours',
          update: true,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.0,),
        CustomLabelTextField(
          validator: (value) {return null;},
          onChange: (newVal) {
            afternoonHours = int.parse(newVal);
          },
          iconData: FontAwesomeIcons.solidSun,
          labelText: 'Afternoon',
          hintText: 'Enter Afternoon Appointment Hours',
          update: true,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.0,),
        CustomLabelTextField(
          validator: (value) {return null;},
          onChange: (newVal) {
            qualification = newVal;
          },
          iconData: FontAwesomeIcons.graduationCap,
          labelText: 'Qualification',
          hintText: 'Enter Qualification',
          update: true,
        ),
        SizedBox(height: 20.0,),
        CustomLabelTextField(
          validator: (value) {return null;},
          onChange: (newVal) {
            experience = int.parse(newVal);
          },
          iconData: FontAwesomeIcons.stethoscope,
          labelText: 'Experience',
          hintText: 'Enter Experience',
          update: true,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.0,),
        ElevatedButton(
          onPressed: () async {
              if(_formKey.currentState.validate()) {
                setState(() {
                  _registering = true;
                });
                try {
                  ManageUserService manageUserService = ManageUserService();
                  await manageUserService.addNewDoctor(
                      username, firstName, lastName, gender, birthDate, phoneNumber,
                      email, bloodGroup, speciality, (morningHours*60/5.0),
                      (afternoonHours*60/5.0), qualification, experience
                  );

                  setState(() {
                    _registering = false;
                    displayError = false;
                    displayMessage = 'Doctor Registered Successfully';
                  });
                } catch(e) {
                  setState(() {
                    _registering = false;
                    displayError = true;
                    displayMessage = e.response.data['message'];
                  });
                  print("Add Doctor: " + e.response.data);
                }
              }
          },
          child: Text('Add Doctor'),
          style: ElevatedButton.styleFrom(primary: kPrimaryColor),
        )
      ],
    );
  }

  List<DropdownMenuItem> _generateSpecialityList() {
    List<DropdownMenuItem> returnList = [];
    for(var i in specialityList) {
      returnList.add(
          DropdownMenuItem(
            child: Center(child: Text(i['speciality'])),
            value: i['speciality'],
          )
      );
    }
    return returnList;
  }

}
