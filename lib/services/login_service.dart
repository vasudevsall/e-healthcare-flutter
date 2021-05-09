import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class LoginService {

  String verifyUrl = kURL + "/login-verify";
  String loginUrl = kURL + "/login";
  String registerUrl = kURL + "/register";

  Future<Response> verifyLogin() async{
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(verifyUrl,);
  }

  Future<dynamic> loginUser(String username, String password) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      'username': username,
      'password': password
    };

    return await dio.post(
      loginUrl, data: formData,
      options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) { return status < 500; },
          responseType: ResponseType.json
      ),
    );
  }

  Future<Response> registerUser(
      String username, String password, String firstName, String lastName,
      String gender, String birthDate, String phoneNumber, String email,
      String bloodGroup
  ) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      "username": username,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate.toString(),
      "phoneNumber": phoneNumber,
      "email": email,
      "bloodGroup": bloodGroup
    };

    return await dio.post(
      registerUrl, data: formData
    );
  }
}