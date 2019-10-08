import 'package:dio/dio.dart';
import 'package:message/static/strings.dart';
import 'package:message/helper/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

class DRequest{
  var dio = Dio();

  factory DRequest() => _instance;
  static final DRequest _instance = DRequest._internel();
  DRequest._internel() {
    dio.options.baseUrl = "http://" + Env.host + ":8080";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    dio.options.headers = {"platform": "ios", "Content-type": "application/json"};
  }

  Future<T> post<T>(String path, { Map<String, dynamic> body }) async {
    await _configToken();
    try {
      var response = await dio.post<T>(path, data: body);
      return _dealBussinessError(response);
    } on DioError catch(e) {
      return _dealRequestError(e);
    }
  }

  Future<T> get<T>(String path, { Map<String, dynamic> params }) async {
    await _configToken();
    try {
      var response = await dio.get<T>(path, queryParameters: params);
      return _dealBussinessError(response);
    } on DioError catch(e) {
      return _dealRequestError(e);
    }
  }

  Future<void> _configToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(TOKEN_KEY);
    if(token != null && token.length > 0) {
      dio.options.headers["token"] = token;
    } else if (dio.options.headers.containsKey("token")) {
      dio.options.headers.remove("token");
    }
  }

  Future<dynamic> _dealRequestError(DioError e) {
    MToast.show(e.toString());
    if(e.response != null) {
        print("data: ${e.response.data}, headers: ${e.response.headers}, request: ${e.response.request}");
      } else {
        print("headers: ${e.response.headers}, request: ${e.response.request}");
      }
      return Future.error(e);
  }

  Future _dealBussinessError(Response res) {
    if (res.data == null) {
      print("response data null error: ${res.headers}, request: ${res.request}");
      return Future.error(DioError(error: Exception("response data null"), request: res.request, response: res));
    }
    return Future.value(res.data);
  }
}