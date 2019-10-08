import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:message/blocs/application_bloc.dart';
import 'package:message/blocs/bloc_provider.dart';
import 'package:message/component/main_button.dart';
import 'package:message/helper/Toast.dart';
import 'package:message/network/dio_request.dart';
import 'package:message/network/login_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  ApplicationBloc _authBloc;

  String _account;
  String _passwd;

  TextEditingController _accountEditController = TextEditingController();
  TextEditingController _passwdEditController = TextEditingController();

  @override
  void initState() {
    _accountEditController.addListener(() {
      _account = _accountEditController.text;
    });
    _passwdEditController.addListener(() {
      _passwd = _passwdEditController.text;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = BlocProvider.of<ApplicationBloc>(context);
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _accountEditController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "account"),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _passwdEditController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "password"),
                ),
                SizedBox(
                  height: 40,
                ),
                MainButton(() {
                  login();
                }, "登录")
              ],
            ),
          ),
        ));
  }

  void login() async {
    if (_account == null || _account.length == 0) {
        MToast.show("请输入账号");
        return;
      }
    if (_passwd == null || _passwd.length == 0) {
      MToast.show("请输入密码");
      return;
    }
    try {
      var response = await DRequest()
          .post("/login", body: {"account": _account, "passwd": _passwd});
      var loginData = LoginData.fromJson(response);
      MToast.show("登录成功");
      await _authBloc.setLoginState(loginData.data, _account);
    } on DioError catch (e) {
      MToast.show(e.message);
    }
  }
}
