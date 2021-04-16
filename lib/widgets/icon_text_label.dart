import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconTextLabel extends StatelessWidget {
  final IconData iconData;
  final String text;

  IconTextLabel({
    this.iconData,
    this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 20.0,
          ),
          Text(
            ' $text',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
