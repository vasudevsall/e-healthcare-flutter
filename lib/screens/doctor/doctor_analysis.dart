import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/constants/days_constant.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/patient/account/account_information.dart';
import 'package:e_healthcare/widgets/doctor_details.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/doctor_service.dart';
import 'package:e_healthcare/services/information_service.dart';
import 'package:e_healthcare/services/manage_user_service.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class DoctorAnalysis extends StatefulWidget {
  final data;
  final bool managerRequest;
  final String docUsername;
  DoctorAnalysis({
    @required this.data,
    this.managerRequest = false,
    this.docUsername = '',
  });
  @override
  _DoctorAnalysisState createState() => _DoctorAnalysisState();
}

class _DoctorAnalysisState extends State<DoctorAnalysis> {
  var info;
  var infoAvailable = false;
  int days = 30;
  var docDetails;
  var docDetailsAvailable = false;

  void _getInfoData() async {
    setState(() {
      infoAvailable = false;
    });

    try {
      var resp;

      if(!widget.managerRequest) {
        DoctorService doctorService = DoctorService();
        resp = await doctorService.getAnalysis(days);
      } else {
        ManageUserService manageUserService = ManageUserService();
        resp = await manageUserService.getDoctorDetails(widget.docUsername, days);
      }
      setState(() {
        info = resp.data;
        infoAvailable = true;
      });
    } catch(e) {
      print(e.response);
    }
  }

  void _getDoctorDetails() async {
    try {
      InformationService informationService = InformationService();
      var resp = await informationService.getDoctorByUsername(widget.docUsername);
      setState(() {
        docDetails = resp.data;
        docDetailsAvailable = true;
      });
      _getInfoData();
    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.managerRequest) _getDoctorDetails();
    else _getInfoData();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: DoctorDrawer(data: widget.data,),
      body: _generateAnalysisReport(),
    );
  }

  Widget _generateAnalysisReport() {
    if(!infoAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return ListView(
      padding: kScreenPadding,
      children: [
        (widget.managerRequest)?DoctorDetails(details: docDetails,):SizedBox(),
        (widget.managerRequest)?SizedBox(height: 20.0,):SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent',
              style: kHeadTextStyle,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: kPrimaryColor, width: 1.0)
              ),
              child: DropdownButton(
                isDense: true,
                underline: SizedBox(),
                items: daysList,
                style: GoogleFonts.notoSans(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: kDarkBackColor
                ),
                value: days,
                onChanged: (value) {
                  setState(() {
                    days = value;
                  });
                  _getInfoData();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0,),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration.copyWith(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Appointments',
                  style: kHeadTextStyle.copyWith(
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 5.0,),
                Divider(color: kPrimaryColor,),
                SizedBox(height: 10.0,),
                SimpleRowData(title: 'Total Appointments', value: info['patients'].toString(),),
                SimpleRowData(title: 'Appointments scheduled', value: '${info['patients'] - info['cancelled']}'),
                SimpleRowData(title: 'Appointments Cancelled', value: info['cancelled'].toString(),),
                PieChart(
                  dataMap: _generateAppointmentDataMap(),
                  colorList: colorList,
                  initialAngleInDegree: 90,
                  chartRadius: 160.0,
                  chartValuesOptions: ChartValuesOptions(
                    showChartValuesInPercentage: true
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20.0,),

        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration.copyWith(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Appointment Type',
                  style: kHeadTextStyle.copyWith(
                      fontSize: 16.0
                  ),
                ),
                SizedBox(height: 5.0,),
                Divider(color: kPrimaryColor,),
                SizedBox(height: 10.0,),
                SimpleRowData(title: 'Appointments Scheduled', value: '${info['patients'] - info['cancelled']}',),
                SimpleRowData(title: 'Offline Consultations', value: '${info['patients'] - info['cancelled'] - info['video']}'),
                SimpleRowData(title: 'Video Consultations', value: info['video'].toString(),),
                PieChart(
                  dataMap: _generateAppointmentTypeDataMap(),
                  colorList: colorList,
                  initialAngleInDegree: 90,
                  chartRadius: 160.0,
                  chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20.0,),

        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration.copyWith(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Most Frequent Patients',
                  style: kHeadTextStyle.copyWith(
                      fontSize: 16.0
                  ),
                ),
                SizedBox(height: 5.0,),
                Divider(color: kPrimaryColor,),
                SizedBox(height: 10.0,),
                _generateFrequentPatients(),
              ],
            ),
          ),
        ),

        SizedBox(height: 20.0,),

        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration.copyWith(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Admits and Surgeries',
                  style: kHeadTextStyle.copyWith(
                      fontSize: 16.0
                  ),
                ),
                SizedBox(height: 5.0,),
                Divider(color: kPrimaryColor,),
                SizedBox(height: 10.0,),
                SimpleRowData(title: 'Patients Admitted', value: info['admitted'].toString(),),
                SimpleRowData(title: 'Surgeries', value: info['operations'].toString(),),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, double> _generateAppointmentDataMap() {
    return {
      'Scheduled': (info['patients'] - info['cancelled']).toDouble(),
      'Cancelled': info['cancelled'].toDouble()
    };
  }

  Map<String, double> _generateAppointmentTypeDataMap() {
    return {
      'Offline': (info['patients'] - info['cancelled'] - info['video']).toDouble(),
      'Video': info['video'].toDouble()
    };
  }

  Widget _generateFrequentPatients() {
    int count = (info['regular'].length < 3)?info['regular'].length : 3;
    if(count == 0) {
      return Center(
        child: Text(
          'No Patient Data to display',
          style: GoogleFonts.notoSans(fontSize: 14.0, fontWeight: FontWeight.w700),
        ),
      );
    }

    List<Widget> patientList = [];
    for(int i=0; i<count; i++) {
      patientList.add(
        SimpleRowData(
          title: '${info['regular'][i]['user']['firstName']} ${info['regular'][i]['user']['lastName']}',
          value: info['regular'][i]['count'].toString(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AccountInformation(
                    data: widget.data,
                    userData: info['regular'][i]['user'],
                    displayEdit: false,
                  );
                })
            );
          },
        )
      );
    }

    return Column(
      children: patientList,
    );
  }
}
