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
}