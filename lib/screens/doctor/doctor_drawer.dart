import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/login_screen.dart';
import 'package:e_healthcare/screens/patient/account/account_information.dart';
import 'package:e_healthcare/screens/patient/account/update_information.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'doctor_analysis.dart';


class DoctorDrawer extends StatefulWidget {
  final data;
  DoctorDrawer({
    @required this.data
  });

  @override
  _DoctorDrawerState createState() => _DoctorDrawerState();
}

class _DoctorDrawerState extends State<DoctorDrawer> {

  String name = '';
  String gender = '';
  String url = '';
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      name = "${widget.data['firstName']} ${widget.data['lastName']}";
      gender = widget.data['gender'];
      url = widget.data['profile'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loggingOut,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 350.0,
              child: DrawerHeader(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                child: Container(
                    child: Profile(
                      url: url,
                      name: name,
                      gender: gender,
                      data: widget.data,
                      style: GoogleFonts.montserrat(
                        color: kBackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                ),
                decoration: BoxDecoration(
                    color: kPrimaryColor
                ),
              ),
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.solidUserCircle),
                  SizedBox(width: 20.0,),
                  Text('My Account'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AccountInformation(data: widget.data);
                }));
              },
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.userCog),
                  SizedBox(width: 20.0,),
                  Text('Account Settings'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UpdateInformation(data: widget.data,);
                }));
              },
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.chartPie),
                  SizedBox(width: 20.0,),
                  Text('Analysis'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DoctorAnalysis(data: widget.data);
                }));
              },
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.signOutAlt),
                  SizedBox(width: 20.0,),
                  Text('Log Out'),
                ],
              ),
              onTap: () async {

                bool logOut = await _showMyDialog();

                if(logOut) {
                  try {
                    setState(() {
                      _loggingOut = true;
                    });
                    LoginService loginService = LoginService();
                    await loginService.logoutUser();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                      return LoginScreen();
                    }), (route) => false);
                  } catch(e) {
                    print(e.response.data);
                  }
                }
              },
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
        return AlertDialog(
          title: Text('Are you Sure ?',),
          titleTextStyle: GoogleFonts.notoSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black
          ),
          actions: <Widget>[
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
                  primary: Colors.red
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
                  primary: Colors.green
              ),
            ),
          ],
        );
      },
    );
  }
}
