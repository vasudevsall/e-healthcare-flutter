import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/screens/patient/search_doctor.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:e_healthcare/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentList extends StatefulWidget {

  final data;
  final bool past;
  final bool cancel;
  AppointmentList({
    this.data,
    this.past = true,
    this.cancel = false
  });

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {

  var appointmentList;
  bool listAvailable = false;

  void _getPastAppointmentData() async {
    AppointmentService appointmentService = AppointmentService();

    try {
      var resp;
      if(widget.past)   resp = await appointmentService.getPastAppointments();
      else  resp = await appointmentService.getScheduledAppointments();
      setState(() {
        appointmentList = resp.data;
        listAvailable = true;
      });

    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getPastAppointmentData();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: PatientDrawer(data: widget.data,),
      body: _getPastAppointments()
    );
  }

  Widget _getPastAppointments() {
    if(!listAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    } else if(appointmentList.length == 0) {
      return Center(
        child: Column(
          children: [
            Text(
              'No Appointments Scheduled',
              style: GoogleFonts.notoSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),
            ),
            RoundedButton(
              color: kSecondColor,
              text: 'Schedule New',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchDoctor(data: widget.data);
                }));
              }
            )
          ],
        ),
      );
    }

    List<Widget> itemList = _generateAppointmentList();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return itemList[index];
      },
    );
  }

  List<Widget> _generateAppointmentList() {
    List<Widget> returnList = [];

    returnList.add(
        Text(
          (widget.past)?'Past Appointments':(widget.cancel)?'Select Appointment to Cancel':'Scheduled Appointments',
          style: kDashBoxHeadTextStyle.copyWith(
              color: kPrimaryLight
          ),
        )
    );

    for(var i in appointmentList) {
      returnList.add(
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: kDashBoxDecoration,
          child: AppointmentCard(data: widget.data, appointmentData: i),
        ),
      );
    }

    return returnList;
  }
}
