import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/account/change_password.dart';
import 'package:e_healthcare/screens/patient/account/update_information.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountInformation extends StatefulWidget {

  final data;
  final userData;
  final bool displayEdit;
  AccountInformation({
    @required this.data,
    this.userData,
    this.displayEdit = true,
  }):assert(data != null);

  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {

  int appointmentNumber = 0;
  var userData;

  void _getAppointmentCount() async {
    AppointmentService appointmentService = AppointmentService();
    try {
      var resp = await appointmentService.getPastAppointments();
      setState(() {
        appointmentNumber = resp.data.length;
      });

    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppointmentCount();

    setState(() {
      if(widget.userData == null) {
        userData = widget.data;
      } else {
        userData = widget.userData;
      }
    });
  }

  Widget _getDrawer() {
    if(widget.data['roles'] == kUser) {
      return PatientDrawer(data: widget.data);
    }else if(widget.data['roles'] == kDoctor) {
      return DoctorDrawer(data: widget.data);
    } else {
      return ManagerDrawer(data: widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: _getDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox.expand(
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: kDashBoxDecoration,
            child: Container(
              padding: EdgeInsets.all(25.0),
              decoration: kDashBoxDecoration.copyWith(
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Profile(
                    name: '${userData['firstName']} ${userData['lastName']}',
                    url: userData['profile'],
                    gender: userData['gender'],
                    data: userData,
                    changePicture: widget.displayEdit,
                    style: GoogleFonts.libreFranklin(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                      color: kDarkBackColor
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Divider(
                    color: kPrimaryOther,
                    thickness: 0.5,
                  ),
                  _generateRowData('Username:', userData['username']),
                  _generateRowData('Phone:', '+91-${userData['phoneNumber']}'),
                  _generateRowData('Email Id:', userData['email']),
                  _generateRowData('Birth Date:', userData['birthDate']),
                  _generateRowData('Blood Group:', userData['bloodGroup']),
                  _generateRowData('Gender:', (userData['gender'] == 'M')? 'Male' : (userData['gender'] == 'F')? 'Female':'Other'),
                  SizedBox(height: 30.0,),
                  _generateEditButtons()
                ],
              ),
            ),
          ),
        ),
      ),
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
              fontSize: 14.0
            ),
          ),
          Text(
            value,
            style: GoogleFonts.notoSans(
                fontSize: 14.0
            )
          )
        ],
      ),
    );
  }

  Widget _generateEditButtons() {
    if(!widget.displayEdit) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UpdateInformation(data: widget.data,);
            }));
          },
          child: Text(
            'Update Details',
            style: GoogleFonts.libreFranklin(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: kPrimaryLighter
          ),
        ),
        SizedBox(height: 5.0,),
        ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (
                context) {
              return ChangePassword(data: widget.data,);
            }));
          },
          child: Text(
            'Change Password',
            style: GoogleFonts.libreFranklin(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: kPrimaryLighter
          ),
        ),
      ],
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
