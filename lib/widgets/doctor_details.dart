import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetails extends StatelessWidget {

  final details;
  final bool onlyHead;

  DoctorDetails({
    @required this.details,
    this.onlyHead = false,
  }):assert(details!=null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Dr. ${details['userId']['firstName']} ${details['userId']['lastName']}',
                        style: kDashBoxHeadTextStyle.copyWith(
                            fontSize: 20.0
                        ),
                      ),
                    ),
                    Text(
                      details['speciality']['speciality'],
                      style: kSubTextStyle.copyWith(
                        color: kDarkBackColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Text(
                      details['qualification'],
                      style: kDashBoxHeadTextStyle.copyWith(
                          fontSize: 18.0
                      ),
                    )
                  ],
                ),
              ),
              CircleAvatar(
                radius: 60.0,
                backgroundColor: kDarkBackColor.withOpacity(0.5),
                backgroundImage: getImageUrl(details['userId']['profile'], details['userId']['gender']),
              )
            ],
          ),
          decoration: kDashBoxDecoration,
        ),
        (onlyHead)?SizedBox():SizedBox(height: 20.0,),
        (onlyHead)?SizedBox():Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 7.5),
                  padding: EdgeInsets.all(15.0),
                  decoration: kDashBoxDecoration.copyWith(
                      color: Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Patients',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: kDarkBackColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '500+ ',
                            style: GoogleFonts.notoSans(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 7.5),
                    padding: EdgeInsets.all(15.0),
                    decoration: kDashBoxDecoration.copyWith(
                        color: Colors.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Experience',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: kDarkBackColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: '${details['experience']}+ ',
                                style: GoogleFonts.notoSans(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w700,
                                    color: kPrimaryColor
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Years',
                                      style: GoogleFonts.montserrat(
                                          color: kPrimaryLight,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700
                                      )
                                  )
                                ]
                            )
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
        (onlyHead)?SizedBox():SizedBox(height: 20.0,),
        (onlyHead)?SizedBox():Container(
          padding: EdgeInsets.all(15.0),
          decoration: kDashBoxDecoration,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 7.5),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      Uri _phoneLauncherUri = Uri(
                        scheme: 'tel',
                        path: '+91${details['userId']['phoneNumber']}',
                      );

                      launch(_phoneLauncherUri.toString());
                    },
                    icon: Icon(
                      Icons.smartphone,
                      size: 20.0,
                      color: kDarkBackColor,
                    ),
                    label: Flexible(
                      child: Text(
                        details['userId']['phoneNumber'],
                        style: GoogleFonts.libreFranklin(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: kDarkBackColor
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 7.5),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      Uri _emailLauncherUri = Uri(
                        scheme: 'mailto',
                        path: details['userId']['email'],
                      );

                      launch(_emailLauncherUri.toString());
                    },
                    icon: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      size: 20.0,
                      color: kDarkBackColor,
                    ),
                    label: Flexible(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          details['userId']['email'],
                          style: GoogleFonts.libreFranklin(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kDarkBackColor
                          ),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
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
