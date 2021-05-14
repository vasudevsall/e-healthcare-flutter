import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class DoctorService {

  String _upcoming = kURL + "/doctor/upcoming";
  String _next = kURL + "/doctor/next";
  String _update = kURL + "/doctor/update";
  String _trends = kURL + "/doctor/analysis?days=";

  Future<Response> getUpcomingSlotDetails() async{
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_upcoming,);
  }

  Future<Response> getNextPatient() async{
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_next,);
  }

  Future<Response> postAppointmentDetails(
      String username,
      int appointment,
      String diagnosis,
      String prescription
  ) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    
    var formData = {
      "username": username,
      "appointment": appointment,
      "diagnosis": diagnosis,
      "prescription": prescription
    };
    
    return await dio.post(_update, data: formData);
  }

  Future<Response> getAnalysis(int days) async{
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_trends + '$days',);
  }
}