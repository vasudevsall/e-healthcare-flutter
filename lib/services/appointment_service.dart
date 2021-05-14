import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class AppointmentService {

  String _getPastUrl = kURL + "/appointment?mode=P";
  String _getScheduledUrl = kURL + "/appointment?mode=F";
  String _newAppointment = kURL + "/appointment";
  String _getAppointmentDetails = kURL + "/appointment/details?id=";
  String _deleteAppointment = kURL + "/appointment?id=";

  Future<Response> getPastAppointments() async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_getPastUrl,);
  }

  Future<Response> getScheduledAppointments() async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_getScheduledUrl,);
  }

  Future<Response> addNewAppointment(String doctorUsername, String date, String slot, String type) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      'doctorUsername': doctorUsername,
      'date': date,
      'slot': slot,
      'type': type
    };

    return await dio.post(
      _newAppointment, data: formData
    );
  }

  Future<Response> getAppointmentDetails(int id) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_getAppointmentDetails + id.toString(),);
  }

  Future<Response> deleteAppointment(int id) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.delete(_deleteAppointment + id.toString(),);
  }
}