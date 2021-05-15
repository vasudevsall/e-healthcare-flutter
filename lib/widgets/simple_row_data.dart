import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleRowData extends StatelessWidget {
  final String title;
  final String value;
  final Function onPressed;
  final Function valueOnPressed;
  final bool bold;

  SimpleRowData({
    @required this.title,
    @required this.value,
    this.onPressed,
    this.valueOnPressed,
    this.bold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: onPressed,
              child: Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 14.0,
                  fontWeight: (bold)?FontWeight.w700:FontWeight.w400
                )
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: valueOnPressed,
              child: Text(
                  value,
                  style: GoogleFonts.notoSans(
                    fontSize: 14.0,
                    fontWeight: (bold)?FontWeight.w700:FontWeight.w400
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
