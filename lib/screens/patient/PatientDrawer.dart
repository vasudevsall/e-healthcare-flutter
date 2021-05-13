import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/login_screen.dart';
import 'package:e_healthcare/services/login_service.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'account/account_information.dart';
import 'account/update_information.dart';
import 'appointment_list.dart';

class PatientDrawer extends StatefulWidget {
  final data;
  PatientDrawer({
    @required this.data
  });

  @override
  _PatientDrawerState createState() => _PatientDrawerState();
}

class _PatientDrawerState extends State<PatientDrawer> {

  String name = '';
  String gender = '';
  String url = '';

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
    return Drawer(
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
                Icon(FontAwesomeIcons.solidCalendarAlt),
                SizedBox(width: 20.0,),
                Text('My Appointments'),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AppointmentList(data: widget.data, past: false);
              }));
            },
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
                Text('Settings'),
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
                Icon(FontAwesomeIcons.signOutAlt),
                SizedBox(width: 20.0,),
                Text('Log Out'),
              ],
            ),
            onTap: () async {
              try {
                LoginService loginService = LoginService();
                await loginService.logoutUser();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                  return LoginScreen();
                }), (route) => false);
              } catch(e) {
                print(e.response.data);
              }
            },
          ),
        ],
      ),
    );
  }
}
