import 'package:flutter/material.dart';
import 'package:e_healthcare/widgets/icon_text_label.dart';
import 'package:e_healthcare/constants/constants.dart';

class CustomLabelTextField extends StatefulWidget {

  final IconData iconData;
  final String labelText;
  final Function validator;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final Function onChange;

  CustomLabelTextField({
    this.iconData,
    this.labelText = '',
    @required this.validator,
    this.obscureText = false,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    @required this.onChange
  }):assert(validator != null),
     assert(onChange != null);

  @override
  _CustomLabelTextFieldState createState() => _CustomLabelTextFieldState();
}

class _CustomLabelTextFieldState extends State<CustomLabelTextField> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        IconTextLabel(
          iconData: widget.iconData,
          text: widget.labelText,
        ),
        TextFormField(
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.obscureText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14.0
          ),
          decoration: kLoginRegisterInputDecoration.copyWith(
              hintText: widget.hintText
          ),
        ),
      ],
    );
  }
}
