import 'package:e_healthcare/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';

class UserScaffold extends StatelessWidget {
  const UserScaffold({
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
          toolbarHeight: 70.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 30.0,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return NotificationScreen();
                  }));
                }
            )
          ],
          centerTitle: true,
          title: Image.asset(
            'images/logo_blue.png',
            height: 50.0,
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
