import 'package:message/network/userFriendsModel.dart';

class UserFriendsModel {
  
  List<Friends> data;
  String message;
  int sc;

  UserFriendsModel({this.data, this.message, this.sc});

  UserFriendsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Friends>();
      json['data'].forEach((v) {
        data.add(new Friends.fromJson(v));
      });
    }
    message = json['message'];
    sc = json['sc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['sc'] = this.sc;
    return data;
  }
}

class Friends implements AddressFlag {
  String account;
  int status;

  Friends({this.account, this.status});

  Friends.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['status'] = this.status;
    return data;
  }

  @override
  String get display => account;

  @override
  String get identifier => account;

  @override 
  AddressFlagType get type => AddressFlagType.friend;
}