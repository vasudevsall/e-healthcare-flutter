import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_appointment.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/doctor_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDashboard extends StatefulWidget {
  final data;
  DoctorDashboard({
    this.data,
  }):assert(data!=null);
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {

  var upcomingDetails;
  bool upcomingDetailsAvailable = false;
  bool canStart = false;

  Future<void> _getUpcomingDetails() async {
    try {
      DoctorService doctorService = DoctorService();

      var resp = await doctorService.getUpcomingSlotDetails();
      setState(() {
        upcomingDetails = resp.data;
        upcomingDetailsAvailable = true;
      });
    } catch(e) {
      print(e);
    }
  }

  void _getNextSessionTime() async {
    await _getUpcomingDetails();

    List date = upcomingDetails['date'].split('-');
    String slot = upcomingDetails['slot'];
    DateTime start;
    DateTime end;
    
    if(slot == 'M') {
      start = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), 9, 00);
      end = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), 12, 00);
    } else {
      start = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), 14, 00);
      end = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), 17, 00);
    }

    print(start);
    print(end);

    if(DateTime.now().isAfter(start) && DateTime.now().isBefore(end)) {
      setState(() {
        canStart = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getNextSessionTime();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: DoctorDrawer(data: widget.data,),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        children: [
          Text(
            'Dashboard',
            style: kHeadTextStyle,
          ),
          SizedBox(height: 20.0,),
          Container(
            padding: EdgeInsets.all(25.0),
            decoration: kDashBoxDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome,',
                        style: kDashBoxHeadTextStyle,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          'Dr. ${widget.data['firstName']} ${widget.data['lastName']}',
                          style: kDashBoxHeadTextStyle.copyWith(
                            fontSize: 20.0
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: kDarkBackColor.withOpacity(0.5),
                  backgroundImage: getImageUrl(widget.data['profile'], widget.data['gender']),
                )
              ],
            ),
          ),
          SizedBox(height: 15.0,),
          Container(
            padding: EdgeInsets.all(25.0),
            decoration: kDashBoxDecoration,
            child: _formUpcomingSession(),
          )
        ],
      ),
    );
  }

  Widget _formUpcomingSession() {
    if(!upcomingDetailsAvailable) {
      return Center(
        child: kDashBoxSpinner,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            'Next Session:',
            style: kDashBoxHeadTextStyle,
          ),
        ),
        Divider(color: Colors.white,),
        SizedBox(height: 20.0,),
        Container(
          decoration: kDashBoxDecoration.copyWith(
            color: Colors.white
          ),
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _generateRowData('Date:', upcomingDetails['date']),
              _generateRowData('Slot:', (upcomingDetails['slot'] == 'M')?'Morning':'Afternoon'),
              _generateRowData('Start Time:', (upcomingDetails['slot'] == 'M')?'9:00 AM':'2:00 PM'),
              _generateRowData('Patients:', '${upcomingDetails['patients'] - upcomingDetails['cancelled']}'),
              _generateRowData('Estimated Time:', '${(upcomingDetails['blocks'] * 5).ceil()} min')
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        ElevatedButton(
          onPressed: (canStart)?() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DoctorAppointment(data: widget.data);
            }));
          }:null,
          child: Text('Start Session'),
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
            textStyle: GoogleFonts.notoSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w700
            )
          ),
        )
      ],
    );
  }

  Widget _generateRowData(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w700
            ),
          ),
          Text(
              value,
              style: GoogleFonts.notoSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w700
              )
          )
        ],
      ),
    );
  }

  ImageProvider getImageUrl(String url, String gender) {
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
