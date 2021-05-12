import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          )
        ],
      ),
    );
  }
}
