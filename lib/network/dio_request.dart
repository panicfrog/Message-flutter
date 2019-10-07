import 'package:dio/dio.dart';
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

  Future<Response> post(String path, { Map<String, dynamic> body }) async {
    await _configToken();
    try {
      // TODO: 这里还需要处理业务错误
      return dio.post(path, data: body);
    } on DioError catch(e) {
      // TODO: 处理请求异常
      if(e.response != null) {
        print("data: ${e.response.data}, headers: ${e.response.headers}, request: ${e.response.request}");
      } else {
        print("headers: ${e.response.headers}, request: ${e.response.request}");
      }
      return Future.error(e);
    }
  }

  Future<Response<T>> get<T>(String path, { Map<String, dynamic> params }) async {
    await _configToken();
    try {
      // TODO: 这里还需要处理业务错误
      return dio.get(path, queryParameters: params);
    } on DioError catch(e) {
      // TODO: 处理请求异常
      if(e.response != null) {
        print("data: ${e.response.data}, headers: ${e.response.headers}, request: ${e.response.request}");
      } else {
        print("headers: ${e.response.headers}, request: ${e.response.request}");
      }
      return Future.error(e);
    }
  }

  Future<void> _configToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("message.token");
    if(token != null && token.length > 0) {
      dio.options.headers["token"] = token;
    } else if (dio.options.headers.containsKey("token")) {
      dio.options.headers.remove("token");
    }
  }
}