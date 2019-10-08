import 'package:dio/dio.dart';
import 'package:message/helper/notification_center.dart';
import 'package:message/network/base_model.dart';
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
    if(e.response != null) {
        print("data: ${e.response.data}, headers: ${e.response.headers}, request: ${e.response.request}");
      } else {
        print("headers: ${e.response.headers}, request: ${e.response.request}");
      }
      return Future.error(e);
  }

  // TODO: 定义自己的error 

  Future _dealBussinessError(Response res) {
    if (res.data == null) {
      print("response data null error: ${res.headers}, request: ${res.request}");
      return Future.error(DioError(error: Exception("response data null"), request: res.request, response: res));
    }
    var base = BaseModel.fromJson(res.data);
    if (base == null) {
      return Future.error(DioError(error: Exception("wrong response struct"), request: res.request, response: res));
    } else if (1 == base.sc) { // 失败
      return Future.error(DioError(error: Exception(base.message), request: res.request, response: res));
    } else if (2 == base.sc) { // 参数错误
      return Future.error(DioError(error: Exception("参数错误"), request: res.request, response: res));
    } else if (3 == base.sc) { // 服务端错误
      return Future.error(DioError(error: Exception("服务端错误"), request: res.request, response: res));
    } else if (4 == base.sc) { // 未授权
      NotificationCenter().send(NOTIFICATIION_TOKEN_INVALID);
      return Future.error(DioError(error: Exception("未授权"), request: res.request, response: res));
    } else if (5 == base.sc) { // token异常
      NotificationCenter().send(NOTIFICATIION_TOKEN_INVALID);
      return Future.error(DioError(error: Exception("token异常"), request: res.request, response: res));
    }
    return Future.value(res.data);
  }
}