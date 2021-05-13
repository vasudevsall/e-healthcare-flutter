import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {

  RoundedButton({
    @required this.color,
    @required this.text,
    @required this.onPressed
  });

  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.libreFranklin(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: color,
          minimumSize: Size(200.0, 40.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0)
          )
        ),
      ),
    );
  }
}
