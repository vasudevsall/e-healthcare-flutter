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
  final bool update;
  final String initialValue;
  final bool displayLabel;
  final int maxLines;

  CustomLabelTextField({
    this.iconData,
    this.labelText = '',
    @required this.validator,
    this.obscureText = false,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    @required this.onChange,
    this.update = false,
    this.initialValue = '',
    this.displayLabel = true,
    this.maxLines = 1,
  }):assert(validator != null),
     assert(onChange != null);

  @override
  _CustomLabelTextFieldState createState() => _CustomLabelTextFieldState();
}

class _CustomLabelTextFieldState extends State<CustomLabelTextField> {

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue != '') {
      _controller = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        (widget.displayLabel)?IconTextLabel(
          iconData: widget.iconData,
          text: widget.labelText,
        ):SizedBox(),
        TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.obscureText,
          textAlign: TextAlign.center,
          maxLines: widget.maxLines,
          style: TextStyle(
              fontSize: 14.0
          ),
          decoration: (widget.update)?
              kUpdateDetailsInputDecoration.copyWith(
                hintText: widget.hintText
              ):
              kLoginRegisterInputDecoration.copyWith(
                  hintText: widget.hintText
          ),
          onChanged: widget.onChange,
        ),
      ],
    );
  }
}
