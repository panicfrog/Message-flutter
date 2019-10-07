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
    );
  }

  void login() async {
    var response = await DRequest()
        .post("/login", body: {"account": _account, "passwd": _passwd});
    var loginData = LoginData.fromJson(response.data);
    if (loginData != null && loginData.data != null && loginData.data != "") {
      MToast.show("登录成功");
      await _authBloc.setLoginState(loginData.data, _account);
    } else {}
  }
}
