import 'package:message/Static/strings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenDataWidget extends Model {
  TokenDataWidget(): super() {
    _getLoginState();
  }

  String _token = "";
  String _userAccount = "";

  String get token => _token;
  String get userAccount => _userAccount;

  _getLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(TOKEN_KEY);
    _userAccount = prefs.getString(USER_ACCOUNT_KEY);
    notifyListeners();
  }

  setLoginState(String t, u) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isSuccess = await prefs.setString(TOKEN_KEY, t);
    var uIsSuccess = await prefs.setString(USER_ACCOUNT_KEY, u);
    if (isSuccess && uIsSuccess) {
      _token = t;
      _userAccount = u;
      notifyListeners();
    }
  }
  
}