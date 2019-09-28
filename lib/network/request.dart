import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';
class Request {
  static var _basePath = "http://" + Env.host +":8080";

  static Future<Response> post(String path, Map<String, String> body ) async {
    Map<String, String> headers = {"platform": "ios", "Content-type": "application/json"};
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("message.token");
    if (token != "") {
      headers["token"] = token;
    }
    var b = JsonEncoder().convert(body);
    var response = await http.post(_basePath + path,headers: headers, body: b);
    return response;
  }

  static Future<Response> get(String path, { Map<String, String> params }) async {
    Map<String, String> headers = {"platform": "ios", "Content-type": "application/json"};
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("message.token");
    if (token != "") {
      headers["token"] = token;
    }

    if (params != null) {
      String _params = _encodeMap(params);
      var response = await http.get(_basePath + path + "/" + _params, headers: headers);
      return response;
    } else {
      var response = await http.get(_basePath + path, headers: headers);
      return response;
    }
  }

}

String _encodeMap(Map data) {
  return data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}").join("&");
}