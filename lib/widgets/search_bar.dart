import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBar extends StatelessWidget {
  final Function onPressed;
  final String hintText;
  final Function onChanged;
  final TextInputType keyboardType;
  final double height;

  SearchBar({
    @required this.onPressed,
    this.hintText = '',
    @required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.height = 45.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              keyboardType: keyboardType,
              style: GoogleFonts.notoSans(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700
              ),
              expands: true,
              minLines: null,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0), topRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(0.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryLight, width: 1.0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0), topRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(0.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: kPrimaryColor, width: 2.0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0), topRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(0.0),
                  ),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Icon(
                FontAwesomeIcons.search
            ),
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0), topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(0.0), bottomRight: Radius.circular(5.0),
                )
              )
            ),
          )
        ],
      ),
    );
  }
}
