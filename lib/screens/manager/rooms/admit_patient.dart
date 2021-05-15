import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/manager/rooms/room_status.dart';
import 'package:e_healthcare/screens/manager/users/search_user.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:e_healthcare/services/room_service.dart';
import 'package:e_healthcare/widgets/custom_dropdown.dart';
import 'package:e_healthcare/widgets/custom_label_textfield.dart';
import 'package:e_healthcare/widgets/select_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdmitPatient extends StatefulWidget {
  final data;
  AdmitPatient({
    @required this.data,
  });
  @override
  _AdmitPatientState createState() => _AdmitPatientState();
}

class _AdmitPatientState extends State<AdmitPatient> {
  String roomNo = '';
  String username = '';
  String doctor;
  String diagnosis = '';
  String description = '';
  List specialityList = [];
  List doctorList = [];
  String speciality = '';
  bool _admitting = false;
  String message = '';
  bool error = false;

  void _getSpecialityList() async {
    try {
      InformationService informationService = InformationService();
      var resp = await informationService.getAllSpecialities();
      setState(() {
        specialityList = resp.data;
      });

    } catch(e) {
      print(e.response.data);
    }
  }

  void _getAllDoctors() async {
    try {
      InformationService informationService = InformationService();
      var resp;
      if(speciality == null || speciality == '') {
        resp = await informationService.getAllDoctors();
      } else {
        resp = await informationService.getDoctorBySpeciality(speciality);
      }

      setState(() {
        doctorList = resp.data;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getSpecialityList();
    _getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _admitting,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: ListView(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
          children: [
            Text(
              'Admit Patient',
              style: kHeadTextStyle,
            ),
            SizedBox(height: 15.0,),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: (error)?Colors.redAccent:Colors.green,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'Room Number',
              style: kLabelTextStyle,
            ),
            SelectInput(
              text: roomNo,
              onPressed: () async {
                int room = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RoomStatus(data: widget.data);
                }));
                setState(() {
                  roomNo = (room==null)?'':room.toString();
                });
              },
            ),
            SizedBox(height: 20.0,),
            Text('Patient', style: kLabelTextStyle,),
            SelectInput(
              text: username,
              onPressed: () async {
                String user = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchUser(data: widget.data);
                }));

                setState(() {
                  username = (user==null)?'':user;
                });
              },
            ),
            SizedBox(height: 20.0,),
            Text('Speciality', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomDropdownButton(
              items: _generateSpecialityList(),
              onChange: (newValue) {
                setState(() {
                  speciality = newValue;
                  doctorList = [];
                });
                _getAllDoctors();
              },
              displayLabel: false,
              radius: 5.0,
              value: speciality,
            ),
            SizedBox(height: 20.0,),
            Text('Doctor', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomDropdownButton(
              items: _generateDoctorList(),
              onChange: (newValue) {
                setState(() {
                  doctor = newValue;
                });
              },
              displayLabel: false,
              radius: 5.0,
              value: doctor,
            ),
            SizedBox(height: 20.0,),
            Text('Diagnosis', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newValue) {
                diagnosis = newValue;
              },
              displayLabel: false,
              update: true,
            ),
            SizedBox(height: 20.0,),
            Text('Description', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newValue) {
                description = newValue;
              },
              displayLabel: false,
              update: true,
              maxLines: 4,
            ),
            SizedBox(height: 30.0,),
            ElevatedButton(
              onPressed: () async{
                setState(() {
                  _admitting = true;
                });
                try {
                  RoomService roomService = RoomService();
                  var resp = await roomService.admitPatient(
                      int.parse(roomNo), username, doctor, diagnosis, description
                  );

                  setState(() {
                    message = 'Patient Admitted';
                    _admitting = false;
                    error = false;
                  });
                } catch(e) {
                  print(e);
                  setState(() {
                    message = e.response.data['message'];
                    error = true;
                    _admitting = false;
                  });
                  print(e.response.data);
                }
              },
              child: Text(
                'Admit'
              ),
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> _generateDoctorList() {
    List<DropdownMenuItem> returnList = [];

    for(var i in doctorList) {
      print(i['userId']['username']);
      returnList.add(
        DropdownMenuItem(
          child: Center(
            child: Text(
              'Dr. ${i['userId']['firstName']} ${i['userId']['lastName']}',
            ),
          ),
          value: i['userId']['username'],
        )
      );
    }
    print(returnList);
    return returnList;
  }

  List<DropdownMenuItem> _generateSpecialityList() {
    List<DropdownMenuItem> returnList = [];
    // Add All doctors
    returnList.add(
      DropdownMenuItem(
        child: Center(child: Text('All')),
        value: '',
      )
    );

    for(var i in specialityList) {
      returnList.add(
        DropdownMenuItem(
          child: Center(child: Text(i['speciality'])),
          value: i['speciality'],
        )
      );
    }

    return returnList;
  }
}
