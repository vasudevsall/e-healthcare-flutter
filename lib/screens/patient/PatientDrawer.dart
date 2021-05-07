import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:flutter/material.dart';

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
      url = widget.data['url'];
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
