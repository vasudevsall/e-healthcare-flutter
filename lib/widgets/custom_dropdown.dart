import 'package:e_healthcare/widgets/icon_text_label.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_healthcare/constants/constants.dart';

class CustomDropdownButton extends StatelessWidget {
  final IconData iconData;
  final String labelText;
  final value;
  final List<DropdownMenuItem> items;
  final Function onChange;
  final String hintText;

  CustomDropdownButton({
    this.iconData,
    this.labelText = '',
    this.value,
    @required this.items,
    @required this.onChange,
    this.hintText = ''
  }):assert(onChange != null),
     assert(items != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconTextLabel(
          iconData: iconData,
          text: labelText,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: kPrimaryLight),
          ),
          padding: EdgeInsets.all(5.0),
          child: DropdownButton(
            value: value,
            isDense: true,
            isExpanded: true,
            underline: SizedBox(),
            onChanged: onChange,
            style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.black
            ),
            items: items,
            hint: Center(
              child: Text(
                hintText,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
