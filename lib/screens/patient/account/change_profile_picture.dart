import 'dart:io';

import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_dashboard.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/manager/manager_dashboard.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/widgets/custom_label_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../patient_dashboard.dart';
import '../user_scaffold.dart';

class ChangeProfilePicture extends StatefulWidget {
  final data;
  ChangeProfilePicture({
    @required this.data
  });
  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  bool selected = false;
  final picker = ImagePicker();
  File _imageFile;
  String url;
  bool _updating = false;
  String displayMess = '';
  bool error = false;
  String password = '';
  bool cancelButton = false;
  var userData;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _updating,
      child: UserScaffold(
        drawer: _getDrawer(),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
          children: [
            Text('Change Profile Picture', style: kHeadTextStyle,),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: kDashBoxDecoration,
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: kDashBoxDecoration.copyWith(
                  color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      minRadius: 100.0,
                      maxRadius: 150.0,
                      backgroundColor: kDarkBackColor.withOpacity(0.5),
                      backgroundImage: getImageUrl(widget.data['profile'], widget.data['gender']),
                    ),
                    SizedBox(height: 40.0,),
                    ElevatedButton(
                        onPressed: () async {
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);

                          setState(() {
                            _imageFile = File(pickedFile.path);
                          });
                        },
                      child: Text('Select Image'),
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryLighter
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    ElevatedButton(
                      onPressed: () async {
                        bool confirm = await _showMyDialog();
                        if(confirm) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                            return _getDashboard();
                          }), (route) => false);
                        }
                      },
                      child: Text('Upload Image'),
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor
                      ),
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

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
                      /* Removing focus from password field */
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if(!cancelButton) {
                        /* Display spinner */
                        setState(() {
                          _updating = true;
                        });
                        /* Upload to Firebase storage */
                        if(url == null) {
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference reference = storage.ref().child(
                              "profile/image1" + DateTime.now().toString());
                          UploadTask uploadTask = reference.putFile(_imageFile);
                          await uploadTask.then((res) async {
                            url = await res.ref.getDownloadURL();
                            setState(() {});
                          });
                        }
                        print(url);
                        /* Update Profile Picture in database */
                        try {
                          LoginService loginService = LoginService();
                          var resp = await loginService.updateProfilePicture(
                              password,
                              url
                          );
                          print(resp.data);
                          setState(() {
                            cancelButton = true;
                            userData = resp.data;
                            error = false;
                            displayMess = 'Profile Picture Updated Successfully!';
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

  ImageProvider getImageUrl(String url, String gender) {
    if(_imageFile!=null) {
      return FileImage(_imageFile);
    }
    if(url == null || url == '') {
      if(gender == 'M') {
        return AssetImage('images/male.png');
      } else {
        return AssetImage('images/female.png');
      }
    } else {
      return NetworkImage(url);
    }
  }
}
