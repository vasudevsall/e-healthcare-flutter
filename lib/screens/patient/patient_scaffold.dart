import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';

class PatientScaffold extends StatelessWidget {
  const PatientScaffold({
    this.drawer,
    this.body
  });

  final Widget drawer;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          toolbarHeight: 80.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.person,
                  size: 30.0,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  //TODO: On pressed: User Dropdown
                }
            )
          ],
          centerTitle: true,
          title: Flexible(
            child: Image.asset(
              'images/logo_blue.png',
              height: 60.0,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu_rounded,
                size: 30.0,
                color: kPrimaryColor,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: drawer,
        body: body,
        backgroundColor: Colors.white,
    );
  }
}
