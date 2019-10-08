class BaseModel {
  dynamic data;
  String message;
  int sc;

  BaseModel.fromJson(Map<String, dynamic> json)
    : data = json['data'],
      message = json['message'],
      sc = json['sc'];
}

