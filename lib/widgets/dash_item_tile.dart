import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DashItemTile extends StatelessWidget {

  DashItemTile({
    @required this.onTap,
    this.height = 100.0,
    this.width = 90.0,
    this.backgroundColor = Colors.white,
    this.splashColor = kPrimaryOther,
    @required this.icon,
    this.color = kDarkBackColor,
    this.iconSize = 35.0,
    this.fontSize = 12.0,
    @required this.text
  });

  final Function onTap;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color splashColor;
  final IconData icon;
  final Color color;
  final double iconSize;
  final double fontSize;
  final String text;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Column(
              children: <Widget>[
                FaIcon(
                  icon,
                  color: color,
                  size: iconSize,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.libreFranklin(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                          color: color
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}