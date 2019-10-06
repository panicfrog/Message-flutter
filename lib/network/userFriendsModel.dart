import 'package:message/Screens/addressBook.dart';

enum AddressFlagType { room, friend }

abstract class AddressFlag implements AddressItme {
  String get identifier;
  String get display;
  AddressFlagType get type;
}

class UserRoomsModel {
  List<Room> data;
  String message;
  int sc;

  UserRoomsModel({this.data, this.message, this.sc});

  UserRoomsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Room>();
      json['data'].forEach((v) {
        data.add(new Room.fromJson(v));
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

class Room implements AddressFlag {
  String owner;
  String roomIdentifier;
  String roomName;

  Room({this.owner, this.roomIdentifier, this.roomName});

  Room.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    roomIdentifier = json['room_identifier'];
    roomName = json['room_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['room_identifier'] = this.roomIdentifier;
    data['room_name'] = this.roomName;
    return data;
  }

  @override
  String get display => roomName;

  @override
  String get identifier => roomIdentifier;

  @override 
  AddressFlagType get type => AddressFlagType.room;
}