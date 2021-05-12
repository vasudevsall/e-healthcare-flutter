import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {

  final String name;
  final String url;
  final String gender;
  final TextStyle style;
  final double spaceBetween;
  final double radius;

  Profile({
    @required this.name,
    @required this.url,
    @required this.gender,
    this.style,
    this.spaceBetween = 20.0,
    this.radius = 70.0
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String url = "";
  bool networkImage = false;

  void changeImage() {
    if(widget.url == null || widget.url == '') {
      setState(() {
        url = (widget.gender == 'M') ? 'images/male.png' : 'images/female.png';
        networkImage = false;
      });
    } else {
      setState(() {
        url = widget.url;
        networkImage = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    changeImage();
  }


  @override
  void didUpdateWidget(Profile oldWidget) {
    super.didUpdateWidget(oldWidget);
    changeImage();
  }

  ImageProvider selectImage() {
    if(networkImage)
      return NetworkImage(
        url,
      );
    else
      return AssetImage(
        url,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print("Change me");
            setState(() {
              url = 'images/male.png';
            });
            //TODO: Change Profile Picture implementation
          },
          child: CircleAvatar(
            radius: widget.radius,
            backgroundColor: kDarkBackColor.withOpacity(0.5),
            backgroundImage: selectImage(),
          ),
        ),
        SizedBox(height: widget.spaceBetween,),
        Text(
          widget.name,
          textAlign: TextAlign.center,
          style: widget.style,
        )
      ],
    );
  }
}
