import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/doctor_details.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PastAppointmentDetails extends StatefulWidget {
  final data;
  final int appointmentId;
  PastAppointmentDetails({
    @required this.data,
    @required this.appointmentId
  }):assert(data!=null),
     assert(appointmentId != null);
  @override
  _PastAppointmentDetailsState createState() => _PastAppointmentDetailsState();
}

class _PastAppointmentDetailsState extends State<PastAppointmentDetails> {

  var appointmentDetails;
  bool detailsAvailable = false;

  void _getAppointmentDetails() async {
    AppointmentService appointmentService = AppointmentService();

    try {
      var resp = await appointmentService.getAppointmentDetails(widget.appointmentId);
      setState(() {
        appointmentDetails = resp.data;
        detailsAvailable = true;
      });

    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return PatientScaffold(
      drawer: PatientDrawer(data: widget.data),
      body: _formBody(),
    );
  }

  Widget _formBody() {
    if(!detailsAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      children: [
        DoctorDetails(details: appointmentDetails['appointmentModel']['doctorId']),
        SizedBox(height: 20.0,),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Date and Time Details:',
                style: kHeadTextStyle,
              ),
              Divider(color: kPrimaryColor,),
              detailRow('Date: ', appointmentDetails['appointmentModel']['date']),
              detailRow('Slot: ', (appointmentDetails['appointmentModel']['slot'] == 'M')?'Morning':'Afternoon'),
              detailRow('Token Number: ', appointmentDetails['appointmentModel']['token'].toString()),
            ],
          ),
        ),
        SizedBox(height: 15.0,),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Diagnosis:',
                style: kHeadTextStyle,
              ),
              Divider(color: kPrimaryColor,),
              SizedBox(height: 5.0,),
              Text(
                appointmentDetails['diagnosis'],
                style: kHeadTextStyle.copyWith(
                  color: Colors.white
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 15.0,),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Prescription',
                style: kHeadTextStyle,
              ),
              Divider(color: kPrimaryColor,),
              SizedBox(height: 15.0,),
              _getImage(appointmentDetails['prescription'])
            ],
          ),
        )
      ],
    );
  }

  Row detailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeadTextStyle,
        ),
        Text(
          value,
          style: kHeadTextStyle.copyWith(
            color: Colors.white
          ),
        )
      ],
    );
  }

  Widget _getImage(String url) {
    if(url == null)
        return Center(
          child: Text(
            'No prescription available',
            style: kSubTextStyle.copyWith(
              color: kDarkBackColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        );

    return Image.network(url);
  }
}
