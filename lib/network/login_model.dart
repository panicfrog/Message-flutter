class LoginData {
  String data;
  String message;
  int sc;

  LoginData(this.data, this.message, this.sc);

  LoginData.fromJson(Map<String, dynamic> json)
    : data = json['data'],
      message = json['message'],
      sc = json['sc'];
}