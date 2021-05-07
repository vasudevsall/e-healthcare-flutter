import 'package:flutter/material.dart';
import 'package:e_healthcare/screens/patient/patient_dashboard.dart';

class RouteHelper {

  Widget dashboardWidgetHelper(var data) {

    String role = data['roles'];
    if(role == 'ROLE_MANAGE')
      return null;
    else if(role == 'ROLE_DOC')
      return null;
    return PatientDashboard(data: data,);
  }
}