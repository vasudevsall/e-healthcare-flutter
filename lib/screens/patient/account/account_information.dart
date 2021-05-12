import 'package:e_healthcare/screens/patient/PatientDrawer.dart';
import 'package:e_healthcare/screens/patient/patient_scaffold.dart';
import 'package:e_healthcare/services/appointment_service.dart';
import 'package:flutter/material.dart';

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
      body: ListView(

      ),
    );
  }
}
