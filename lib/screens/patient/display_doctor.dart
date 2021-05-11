import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/new_appointment.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayDoctors extends StatefulWidget {

  static const int MODE_USERNAME = 1;
  static const int MODE_SPECIALITY = 2;

  final data;
  final int mode;
  final String query;
  DisplayDoctors({
    @required this.data,
    this.mode = MODE_SPECIALITY,
    this.query
  });
  @override
  _DisplayDoctorsState createState() => _DisplayDoctorsState();
}

class _DisplayDoctorsState extends State<DisplayDoctors> {
  var doctorList;
  bool doctorListAvailable = false;

  void _getDoctors() async {
    InformationService informationService = InformationService();

    try {
      var resp;
      if(widget.mode == DisplayDoctors.MODE_USERNAME)
        resp = await informationService.getDoctorByUsername(widget.query);
      else if(widget.mode == DisplayDoctors.MODE_SPECIALITY) {
        if (widget.query == null || widget.query == 'All Doctors')
          resp = await informationService.getAllDoctors();
        else
          resp = await informationService.getDoctorBySpeciality(widget.query);
      }
      setState(() {
        doctorList = resp.data;
        doctorListAvailable = true;
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getDoctors();
  }


  @override
  Widget build(BuildContext context) {
    return PatientScaffold(
      drawer: PatientDrawer(data: widget.data,),
      body: _getDoctorList(),
    );
  }

  Widget _getDoctorList() {
    if(!doctorListAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
          child: Text(
            'Select Doctor',
            style: kDashBoxHeadTextStyle.copyWith(
                color: kPrimaryLight
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            childAspectRatio: 0.85,
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            children: _generateDoctorList(),
          ),
        ),
      ]
    );
  }

  List<Widget> _generateDoctorList() {
    List<Widget> list = [];

    for(var i in doctorList) {
      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewAppointment(username: i['userId']['username'], data: widget.data,);
            }));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [BoxShadow(offset: Offset(1.0, 1.0), color: Colors.black.withOpacity(0.2), blurRadius: 5.0)]
            ),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: kDarkBackColor.withOpacity(0.5),
                    backgroundImage: getImageUrl(i['userId']['profile'], i['userId']['gender']),
                  ),
                  SizedBox(height: 15.0,),
                  Text(
                    'Dr. ${i['userId']['firstName']} ${i['userId']['lastName']}',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Text(
                    i['speciality']['speciality'],
                    style: GoogleFonts.montserrat(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return NewAppointment(username: i['userId']['username'], data: widget.data,);
                      }));
                    },
                    child: Center(
                      child: Text(
                        'Appointment',
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                      )
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kDarkBackColor.withOpacity(0.5))
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      );
    }

    return list;
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
