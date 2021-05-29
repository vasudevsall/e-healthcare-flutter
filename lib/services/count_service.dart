import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class CountService {

  String _roomNumbers = kURL + "/room/beds";
  String _userCount = kURL + "/user/count";
  String _appointmentCount = kURL + "/appointment/count?days=";

  Future<Response> getRoomCount() async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_roomNumbers,);
  }

  Future<Response> getUserCount() async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_userCount,);
  }

  Future<Response> getAppointmentCount({int days = 10}) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_appointmentCount + days.toString(),);
  }
}