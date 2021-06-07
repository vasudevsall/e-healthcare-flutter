import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/widgets/icon_text_label.dart';

class DateInput extends StatefulWidget {

  final Function onChange;
  final bool update;
  final String initialValue;
  final bool label;
  final bool displayHintText;
  final bool highLastDate;

  DateInput({
    @required this.onChange,
    this.update = false,
    this.initialValue = '',
    this.label = true,
    this.displayHintText = true,
    this.highLastDate = false,
  }):assert(onChange != null);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue != '')
      dateController = TextEditingController(text:  widget.initialValue);
    else
      dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (widget.label)?IconTextLabel(
          iconData: Icons.calendar_today,
          text: 'Birth Date',
        ):SizedBox(),
        TextFormField(
          keyboardType: TextInputType.datetime,
          validator: (value) {
            // TODO Validate date
            return null;
          },
          controller: dateController,
          onTap: () async {
            var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: (widget.highLastDate)?DateTime(2100):DateTime.now(),
            );
            dateController.text = date.toString().substring(0,10);
            widget.onChange(date.toString().substring(0,10));
          },
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14.0
          ),
          decoration: (widget.update)?
            kUpdateDetailsInputDecoration.copyWith(
                hintText: (widget.displayHintText)?'yyyy-mm-dd':''
            ):
            kLoginRegisterInputDecoration.copyWith(
                hintText: 'yyyy-mm-dd'
          ),
          onChanged: widget.onChange,
        ),
      ],
    );
  }
}
