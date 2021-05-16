import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/widgets/doctor_details.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/room_service.dart';
import 'package:e_healthcare/widgets/dash_card.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:e_healthcare/widgets/welcome_box.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdmitInformation extends StatefulWidget {
  final data;
  final admitData;
  final discharge;
  AdmitInformation({
    @required this.data,
    this.admitData,
    this.discharge = false
  });

  @override
  _AdmitInformationState createState() => _AdmitInformationState();
}

class _AdmitInformationState extends State<AdmitInformation> {

  var admitData;
  var _admitData = false;

  void _dischargeUser() async {
    setState(() {
      _admitData = true;
    });
    try {
      RoomService roomService = RoomService();
      var resp = await roomService.dischargeUser(widget.admitData['id']);

      setState(() {
        admitData = resp.data;
        _admitData = false;
      });
    } catch(e) {
      setState(() {
        _admitData = false;
      });
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    admitData = widget.admitData;
    if(widget.discharge) {
      _dischargeUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _admitData,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: ListView(
          padding: kScreenPadding,
          children: [
            Text('Patient', style: kHeadTextStyle,),
            SizedBox(height: 20.0,),
            WelcomeBox(
              name: '${admitData['user']['firstName']} ${admitData['user']['lastName']}',
              url: admitData['user']['profile'],
              gender: admitData['user']['gender'],
              showWelcome: false,
              radius: 60.0,
            ),
            SizedBox(height: 20.0,),
            Text('Doctor', style: kHeadTextStyle,),
            SizedBox(height: 20.0,),
            DoctorDetails(details: admitData['doctor'], onlyHead: true,),
            SizedBox(height: 20.0,),
            Text('Details', style: kHeadTextStyle,),
            SizedBox(height: 20.0,),
            DashCard(
              children: [
                SimpleRowData(title: 'Admitted On', value: admitData['admit'], bold: false,),
                SimpleRowData(title: 'Discharged On', value: (admitData['discharge'] == null)?'Admitted':admitData['discharge'], bold: false),
                SimpleRowData(title: 'Bill', value: '${'\u20B9'} ${admitData['cost']}/-', bold: false),
              ]
            ),
            SizedBox(height: 5.0,),
            DashCard(
              head: Text('Diagnosis', style: kHeadTextStyle,),
              children: [
                Text(admitData['diagnosis'])
              ]
            ),
            SizedBox(height: 5.0,),
            DashCard(
                head: Text('Description', style: kHeadTextStyle,),
                children: [
                  Text(admitData['description'])
                ]
            )
          ],
        ),
      ),
    );
  }
}
