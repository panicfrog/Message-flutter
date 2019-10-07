import 'package:message/Static/strings.dart';
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

  @override
  void dispose() {
    token$.close();
    userAccount$.close();
  }

}