import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class InformationService {

  String _allSpeciality = kURL + "/info/speciality";
  String _doctorUsername = kURL + "/info/doctor?user=";
  String _doctorAll = kURL + "/info/doctor/speciality";
  String _doctorSpeciality = kURL + "/info/doctor/speciality?speciality=";

  Future<Response> getAllSpecialities() async{
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_allSpeciality,);
  }

  Future<Response> getDoctorByUsername(String username) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_doctorUsername + username);
  }

  Future<Response> getDoctorBySpeciality(String speciality) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_doctorSpeciality + speciality);
  }

  Future<Response> getAllDoctors() async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_doctorAll);
  }
}