import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_healthcare/constants/constants.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    @required this.appointmentData,
    this.marginBottom = false,
  });

  final appointmentData;
  final bool marginBottom;

  ImageProvider getImageUrl(userData) {
    if(userData['url'] == null || userData['url'] == '') {
      if(userData['gender'] == 'M') {
        return AssetImage('images/male.png');
      } else {
        return AssetImage('images/female.png');
      }
    } else {
      return NetworkImage(userData['url']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: Appointment Details
      },
      child: Container(
        margin: EdgeInsets.only(bottom: (marginBottom)? 15.0: 0.0),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: kPurpleColor.withOpacity(0.8),
                  backgroundImage: getImageUrl(appointmentData['doctorId']['userId']),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. ${appointmentData['doctorId']['userId']['firstName']} "
                            "${appointmentData['doctorId']['userId']['lastName']}",
                        style: kHeadTextStyle,
                      ),
                      Text(
                        "Date: ${appointmentData['date']}",
                        style: kSubTextStyle,
                      ),
                      Text(
                        "Slot: ${(appointmentData['slot'] == 'M')? 'Morning': 'Afternoon'}",
                        style: kSubTextStyle,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                  child: Text(
                    'Get Details',
                    style: GoogleFonts.lato(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0)
                      ),
                      color: kSecondColor
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}