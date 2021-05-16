import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class ManageUserService {

  String _user = kURL + "/manager/user";

  Future<Response> getUserDetails(String mode, String query) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_user + "?mode=$mode&query=$query",);
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
}