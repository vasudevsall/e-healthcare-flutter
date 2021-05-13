import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_dashboard.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentSuccess extends StatelessWidget {

  final data;
  AppointmentSuccess({
    @required this.data
  });

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: DoctorDrawer(data: data,),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Appointment',
              style: kHeadTextStyle,
            ),
            SizedBox(height: 20.0,),
            Text(
              'Great Work! There are no more appointments for the current session.',
              style: GoogleFonts.notoSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kDarkBackColor
              ),
            ),
            SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return DoctorDashboard(data: data,);
                }), (route) => false);
              },
              child: Text('Dashboard'),
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                textStyle: GoogleFonts.notoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
