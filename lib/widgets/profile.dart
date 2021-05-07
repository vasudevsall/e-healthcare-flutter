import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {

  final String name;
  final String url;
  final String gender;

  Profile({
    @required this.name,
    @required this.url,
    @required this.gender
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

  Widget selectImage() {
    if(networkImage)
      return Image.network(
        url,
        fit: BoxFit.contain,
      );
    else
      return Image.asset(
        url,
        fit: BoxFit.contain,
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
            radius: 70.0,
            backgroundColor: kBackColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipOval(
                child: selectImage(),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0,),
        Text(
          widget.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: kBackColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
