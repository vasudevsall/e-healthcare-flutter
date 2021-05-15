import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';

class SelectInput extends StatelessWidget {
  final String text;
  final Function onPressed;

  SelectInput({
    @required this.text,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 20.0,),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Select'),
          style: ElevatedButton.styleFrom(primary: kPrimaryLight),
        )
      ],
    );
  }
}
