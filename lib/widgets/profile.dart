import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/patient/account/change_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {

  final String name;
  final String url;
  final String gender;
  final TextStyle style;
  final double spaceBetween;
  final double radius;
  final bool changePicture;
  final data;

  Profile({
    @required this.name,
    @required this.url,
    @required this.gender,
    this.style,
    this.spaceBetween = 20.0,
    this.radius = 70.0,
    this.changePicture = true,
    @required this.data
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
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: widget.radius,
              backgroundColor: kDarkBackColor.withOpacity(0.5),
              backgroundImage: selectImage(),
            ),
            _displayEdit(),
          ],
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

  Widget _displayEdit() {
    if(!widget.changePicture) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChangeProfilePicture(data: widget.data);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          FontAwesomeIcons.solidEdit,
          color: Colors.white,
          size: 18.0,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryLighter
        ),
      ),
    );
  }
}
