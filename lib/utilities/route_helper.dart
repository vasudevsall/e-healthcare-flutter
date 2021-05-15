import 'package:e_healthcare/screens/doctor/doctor_dashboard.dart';
import 'package:e_healthcare/screens/manager/manager_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:e_healthcare/screens/patient/patient_dashboard.dart';

class RouteHelper {

  Widget dashboardWidgetHelper(var data) {

    String role = data['roles'];
    if(role == 'ROLE_MANAGE')
      return ManagerDashboard(data: data);
    else if(role == 'ROLE_DOC')
      return DoctorDashboard(data: data,);
    return PatientDashboard(data: data,);
  }
}