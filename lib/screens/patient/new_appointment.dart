import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/doctor_details.dart';
import 'package:e_healthcare/screens/patient/patient_dashboard.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewAppointment extends StatefulWidget {
  final data;
  final String username;

  NewAppointment({
    @required this.data,
    @required this.username
  }):assert(data!=null);
  @override
  _NewAppointmentState createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {

  var details;
  bool detailsAvailable = false;
  List<String> dateList = [];
  List<String> slots = ['Morning', 'Afternoon'];
  List<String> type = ['Offline', 'Video'];
  List<String> todaySlots = [];
  int selectedDay = -1;
  String selectedSlot = '';
  String selectedType = '';
  String scheduleError = '';
  bool error = true;
  bool _scheduling = false;

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
    dateList.add('${now.year}-${(now.month < 10)?'0${now.month}':now.month}-${now.day}');

    DateTime nextDay = DateTime(now.year, now.month, now.day + 1);
    dateList.add('${nextDay.year}-${(nextDay.month < 10)?'0${nextDay.month}':nextDay.month}-${nextDay.day}');

    if(now.hour < 9) {
      todaySlots.add('Morning');
      todaySlots.add('Afternoon');
    } else if(now.hour < 15) {//TODO Backto12
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
    return ModalProgressHUD(
      inAsyncCall: _scheduling,
      child: UserScaffold(
        drawer: PatientDrawer(data: widget.data,),
        body: _doctorDetails(),
      ),
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
        DoctorDetails(details: details),
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
                  color: (error)?kRedColor:Colors.green,
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
                        error = true;
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
                          error = true;
                        });
                      } else {
                        setState(() {
                          selectedSlot = slots[index][0];
                          scheduleError = '';
                          error = true;
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
                    buttons: type,
                    onSelected: (index, isSelected){
                      setState(() {
                        selectedType = type[index][0];
                        scheduleError = '';
                        error = true;
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
              ElevatedButton(
                onPressed: () async {
                  if(selectedDay == -1) {
                    setState(() {
                      scheduleError = 'Select Appointment Date';
                      error = true;
                    });
                  } else if(selectedSlot == '') {
                    setState(() {
                      scheduleError = 'Select Appointment Slot';
                      error = true;
                    });
                  } else if(selectedType == '') {
                    setState(() {
                      scheduleError = 'Select Appointment Type';
                      error = true;
                    });
                  } else {
                    setState(() {
                      _scheduling = true;
                    });
                    await _scheduleAppointment();
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

  Future<void> _scheduleAppointment() async {
    AppointmentService appointmentService = AppointmentService();
    try {
      var resp = await appointmentService.addNewAppointment(widget.username, dateList[selectedDay], selectedSlot, selectedType);

      setState(() {
        _scheduling = false;
        error = false;
        scheduleError = 'Appointment scheduled successfully!';
      });
    } catch(e) {
      setState(() {
        error = true;
        scheduleError = e.response.data['message'].toString();
        setState(() {
          _scheduling = false;
        });
      });
    }
  }

}
