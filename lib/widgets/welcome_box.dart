import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';

class WelcomeBox extends StatelessWidget {

  final String name;
  final String url;
  final String gender;
  final bool showWelcome;
  final double radius;
  WelcomeBox({
    @required this.name,
    @required this.url,
    @required this.gender,
    this.showWelcome = true,
    this.radius = 40.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      decoration: kDashBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                (showWelcome)?Text(
                  'Welcome,',
                  style: kDashBoxHeadTextStyle,
                ):SizedBox(),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    name,
                    style: kDashBoxHeadTextStyle.copyWith(
                        fontSize: 20.0
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: radius,
            backgroundColor: kDarkBackColor.withOpacity(0.5),
            backgroundImage: getImageUrl(url, gender),
          )
        ],
      ),
    );
  }

  ImageProvider getImageUrl(String url, String gender) {
    if(url == null || url == '') {
      if(gender == 'M') {
        return AssetImage('images/male.png');
      } else {
        return AssetImage('images/female.png');
      }
    } else {
      return NetworkImage(url);
    }
  }
}
