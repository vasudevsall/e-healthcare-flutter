import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/constants/specialityConstant.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/display_doctor.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchDoctor extends StatefulWidget {

  final data;
  SearchDoctor({
    @required this.data
  });

  @override
  _SearchDoctorState createState() => _SearchDoctorState();
}

class _SearchDoctorState extends State<SearchDoctor> {

  bool listAvailable = false;
  var list;

  void getSpecialities() async {
    InformationService informationService = InformationService();

    try {
      var resp = await informationService.getAllSpecialities();
      setState(() {
        list = resp.data;
        listAvailable = true;
      });

    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getSpecialities();
  }

  @override
  Widget build(BuildContext context) {
    return PatientScaffold(
      drawer: PatientDrawer(data: widget.data),
      body: _specialitiesList()
    );
  }

  Widget _specialitiesList() {
    if(!listAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      shrinkWrap: true,
      children: _generateSpecialityList(),
    );
  }

  List<Widget> _generateSpecialityList() {
    List<Widget> specialityList = [];
    // Adding Heading
    specialityList.add(Text(
      'Select Speciality',
      style: kDashBoxHeadTextStyle.copyWith(
          color: kPrimaryLight
      ),
    ));

    specialityList.add(
      _specialityWidget('All Doctors', 'Miscellaneous')
    );

    for(var i in list) {
        specialityList.add(
          _specialityWidget(i['speciality'], i['skill'])
        );
    }

    return specialityList;
  }

  Widget _specialityWidget(String speciality, String skill) {
    return Container(
          margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Material(
            color: kPrimaryOther.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey.withOpacity(0.5),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DisplayDoctors(data: widget.data, query: speciality,);
                }));
              },
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      specialityIconList[speciality],
                      size: 45.0,
                      color: kPrimaryColor
                    ),
                    SizedBox(width: 50.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          speciality,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.montserrat(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryLight,
                            shadows: [
                              Shadow(color: Colors.black12, blurRadius: 1.0, offset: Offset(1.0, 1.0))
                            ]
                          ),
                        ),
                        Text(
                          skill,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.libreFranklin(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
