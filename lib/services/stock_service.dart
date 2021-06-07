import 'package:e_healthcare/constants/constants.dart';
import 'package:dio/dio.dart';
import './service_constants.dart';

class StockService {

  String _stockUrl = kURL + '/stocks';
  String _itemUrl = kURL + '/stocks/item';
  String _orderUrl = kURL + '/stocks/order';

  Future<Response> getStocks({String name}) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    if(name == null)  return await dio.get(_stockUrl);
    return await dio.get(_stockUrl + '?name=$name');
  }

  Future<Response> addNewItem(String name, String composition, int use) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var requestData = {
      'name': name,
      'composition': composition,
      'use':use
    };

    return await dio.post(_stockUrl, data: requestData);
  }

  Future<Response> findItemInStock(int id) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());
    
    return await dio.get(_itemUrl + '?product=$id');
  }

  Future<Response> addItemInStock(int id, int quantity, String expireDate, double price, double discount) async {
    var dio = Dio();
    dio.interceptors.add(await ServiceConstants.getCookieManager());

    var requestData = {
      'product': {
        'id': id,
      },
      'quantity': quantity,
      'expire': expireDate,
      'price': price,
      'discount': discount
    };

    return await dio.post(_itemUrl, data: requestData);
  }
}