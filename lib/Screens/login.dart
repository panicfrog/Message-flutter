import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:message/component/main_button.dart';
import 'package:message/data/token.dart';
import 'package:message/network/login_model.dart';
import 'package:message/network/request.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  String _account;
  String _passwd;

  TextEditingController _accountEditController = TextEditingController();
  TextEditingController _passwdEditController = TextEditingController();

  @override
  void initState() {
    _accountEditController.addListener((){
      _account = _accountEditController.text;
    });
    _passwdEditController.addListener(() {
      _passwd = _passwdEditController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _accountEditController.dispose();
    _passwdEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _accountEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "account"
              ),
            ),
            SizedBox(height: 40,),
            TextField(
              controller: _passwdEditController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "password"
              ),
            ),
            SizedBox(height: 40,),
            MainButton(() {
              login();
            }, "登录")
          ],
        ),
        
      ),
    );
  }

  void login() async {
    print("{\"account\": $_account, \"passwd\": $_passwd}");
    var response = await Request.post("/login", {"account": _account, "passwd": _passwd});
    var data = JsonDecoder().convert(response.body);
    var loginData = LoginData.fromJson(data);
    if (loginData.data != "") {
      await ScopedModel.of<TokenDataWidget>(context, rebuildOnChange: true).setLoginState(loginData.data, _account);
    } else {
      
    }
  }
}
