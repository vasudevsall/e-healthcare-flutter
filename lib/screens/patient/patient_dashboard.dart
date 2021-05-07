import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientDashboard extends StatefulWidget {
  final data;
  PatientDashboard({
    @required this.data
  });

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    return PatientScaffold(
      drawer: PatientDrawer(data: widget.data,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              child: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryLight
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.all(25.0),
              decoration: kDashBoxDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Welcome, ${widget.data['firstName']} ${widget.data['lastName']}!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Text(
                    "Let's check your health with us",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.7)
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                    "Connect to Doctor",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  SearchTextField(
                    onSubmitted: (value){
                      //TODO: On Pressed, search Doctor
                    },
                    onChanged: (newVal){
                      //TODO: On change
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          //TODO: Advanced Search
                        },
                        child: Text(
                          'Advanced Search',
                          style: GoogleFonts.montserrat(
                            color: kPrimaryLight,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 15.0,),

            Container(
              padding: EdgeInsets.all(25.0),
              decoration: kDashBoxDecoration,
            ),
          ],
        ),
      ),
    );
  }
}