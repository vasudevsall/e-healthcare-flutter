import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/account/change_password.dart';
import 'package:e_healthcare/screens/patient/account/update_information.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountInformation extends StatefulWidget {

  final data;
  AccountInformation({
    @required this.data,
  }):assert(data != null);

  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {

  int appointmentNumber = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return PatientScaffold(
      drawer: PatientDrawer(data: widget.data,),
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
                    name: '${widget.data['firstName']} ${widget.data['lastName']}',
                    url: widget.data['profile'],
                    gender: widget.data['gender'],
                    data: widget.data,
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
                  _generateRowData('Username:', widget.data['username']),
                  _generateRowData('Phone:', '+91-${widget.data['phoneNumber']}'),
                  _generateRowData('Email Id:', widget.data['email']),
                  _generateRowData('Birth Date:', widget.data['birthDate']),
                  _generateRowData('Blood Group:', widget.data['bloodGroup']),
                  _generateRowData('Gender:', (widget.data['gender'] == 'M')? 'Male' : (widget.data['gender'] == 'F')? 'Female':'Other'),
                  SizedBox(height: 30.0,),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
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
