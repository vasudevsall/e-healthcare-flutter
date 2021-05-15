import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';

class DashCard extends StatelessWidget {

  final Widget head;
  final List<Widget> children;
  final List<Widget> actions;
  final bool margin;

  DashCard({
    this.head,
    @required this.children,
    this.actions,
    this.margin = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (!margin)?EdgeInsets.zero:EdgeInsets.symmetric(vertical:7.5),
      padding: EdgeInsets.all(15.0),
      decoration: kDashBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: kDashBoxDecoration.copyWith(color: Colors.white),
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (head == null)?SizedBox():head,
                (head == null)?SizedBox():SizedBox(height: 5.0,),
                (head == null)?SizedBox():Divider(color: kPrimaryColor,),
                (head == null)?SizedBox():SizedBox(height: 10.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                )
              ],
            ),
          ),
          (actions == null)?SizedBox():SizedBox(height: 5.0,),
          (actions == null)?SizedBox():Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions,
          ),
        ],
      ),
    );
  }
}
