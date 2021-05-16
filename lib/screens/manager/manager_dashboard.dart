import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/rooms/add_room.dart';
import 'package:e_healthcare/screens/manager/rooms/admit_patient.dart';
import 'package:e_healthcare/screens/manager/rooms/room_current.dart';
import 'package:e_healthcare/screens/manager/rooms/room_status.dart';
import 'package:e_healthcare/screens/manager/users/add_new_user.dart';
import 'package:e_healthcare/screens/manager/users/search_user.dart';
import 'package:e_healthcare/screens/patient/search_doctor.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/count_service.dart';
import 'package:e_healthcare/widgets/dash_item_tile.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:e_healthcare/widgets/welcome_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import 'manager_drawer.dart';

class ManagerDashboard extends StatefulWidget {
  final data;
  ManagerDashboard({
    @required this.data
  });
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> with RouteAware {

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
                    ),
                    DashItemTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return RoomStatus(data: widget.data, allowBooking: false,);
                          }));
                        },
                        icon: FontAwesomeIcons.solidHospital,
                        text: 'Room\nStatus'
                    ),
                    DashItemTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return AddRoom(data: widget.data);
                          }));
                        },
                        icon: FontAwesomeIcons.plusSquare,
                        text: 'Add New Room'
                    ),
                  ],
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Users',
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AddNewUser(data: widget.data, doctor: true,);
                          }));
                        },
                        icon: FontAwesomeIcons.userNurse,
                        text: 'Add New Doctor'
                    ),
                    DashItemTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return SearchDoctor(data: widget.data, details: true,);
                          }));
                        },
                        icon: FontAwesomeIcons.userMd,
                        text: 'Doctors'
                    ),
                    DashItemTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AddNewUser(data: widget.data);
                          }));
                        },
                        icon: FontAwesomeIcons.userPlus,
                        text: 'Add New User'
                    ),
                    DashItemTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return SearchUser(data: widget.data, selectPatient: false,);
                          }));
                        },
                        icon: FontAwesomeIcons.solidUser,
                        text: 'Users'
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
        child: kDashBoxSpinner,
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
      appointmentCountAvailable = false;
      userCountAvailable = false;
      roomCountAvailable = false;
    });
    _getAppointmentCount();
    _getRoomCount();
    _getUserCount();
  }
}
