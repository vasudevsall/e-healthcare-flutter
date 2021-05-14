import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleRowData extends StatelessWidget {
  final String title;
  final String value;
  final Function onPressed;

  SimpleRowData({
    @required this.title,
    @required this.value,
    this.onPressed,
  });
  
  TextStyle kTextStyle = GoogleFonts.notoSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            child: InkWell(
              onTap: onPressed,
              child: Text(
                title,
                style: kTextStyle,
              ),
            ),
          ),
          Text(
              value,
              style: kTextStyle
          )
        ],
      ),
    );
  }
}
