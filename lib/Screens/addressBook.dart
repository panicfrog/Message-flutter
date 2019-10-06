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
  List<AddressFlag> _items = [];
  List<AddressItme> get _listItems {
    List<AddressItme> _is = [];
    List<List<AddressFlag>> contents = [];
    Map<AddressFlagType, int> _m = Map();
    _items.forEach((i) {
      if (!_m.containsKey(i.type)) {
        _m[i.type] = _m.length;
        List<AddressFlag> l = List<AddressFlag>();
        l.add(i);
        contents.add(l);
      } else {
        int index = _m[i.type];
        contents[index].add(i);
      }
    });
    _m.forEach((k, v){
      String header = k == AddressFlagType.friend ? "好友" : "房间";
      _is.add(AddressHeadingItem(header));
      contents[v].forEach((c) {
        _is.add(c);
      });
    });
    return _is;
  }

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
        child: ListView.builder(
          itemCount: _listItems.length,
          itemExtent: 50,
          itemBuilder: (BuildContext context, int index){
            final i = _listItems[index];
            if (i is AddressHeadingItem) {
              return Container(
                color: Colors.lightBlue,
                child: ListTile(
                  title: Text(i.heading, style: TextStyle(color: Colors.white),),
                ),
              );
            } else if (i is AddressFlag) {
              return Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(i.display),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (ctx) => ChatDetailPage(
                        type: i.type == AddressFlagType.room ? ChatType.Room : ChatType.Person,
                        identity: i.identifier,
                        nickName: i.display,
                        userAccount: model.userAccount,
                      )
                    ));
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        )
      ),
    );
  }

  void getRooms(String token) async {
    var response = await Request.get("/auth/user/rooms");
    var data = JsonDecoder().convert(response.body);
    UserRoomsModel model = UserRoomsModel.fromJson(data);
    setState(() {
      _items.removeWhere((t){ return t.type == AddressFlagType.room; });
      _items.addAll(model.data);
    });
  }

  void getFriends(String token) async {
    var response = await Request.get("/auth/user/friends");
    var data = JsonDecoder().convert(response.body);
    UserFriendsModel model = UserFriendsModel.fromJson(data);
    setState(() {
      _items.removeWhere((t){ return t.type == AddressFlagType.friend; });
      _items.addAll(model.data);
    });
  }
}

abstract class AddressItme {}

class AddressHeadingItem implements AddressItme {
  final String heading;
  AddressHeadingItem(this.heading);
}
