import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class RoomService {

  String _room = kURL + "/room";
  String _roomBook = kURL + "/room/book";

  Future<Response> getRoomDetails(String type) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    return await dio.get(_room + "?type=$type",);
  }

  Future<Response> addRoom(int roomNumber, int floorNumber, int beds, String type, double price) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      "id": roomNumber,
      "floor": floorNumber,
      "beds": beds,
      "total": beds,
      "type": type,
      "price": price
    };

    return await dio.post(_room, data: formData);
  }

  Future<Response> admitPatient(int roomNumber, String username, String docUsername, String diagnosis, String description) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var formData = {
      "room": {
        "id": roomNumber
      },
      "user": {
        "username": username
      },
      "doctor": {
        "userId": {
          "username": docUsername
        }
      },
      "diagnosis": diagnosis,
      "description": description
    };

    return await dio.post(_roomBook, data: formData);
  }

  Future<Response> getBookingDetails(String username, String docUsername, int start, int end) async {
    String _url = _roomBook + "?start=$start";

    if(username!=null && username!='')  _url += "&user=$username";
    if(docUsername!=null && username!='') _url+= "&doctor=$docUsername";
    if(end!=null && end!=-1) _url += "&end=$end";

    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    return await dio.get(_url);
  }

  Future<Response> dischargeUser(int id) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    return await dio.delete(_roomBook+'?id=$id');
  }
}