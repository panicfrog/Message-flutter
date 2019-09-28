import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:message/Screens/chatDetail.dart';
import 'package:message/data/token.dart';
import 'package:message/network/request.dart';
import 'package:message/network/userFriendsModel.dart';
import 'package:message/network/userRoomsModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<AddressScreen> {
  List<Room> _rooms = [];
  List<Friends> _friends = [];

  @override
  initState() {
    request();
    super.initState();
  }

  request() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString("message.token");
    if (_token == null || _token.length == 0) {
      return;
    }
    getRooms(_token);
    getFriends(_token);
  }

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<TokenDataWidget>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '房间',
              textAlign: TextAlign.left,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: _rooms.length,
                itemExtent: 50,
                itemBuilder: (BuildContext context, int index) {
                  return  Container(
                      color: Colors.orange,
                      child: ListTile(
                        title: Text(
                          _rooms[index].roomName,
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatDetailPage(
                                        type: ChatType.Room,
                                        identity: _rooms[index].roomIdentifier,
                                        nickName: _rooms[index].roomName,
                                        userAccount: model.userAccount,
                                      )));
                        },
                      ));
                },
              ),
            ),
            Text(
              "好友",
              textAlign: TextAlign.left,
            ),
            Flexible(
                child: ListView.builder(
              itemCount: _friends.length,
              itemExtent: 50,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    color: Colors.orange,
                    child: ListTile(
                      title: Text(_friends[index].account, style: TextStyle(color: Colors.white)),
                       onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatDetailPage(
                                      type: ChatType.Person,
                                      identity: _friends[index].account,
                                      nickName: _friends[index].account,
                                      userAccount: model.userAccount,
                                    )
                                  )
                                );
                      },
                    )
                  );
              },
            ))
          ],
        ),
      ),
    );
  }

  void getRooms(String token) async {
    var response = await Request.get("/auth/user/rooms");
    var data = JsonDecoder().convert(response.body);
    UserRoomsModel model = UserRoomsModel.fromJson(data);
    setState(() {
      _rooms = model.data;
    });
  }

  void getFriends(String token) async {
    var response = await Request.get("/auth/user/friends");
    var data = JsonDecoder().convert(response.body);
    print(data);
    UserFriendsModel model = UserFriendsModel.fromJson(data);
    _friends = model.data;
  }
}
