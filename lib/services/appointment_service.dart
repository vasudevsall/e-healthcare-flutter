import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class AppointmentService {

  String _getPastUrl = kURL + "/appointment?mode=P";
  String _getScheduledUrl = kURL + "/appointment?mode=F";

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
}