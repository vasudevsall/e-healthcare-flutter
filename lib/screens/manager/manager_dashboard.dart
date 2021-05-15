import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/rooms/admit_patient.dart';
import 'package:e_healthcare/screens/manager/rooms/room_current.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/count_service.dart';
import 'package:e_healthcare/widgets/dash_item_tile.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:e_healthcare/widgets/welcome_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'manager_drawer.dart';

class ManagerDashboard extends StatefulWidget {
  final data;
  ManagerDashboard({
    @required this.data
  });
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {

  var appointmentCount;
  var userCount;
  var roomCount;
  bool appointmentCountAvailable = false;
  bool userCountAvailable = false;
  bool roomCountAvailable = false;

  void _getAppointmentCount() async {
    try {
      CountService countService = CountService();
      var resp = await countService.getAppointmentCount();

      setState(() {
        appointmentCount = resp.data;
        appointmentCountAvailable = true;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  void _getUserCount() async {
    try {
      CountService countService = CountService();
      var resp = await countService.getUserCount();

      setState(() {
        userCount = resp.data;
        userCountAvailable = true;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  void _getRoomCount() async {
    try {
      CountService countService = CountService();
      var resp = await countService.getRoomCount();

      setState(() {
        roomCount = resp.data;
        roomCountAvailable = true;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppointmentCount();
    _getRoomCount();
    _getUserCount();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: ManagerDrawer(data: widget.data),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        children: [
          Text(
            'Dashboard',
            style: kHeadTextStyle,
          ),
          SizedBox(height: 20.0,),
          WelcomeBox(
            name: '${widget.data['firstName']} ${widget.data['lastName']}',
            url: widget.data['profile'],
            gender: widget.data['gender']
          ),
          SizedBox(height: 20.0,),
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration,
            child: _generateCurrentStatus()
          ),
          SizedBox(height: 10.0,),
          Divider(color: kPrimaryOther,),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Admissions',
                style: kHeadTextStyle,
              ),
              SizedBox(
                height: 110.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    DashItemTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AdmitPatient(data: widget.data);
                        }));
                      },
                      icon: FontAwesomeIcons.hospitalUser,
                      text: 'Admit\nPatient'
                    ),
                    DashItemTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return RoomCurrentStatus(data: widget.data);
                        }));
                      },
                      icon: FontAwesomeIcons.procedures,
                      text: 'Admitted Patients'
                    ),
                    DashItemTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return RoomCurrentStatus(data: widget.data);
                        }));
                      },
                      icon: FontAwesomeIcons.userMinus,
                      text: 'Discharge Patient'
                    )
                  ],
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Rooms',
                style: kHeadTextStyle,
              ),
              SizedBox(
                height: 110.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    DashItemTile(
                        onTap: () {
                          //TODO Implement Method (Admit Patient)
                        },
                        icon: FontAwesomeIcons.solidHospital,
                        text: 'Room\nStatus'
                    ),
                    DashItemTile(
                        onTap: () {
                          //TODO Implement Method (Admitted Patients)
                        },
                        icon: FontAwesomeIcons.plusSquare,
                        text: 'Add New Room'
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _generateCurrentStatus() {
    if(!appointmentCountAvailable || !userCountAvailable || !roomCountAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration.copyWith(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Status',
                style: kHeadTextStyle,
              ),
              SizedBox(height: 5.0,),
              Divider(color: kPrimaryColor,),
              SizedBox(height: 10.0,),
              SimpleRowData(title: 'Total Users', value: userCount[kUser].toString()),
              SimpleRowData(title: 'Total Doctors', value: userCount[kDoctor].toString()),
              SimpleRowData(title: 'Beds Available', value: roomCount['W']['available'].toString()),
              SimpleRowData(title: 'ICUs Available', value: roomCount['I']["available"].toString()),
              SimpleRowData(title: 'OTs Available', value: (roomCount['O'] == null)? '0':roomCount['O']['available'].toString()),
            ],
          ),
        ),
        SizedBox(height: 5.0,),
        ElevatedButton(
          onPressed: () {
            //TODO: On Pressed
          },
          child: Text(
            'More Details',
          ),
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor
          ),
        )
      ],
    );
  }
}
