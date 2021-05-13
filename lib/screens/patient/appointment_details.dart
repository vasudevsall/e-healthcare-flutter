import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/doctor_details.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AppointmentDetails extends StatefulWidget {
  final data;
  final int appointmentId;
  AppointmentDetails({
    @required this.data,
    @required this.appointmentId
  }):assert(data!=null),
     assert(appointmentId != null);
  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {

  var appointmentDetails;
  bool detailsAvailable = false;
  bool _deleting = false;
  bool cancelled = false;

  void _getAppointmentDetails() async {
    AppointmentService appointmentService = AppointmentService();

    try {
      var resp = await appointmentService.getAppointmentDetails(
          widget.appointmentId);
      setState(() {
        appointmentDetails = resp.data;
        detailsAvailable = true;
      });
    } catch (e) {
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
    return ModalProgressHUD(
      inAsyncCall: _deleting,
      child: UserScaffold(
        drawer: PatientDrawer(data: widget.data),
        body: _formBody(),
      ),
    );
  }

  Widget _formBody() {
    if (!detailsAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      children: [
        DoctorDetails(
            details: appointmentDetails['appointmentModel']['doctorId']),
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
              detailRow(
                  'Date: ', appointmentDetails['appointmentModel']['date']),
              detailRow('Slot: ',
                  (appointmentDetails['appointmentModel']['slot'] == 'M')
                      ? 'Morning'
                      : 'Afternoon'),
              detailRow('Token Number: ',
                  appointmentDetails['appointmentModel']['token'].toString()),
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
                textAlign: (appointmentDetails['diagnosis'] ==
                    'No information available') ? TextAlign.center : TextAlign
                    .start,
                style: kHeadTextStyle.copyWith(
                    color: (appointmentDetails['diagnosis'] ==
                        'No information available') ? kDarkBackColor : Colors
                        .white
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
              _getImage(appointmentDetails['prescription']),
            ],
          ),
        ),
        SizedBox(height: 15.0,),
        _displayCancelButton(appointmentDetails['appointmentModel']['date'],
            appointmentDetails['appointmentModel']['slot']),
      ],
    );
  }

  Widget detailRow(String title, String value) {
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
    if (url == null)
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

  Widget _displayCancelButton(String time, String slot) {
    List val = time.split("-");
    int hour = (slot == 'M') ? 8 : 12;
    DateTime appointmentDate = new DateTime(
        int.parse(val[0]), int.parse(val[1]), int.parse(val[2]), hour);

    if (appointmentDate.isAfter(DateTime.now())) {
      return ElevatedButton(
        onPressed: (cancelled)?null:() async {
          bool cancel = await _showMyDialog();
          if (cancel) {
            setState(() {
              _deleting = true;
            });
            AppointmentService appointmentService = AppointmentService();

            try {
              await appointmentService.deleteAppointment(
                  appointmentDetails['appointmentModel']['id']);
              setState(() {
                _deleting = false;
                cancelled = true;
              });
            } catch (e) {
              print(e.response.data);
            }
          }
        },
        child: Center(
          child: Text(
            (cancelled)?'Already Cancelled':'Cancel Appointment',
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.red,
            padding: EdgeInsets.all(10)
        ),
      );
    }
    return Container();
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment',),
          titleTextStyle: GoogleFonts.notoSans(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.black
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you want to cancel this appointment ?',
                  style: GoogleFonts.notoSans(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                  textStyle: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                  primary: Colors.red
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
              style: ElevatedButton.styleFrom(
                  textStyle: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                  primary: Colors.green
              ),
            ),
          ],
        );
      },
    );
  }
}