import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class DoctorDetailAppointment extends StatefulWidget {
  final data;
  final String username;

  DoctorDetailAppointment({
    @required this.data,
    @required this.username
  }):assert(data!=null);
  @override
  _DoctorDetailAppointmentState createState() => _DoctorDetailAppointmentState();
}

class _DoctorDetailAppointmentState extends State<DoctorDetailAppointment> {

  var details;
  bool detailsAvailable = false;
  List<String> dateList = [];
  List<String> slots = ['Morning', 'Afternoon'];
  //TODO: Adding type video/offline
  List<String> todaySlots = [];
  int selectedDay = -1;
  String selectedSlot = '';
  String scheduleError = '';

  void _getDoctorDetails() async {
    InformationService informationService = InformationService();
    try {
      var resp = await informationService.getDoctorByUsername(widget.username);

      setState(() {
        details = resp.data;
        detailsAvailable = true;
      });

    } catch(e) {
      print(e);
    }
  }

  void _createDateList() {
    DateTime now = DateTime.now().toLocal();
    dateList.add('${now.year}-${now.month}-${now.day}');

    DateTime nextDay = DateTime(now.year, now.month, now.day + 1);
    dateList.add('${nextDay.year}-${nextDay.month}-${nextDay.day}');

    if(now.hour < 9) {
      todaySlots.add('Morning');
      todaySlots.add('Afternoon');
    } else if(now.hour < 12) {
      todaySlots.add('Afternoon');
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getDoctorDetails();
    _createDateList();
  }

  @override
  Widget build(BuildContext context) {
    return PatientScaffold(
      drawer: PatientDrawer(data: widget.data,),
      body: _doctorDetails(),
    );
  }

  Widget _doctorDetails() {
    if(!detailsAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      children: [
        Container(
          padding: EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dr. ${details['userId']['firstName']} ${details['userId']['lastName']}',
                    style: kDashBoxHeadTextStyle.copyWith(
                      fontSize: 20.0
                    ),
                  ),
                  Text(
                    details['speciality']['speciality'],
                    style: kSubTextStyle.copyWith(
                      color: kDarkBackColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    details['qualification'],
                    style: kDashBoxHeadTextStyle.copyWith(
                      fontSize: 18.0
                    ),
                  )
                ],
              ),
              CircleAvatar(
                radius: 60.0,
                backgroundColor: kDarkBackColor.withOpacity(0.5),
                backgroundImage: getImageUrl(details['userId']['profile'], details['userId']['gender']),
              )
            ],
          ),
          decoration: kDashBoxDecoration,
        ),
        SizedBox(height: 20.0,),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 7.5),
                  padding: EdgeInsets.all(15.0),
                  decoration: kDashBoxDecoration.copyWith(
                      color: Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Patients',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: kDarkBackColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: '500+ ',
                              style: GoogleFonts.notoSans(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor
                              ),
                          )
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 7.5),
                  padding: EdgeInsets.all(15.0),
                  decoration: kDashBoxDecoration.copyWith(
                    color: Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Experience',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: kDarkBackColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${details['experience']}+ ',
                          style: GoogleFonts.notoSans(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor
                          ),
                          children: [
                            TextSpan(
                              text: 'Years',
                              style: GoogleFonts.montserrat(
                                color: kPrimaryLight,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700
                              )
                            )
                          ]
                        )
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0,),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 7.5),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      //TODO: Open phone app
                    },
                    icon: Icon(
                      Icons.smartphone,
                      size: 20.0,
                      color: kDarkBackColor,
                    ),
                    label: Flexible(
                      child: Text(
                        details['userId']['phoneNumber'],
                        style: GoogleFonts.libreFranklin(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: kDarkBackColor
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 7.5),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      //TODO: Open mail app
                    },
                    icon: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      size: 20.0,
                      color: kDarkBackColor,
                    ),
                    label: Flexible(
                      child: Text(
                        details['userId']['email'],
                        style: GoogleFonts.libreFranklin(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kDarkBackColor
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        SizedBox(height: 20.0,),
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: kDashBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Schedule Appointment',
                style: kDashBoxHeadTextStyle,
              ),
              Divider(
                color: Colors.white,
              ),
              Text(
                scheduleError,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: kRedColor
                ),
              ),
              SizedBox(height: 5.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Day:',
                    style: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kDarkBackColor
                    ),
                  ),
                  GroupButton(
                    buttons: dateList,
                    onSelected: (index, isSelected) {
                      setState(() {
                        selectedDay = index;
                        scheduleError = '';
                        selectedSlot = '';
                      });
                    },
                    isRadio: true,
                    spacing: 10.0,
                    borderRadius: BorderRadius.circular(5.0),
                    unselectedColor: Colors.transparent,
                    unselectedBorderColor: Colors.white,
                    unselectedTextStyle: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    ),
                    selectedColor: Colors.white,
                    selectedBorderColor: kPrimaryColor,
                    selectedTextStyle: GoogleFonts.notoSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor
                    ),
                  )
                ],
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Time:',
                    style: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kDarkBackColor
                    ),
                  ),
                  GroupButton(
                    buttons: (selectedDay == 0)? todaySlots:slots,
                    onSelected: (index, isSelected){
                      if(selectedDay == 0) {
                        setState(() {
                          selectedSlot = todaySlots[index][0];
                          scheduleError = '';
                        });
                      } else {
                        setState(() {
                          selectedSlot = slots[index][0];
                          scheduleError = '';
                        });
                      }
                    },
                    isRadio: true,
                    spacing: 10.0,
                    borderRadius: BorderRadius.circular(5.0),
                    unselectedColor: Colors.transparent,
                    unselectedBorderColor: Colors.white,
                    unselectedTextStyle: GoogleFonts.notoSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),
                    selectedColor: Colors.white,
                    selectedBorderColor: kPrimaryColor,
                    selectedTextStyle: GoogleFonts.notoSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor
                    ),
                  )
                ],
              ),
              SizedBox(height: 15.0,),
              ElevatedButton(
                onPressed: () {
                  if(selectedDay == -1) {
                    setState(() {
                      scheduleError = 'Select Appointment Date';
                    });
                  } else if(selectedSlot == '') {
                    setState(() {
                      scheduleError = 'Select Appointment Slot';
                    });
                  } else {
                    //TODO: Appointment scheduling
                  }
                },
                child: Text(
                  'Schedule Appointment',
                  style: GoogleFonts.montserrat(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: kSecondColor
                ),
              )
            ],
          ),
        )
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
