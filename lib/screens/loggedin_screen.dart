import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoggedInScreen extends StatefulWidget {
  final data;
  LoggedInScreen({
    this.data
  });

  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  final picker = ImagePicker();
  String url = '';
  File _imageFile;

  initState() {
    super.initState();
    var imgUrl = (widget.data['profile'] == null) ? '':widget.data['profile'];
    setState(() {
      url = imgUrl;
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  void uploadImageToFirebase(BuildContext context) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child("profile/image1" + DateTime.now().toString());
    UploadTask uploadTask = reference.putFile(_imageFile);
    uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      setState(()  {});
      print(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(widget.data['username']),
            Text(widget.data['firstName']),
            Text(widget.data['phoneNumber']),
            Text(widget.data['roles']),
            Text(widget.data['gender']),
            Text(widget.data['bloodGroup']),
            Text(widget.data['email']),
            TextButton(onPressed: pickImage, child: Text(
              'File'
            )),
            TextButton(onPressed: () {uploadImageToFirebase(context);}, child: Text('Upload')),
            Flexible(child: FadeInImage(image: NetworkImage(url), placeholder: AssetImage('images/login.jpg')))
          ],
        ),
      ),
    );
  }
}
