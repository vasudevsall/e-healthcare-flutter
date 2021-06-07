import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleRowData extends StatelessWidget {
  final String title;
  final String value;
  final Function onPressed;
  final Function valueOnPressed;
  final bool bold;
  final bool boldVal;
  final Color fontColor;

  SimpleRowData({
    @required this.title,
    @required this.value,
    this.onPressed,
    this.valueOnPressed,
    this.bold = true,
    this.boldVal = true,
    this.fontColor = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: (onPressed == null)?Colors.transparent:Colors.white,
            child: InkWell(
              onTap: onPressed,
              child: Text(
                title,
                style: GoogleFonts.notoSans(
                  color: fontColor,
                  fontSize: 14.0,
                  fontWeight: (bold)?FontWeight.w700:FontWeight.w400
                )
              ),
            ),
          ),
          Material(
            color: (valueOnPressed == null)?Colors.transparent:Colors.white,
            child: InkWell(
              onTap: valueOnPressed,
              child: Text(
                  value,
                  style: GoogleFonts.notoSans(
                    color: fontColor,
                    fontSize: 14.0,
                    fontWeight: (boldVal)?FontWeight.w700:FontWeight.w400
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
