import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class ManageUserService {

  String _user = kURL + "/manager/user";
  String _doctor = kURL + "/manager/doctor";

  Future<Response> getUserDetails(String mode, String query) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_user + "?mode=$mode&query=$query",);
  }

  Future<Response> getDoctorDetails(String username, int days) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_doctor+"?username=$username&days=$days");
  }

  Future<Response> addANewUser(
      String username, String firstName, String lastName, String gender,
      String birthDate, String phoneNumber, String email, String bloodGroup
  ) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate,
      "phoneNumber": phoneNumber,
      "email": email,
      "bloodGroup": bloodGroup
    };

    return await dio.post(_user, data: formData);
  }

  Future<Response> addNewDoctor(
      String username, String firstName, String lastName, String gender,
      String birthDate, String phoneNumber, String email, String bloodGroup,
      String speciality, double morningBlocks, double afternoonBlocks,
      String qualification, int experience
  ) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      "userId": {
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "birthDate": birthDate,
        "phoneNumber": phoneNumber,
        "email": email,
        "bloodGroup": bloodGroup
      },
      "speciality": {
        "speciality": speciality
      },
      "morningBlocks": morningBlocks,
      "afternoonBlocks": afternoonBlocks,
      "qualification": qualification,
      "experience": experience
    };

    return await dio.post(_doctor, data: formData);
  }
}