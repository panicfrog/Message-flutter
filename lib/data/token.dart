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
    _token = prefs.getString("message.token");
    _userAccount = prefs.getString("message.user_account");
    notifyListeners();
  }

  setLoginState(String t, u) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isSuccess = await prefs.setString("message.token", t);
    var uIsSuccess = await prefs.setString("message.user_account", u);
    if (isSuccess && uIsSuccess) {
      _token = t;
      _userAccount = u;
      notifyListeners();
    }
  }
  
}