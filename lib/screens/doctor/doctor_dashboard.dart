import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_analysis.dart';
import 'package:e_healthcare/screens/doctor/doctor_appointment.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/patient/account/account_information.dart';
import 'package:e_healthcare/screens/patient/account/change_password.dart';
import 'package:e_healthcare/screens/patient/account/update_information.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/doctor_service.dart';
import 'package:e_healthcare/widgets/dash_item_tile.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:e_healthcare/widgets/welcome_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  var trends;
  bool trendsAvailable = false;

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

  void _getTrends() async {
    try {
      DoctorService doctorService = DoctorService();
      var resp = await doctorService.getAnalysis(30);
      setState(() {
        trends = resp.data;
        trendsAvailable = true;
      });
    } catch (e) {
      print(e.response.statusCode);
      print(e.response.message);
    }

  }

  @override
  void initState() {
    super.initState();
    _getTrends();
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
          WelcomeBox(
            name: 'Dr. ${widget.data['firstName']} ${widget.data['lastName']}',
            url: widget.data['profile'],
            gender: widget.data['gender'],
          ),
          SizedBox(height: 15.0,),
          Container(
            padding: EdgeInsets.all(25.0),
            decoration: kDashBoxDecoration,
            child: _formUpcomingSession(),
          ),
          SizedBox(height: 15.0,),
          Container(
            padding: EdgeInsets.all(25.0),
            decoration: kDashBoxDecoration,
            child: _recentTrends(),
          ),
          SizedBox(height: 15.0,),
          Divider(color: kPrimaryColor,),
          SizedBox(height: 5.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Account',
                style: GoogleFonts.libreFranklin(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryLight
                ),
              ),

              SizedBox(height: 10.0,),
              SizedBox(
                height: 110.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    DashItemTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AccountInformation(data: widget.data);
                        }));
                      },
                      icon: FontAwesomeIcons.solidUser,
                      text: 'Account Details',
                    ),
                    DashItemTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return UpdateInformation(data: widget.data,);
                        }));
                      },
                      icon: FontAwesomeIcons.userEdit,
                      text: 'Update Information',
                      splashColor: kSecondColor,
                    ),
                    DashItemTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ChangePassword(data: widget.data,);
                          }));
                        },
                        icon: FontAwesomeIcons.userShield,
                        text: 'Change Password'
                    ),

                  ],
                ),
              )
            ],
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
              SimpleRowData(title: 'Date:', value: upcomingDetails['date']),
              SimpleRowData(title: 'Slot:', value: (upcomingDetails['slot'] == 'M')?'Morning':'Afternoon'),
              SimpleRowData(title: 'Start Time:', value: (upcomingDetails['slot'] == 'M')?'9:00 AM':'2:00 PM'),
              SimpleRowData(title: 'Patients:', value: '${upcomingDetails['patients'] - upcomingDetails['cancelled']}'),
              SimpleRowData(title: 'Estimated Time:', value: '${(upcomingDetails['blocks'] * 5).ceil()} min')
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
        ),
      ],
    );
  }

  Widget _recentTrends() {
    if(!trendsAvailable) {
      return Center(
        child: kDashBoxSpinner,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent Data',
          style: kDashBoxHeadTextStyle,
        ),
        Text(
          '(Last 30 days)',
          style: GoogleFonts.notoSans(
            color: kBackColor,
            fontSize: 10.0,
            fontWeight: FontWeight.w700
          ),
        ),
        Divider(color: Colors.white,),
        SizedBox(height: 20.0,),
        Container(
          decoration: kDashBoxDecoration.copyWith(color: Colors.white),
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              SimpleRowData(title: 'Total Appointments',value: '${trends['patients'] - trends['cancelled']}'),
              SimpleRowData(title: 'Offline Consultations',value: '${trends['patients'] - trends['cancelled'] - trends['video']}'),
              SimpleRowData(title: 'Video Consultations',value: trends['video'].toString()),
              SimpleRowData(title: 'Surgeries',value: trends['operations'].toString())
            ],
          ),
        ),
        SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DoctorAnalysis(data: widget.data);
            }));
          },
          child: Text('More Info'),
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
}
