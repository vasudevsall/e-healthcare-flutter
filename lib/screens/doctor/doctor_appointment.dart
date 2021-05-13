import 'dart:io';

import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/doctor/appointment_success.dart';
import 'package:e_healthcare/screens/doctor/doctor_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/doctor_service.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DoctorAppointment extends StatefulWidget {
  final data;
  DoctorAppointment({
    @required this.data,
  });
  @override
  _DoctorAppointmentState createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {

  var details;
  bool detailsAvailable = false;
  bool detailsPosted = false;
  final picker = ImagePicker();
  File imageFile;
  String url;
  String diagnosis = '';
  bool _uploading = false;

  void _getNextDetails() async {
    try {
      DoctorService doctorService = DoctorService();
      var resp = await doctorService.getNextPatient();
      setState(() {
        details = resp.data;
        detailsAvailable = true;
      });
    } catch(e) {
      if(e.response.statusCode == 404) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return AppointmentSuccess(data: widget.data,);
        }));
      }
      print(e.response.statusCode);
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getNextDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _uploading,
      child: UserScaffold(
        drawer: DoctorDrawer(data: widget.data,),
        body: _generateBody(),
      ),
    );
  }

  Widget _generateBody() {
    if(!detailsAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return Center(
      child: ListView(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Token Number: ',
                style: kHeadTextStyle,
              ),
              SizedBox(width: 20.0,),
              Text(
                '${details['token']}',
                style: kHeadTextStyle,
              )
            ],
          ),
          SizedBox(height: 20.0,),
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration,
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: kDashBoxDecoration.copyWith(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Profile(
                    name: '${details['userId']['firstName']} ${details['userId']['lastName']}',
                    url: details['userId']['profile'],
                    gender: details['userId']['gender'],
                    data: null,
                    changePicture: false,
                    style: GoogleFonts.libreFranklin(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                        color: kDarkBackColor
                    ),
                  ),
                  Divider(
                    color: kPrimaryOther,
                    thickness: 0.5,
                  ),
                  _generateRowData('Gender:', (details['userId']['gender'] == 'M')? 'Male' : (details['userId']['gender'] == 'F')? 'Female':'Other'),
                  _generateRowData('Birth Date: ', details['userId']['birthDate']),
                  _generateRowData('Age:',  getAge(details['userId']['birthDate'])),
                  _generateRowData('Email', details['userId']['email']),
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
                    'Diagnosis',
                    textAlign: TextAlign.center,
                    style: kHeadTextStyle,
                  ),
                  SizedBox(height: 20.0,),
                  TextField(
                    onChanged: (newVal) {
                      diagnosis = newVal;
                    },
                    maxLines: 4,
                    style: GoogleFonts.notoSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: kUpdateDetailsInputDecoration.copyWith(
                      hintText: 'Enter detailed Diagnosis',
                    ),
                  )
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
                    'Prescription',
                    textAlign: TextAlign.center,
                    style: kHeadTextStyle,
                  ),
                  SizedBox(height: 15.0,),
                  _getSelectedImage(),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        imageFile = File(pickedFile.path);
                      });
                    },
                    child: Text(
                      'Select File'
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryLight,
                      textStyle: GoogleFonts.notoSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      )
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.getImage(source: ImageSource.camera);
                      setState(() {
                        imageFile = File(pickedFile.path);
                      });
                    },
                    child: Text(
                        'Take Picture'
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryLight,
                        textStyle: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          ElevatedButton(
              onPressed: (detailsPosted)?null:() async {
                setState(() {
                  _uploading = true;
                });

                FirebaseStorage storage = FirebaseStorage.instance;
                Reference reference = storage.ref().child(
                    "prescription/image1" + DateTime.now().toString());
                UploadTask uploadTask = reference.putFile(imageFile);
                await uploadTask.then((res) async {
                  url = await res.ref.getDownloadURL();
                  setState(() {});
                });

                try {
                  DoctorService doctorService = DoctorService();
                  await doctorService.postAppointmentDetails(details['userId']['username'], details['id'], diagnosis, url);
                  setState(() {
                    detailsPosted = true;
                    _uploading = false;
                  });
                } catch(e) {
                  setState(() {
                    _uploading = true;
                  });
                  print(e.response.data);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor
              ),
              child: Text('Update')
          ),
          ElevatedButton(
            onPressed: (detailsPosted)?(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return DoctorAppointment(data: widget.data);
              }));
            }:null,
            child: Text('continue'),
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor
            ),
          ),
        ],
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

  Widget _getSelectedImage() {
    if(imageFile == null)
      return SizedBox();

    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Image.file(imageFile)
    );
  }

  String getAge(String date) {
    List dateList = date.split("-");
    DateTime birth = DateTime(int.parse(dateList[0]), int.parse(dateList[1]), int.parse(dateList[2]));
    Duration duration = birth.difference(DateTime.now());
    int days = duration.inDays;
    int years = days~/365;
    return years.abs().toString();
  }
}
