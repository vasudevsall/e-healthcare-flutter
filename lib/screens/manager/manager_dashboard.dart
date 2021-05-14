import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:flutter/material.dart';

import 'manager_drawer.dart';

class ManagerDashboard extends StatefulWidget {
  final data;
  ManagerDashboard({
    @required this.data
  });
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: ManagerDrawer(data: widget.data),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        children: [

        ],
      ),
    );
  }
}
