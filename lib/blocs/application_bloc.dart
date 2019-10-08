import 'package:message/static/strings.dart';
import 'package:message/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc implements BlocBase {
  var token$ = BehaviorSubject<String>.seeded("");
  var userAccount$ = BehaviorSubject<String>.seeded("");

  ApplicationBloc() {
    _getToken();
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(TOKEN_KEY);
    if (token != null) {
      token$.add(token);
    }
    var userAccount = prefs.getString(USER_ACCOUNT_KEY);
    if (userAccount != null) {
      userAccount$.add(userAccount);
    }
  }

  setLoginState(String t, u) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isSuccess = await prefs.setString(TOKEN_KEY, t);
    var uIsSuccess = await prefs.setString(USER_ACCOUNT_KEY, u);
    if (isSuccess && uIsSuccess) {
      token$.add(t);
      userAccount$.add(u);
    }
  }

  @override
  void dispose() {
    token$.close();
    userAccount$.close();
  }

}