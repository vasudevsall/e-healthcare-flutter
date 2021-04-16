import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/widgets/icon_text_label.dart';

class DateInput extends StatefulWidget {

  final Function onChange;

  DateInput({
    @required this.onChange
  }):assert(onChange != null);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconTextLabel(
          iconData: Icons.calendar_today,
          text: 'Birth Date',
        ),
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
              lastDate: DateTime.now(),
            );
            dateController.text = date.toString().substring(0,10);
          },
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14.0
          ),
          decoration: kLoginRegisterInputDecoration.copyWith(
              hintText: 'yyyy-mm-dd'
          ),
          onChanged: widget.onChange,
        ),
      ],
    );
  }
}
