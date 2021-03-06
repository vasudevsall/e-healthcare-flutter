import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/appointment_list.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/screens/patient/search_doctor.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:e_healthcare/widgets/RoundedButton.dart';
import 'package:e_healthcare/widgets/appointment_card.dart';
import 'package:e_healthcare/widgets/dash_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import 'account/account_information.dart';
import 'account/change_password.dart';
import 'account/update_information.dart';

class PatientDashboard extends StatefulWidget {
  final data;
  PatientDashboard({
    @required this.data
  });

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> with RouteAware {



  var lastAppointmentData;
  bool lastAppointmentDataAvailable = false;
  bool noLastAppointment = false;
  var scheduledAppointmentsData;
  bool scheduledAppointmentsDataAvailable = false;

  void getAppointmentData() async {
    AppointmentService appointmentService = AppointmentService();

    try {
      var resp = await appointmentService.getPastAppointments();
      setState(() {
        if(resp.data.length == 0)
            noLastAppointment = true;
        else
          lastAppointmentData = resp.data[resp.data.length-1];
        lastAppointmentDataAvailable = true;
      });

    } catch(e) {
      print(e);
    }
  }

  void getScheduledAppointmentData() async {
    AppointmentService appointmentService = AppointmentService();

    try {
      var resp = await appointmentService.getScheduledAppointments();
      setState(() {
        scheduledAppointmentsData = resp.data;
        scheduledAppointmentsDataAvailable = true;
      });

    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointmentData();
    getScheduledAppointmentData();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: PatientDrawer(data: widget.data,),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        children: <Widget>[
          SizedBox(height: 20.0,),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
            decoration: kDashBoxDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Welcome, ${widget.data['firstName']} ${widget.data['lastName']}!",
                  textAlign: TextAlign.center,
                  style: kHeadTextStyle.copyWith(
                    fontSize: 24.0,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 15.0,),
                Text(
                  "Let's check your health with us",
                  textAlign: TextAlign.center,
                  style: kSubTextStyle.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.7)
                  ),
                ),
                SizedBox(height: 5.0,),
                Text(
                  "Connect to Doctor",
                  textAlign: TextAlign.center,
                  style: kHeadTextStyle.copyWith(
                    fontSize: 20.0
                  ),
                ),
                SizedBox(height: 10.0,),
                ElevatedButton(
                  onPressed: () {
                    //TODO Messaging Screen
                  },
                  child: Text('Connect'),
                  style: ElevatedButton.styleFrom(primary: kDarkBackColor.withOpacity(0.6)),
                ),
              ],
            ),
          ),

          SizedBox(height: 15.0,),
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration,
            child: _displayUpcomingAppointmentData(),
          ),

          SizedBox(height: 15.0,),

          Container(
            padding: EdgeInsets.all(25.0),
            decoration: kDashBoxDecoration,
            child: _displayLastAppointmentData(),
          ),

          SizedBox(height: 20.0,),
          Divider(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Appointments',
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
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    DashItemTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SearchDoctor(data: widget.data);
                        }));
                      },
                      icon: FontAwesomeIcons.solidCalendarPlus,
                      text: 'New Appointment',
                      splashColor: Colors.green,
                    ),
                    DashItemTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AppointmentList(data: widget.data);
                        }));
                      },
                      icon: FontAwesomeIcons.notesMedical,
                      text: 'Past Appointments',
                      splashColor: kSecondColor,
                    ),
                    DashItemTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AppointmentList(data: widget.data, past: false);
                        }));
                      },
                      icon: FontAwesomeIcons.calendarDay,
                      text: 'Scheduled Appointments'
                    ),
                    DashItemTile(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AppointmentList(data: widget.data, past: false, cancel: true,);
                        }));
                      },
                      icon: FontAwesomeIcons.solidCalendarTimes,
                      text: 'Cancel Appointment',
                      splashColor: Colors.redAccent,
                    ),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 10.0,),

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

  Widget _displayLastAppointmentData(){
    if(!lastAppointmentDataAvailable) {
      return kDashBoxSpinner;
    } else if(!noLastAppointment) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Last Appointment',
            textAlign: TextAlign.start,
            style: kDashBoxHeadTextStyle,
          ),

          SizedBox(height: 20.0,),
          AppointmentCard(data: widget.data,appointmentData: lastAppointmentData),
        ],
      );
    }
    return Center(
      child: Text(
        'No appointment data',
        textAlign: TextAlign.center,
        style: kDashBoxHeadTextStyle.copyWith(
            fontSize: 14.0,
            color: Colors.black87
        ),
      ),
    );
  }

  Widget _displayUpcomingAppointmentData() {
    if(!scheduledAppointmentsDataAvailable) {
      return kDashBoxSpinner;
    } else if(scheduledAppointmentsData.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'No appointment scheduled',
            textAlign: TextAlign.center,
            style: kDashBoxHeadTextStyle.copyWith(
                fontSize: 14.0,
                color: Colors.black87
            ),
          ),
          SizedBox(height: 10.0,),
          ElevatedButton(
            child: Text('Schedule New'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchDoctor(data: widget.data);
              }));
            },
            style: ElevatedButton.styleFrom(primary: kDarkBackColor.withOpacity(0.6)),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Scheduled Appointments',
          style: kDashBoxHeadTextStyle,
        ),
        SizedBox(height: 20.0,),
        for (var i in scheduledAppointmentsData) AppointmentCard(data: widget.data, appointmentData: i, marginBottom: true,),
        ElevatedButton(
          child: Text('Schedule New'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchDoctor(data: widget.data);
            }));
          },
          style: ElevatedButton.styleFrom(primary: kDarkBackColor.withOpacity(0.6)),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      scheduledAppointmentsDataAvailable = false;
      lastAppointmentDataAvailable = false;
    });
    getScheduledAppointmentData();
    getAppointmentData();
  }
}