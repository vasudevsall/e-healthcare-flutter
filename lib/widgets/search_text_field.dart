import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTextField extends StatelessWidget {

  final Function onSubmitted;
  final Function onChanged;

  SearchTextField({
    @required this.onSubmitted,
    @required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(
                Icons.search
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.grey
            ),
            contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
            isDense: true
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
    );
  }
}