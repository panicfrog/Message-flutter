import 'package:flutter/material.dart';
import 'package:message/screens/chat_detail.dart';
import 'package:message/Static/strings.dart';
import 'package:message/blocs/application_bloc.dart';
import 'package:message/blocs/bloc_provider.dart';
import 'package:message/network/dio_request.dart';
import 'package:message/network/user_friends_model.dart';
import 'package:message/network/user_rooms_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<AddressScreen> {
  ApplicationBloc appBloc;

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
    if (_m.length == 0) {
      return _is;
    }
    _is.add(AddressHeadingItem("好友"));
    contents[_m[AddressFlagType.friend]].forEach((c) {
      _is.add(c);
    });
    _is.add(AddressHeadingItem("群组"));
    contents[_m[AddressFlagType.room]].forEach((c) {
      _is.add(c);
    });
    return _is;
  }

  @override
  initState() {
    request();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appBloc = BlocProvider.of<ApplicationBloc>(context);
  }

  request() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString(TOKEN_KEY);
    if (_token == null || _token.length == 0) {
      return;
    }
    getAddressData(_token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: StreamBuilder<String>(
        stream: appBloc.userAccount$.stream,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: _listItems.length,
            itemExtent: 50,
            itemBuilder: (BuildContext context, int index) {
              final i = _listItems[index];
              if (i is AddressHeadingItem) {
                return Container(
                  color: Colors.lightBlue,
                  child: ListTile(
                    title: Text(
                      i.heading,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else if (i is AddressFlag) {
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(i.display),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ChatDetailPage(
                                    type: i.type == AddressFlagType.room
                                        ? ChatType.Room
                                        : ChatType.Person,
                                    identity: i.identifier,
                                    nickName: i.display,
                                    userAccount: snapshot.data,
                                  )));
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      )),
    );
  }

  void getAddressData(String token) async {
    var responses = await Future.wait([
      DRequest().get("/auth/user/rooms"),
      DRequest().get("/auth/user/friends")
    ]);
    UserRoomsModel roomModel = UserRoomsModel.fromJson(responses[0].data);
    UserFriendsModel userModel = UserFriendsModel.fromJson(responses[1].data);
    setState(() {
      if (roomModel != null && roomModel.data != null) {
        _items.removeWhere((t) {
          return t.type == AddressFlagType.room;
        });
        _items.addAll(roomModel.data);
      }
      if (userModel != null && userModel.data != null) {
        _items.removeWhere((t) {
          return t.type == AddressFlagType.friend;
        });
        _items.addAll(userModel.data);
      }
    });
  }
}

abstract class AddressItme {}

class AddressHeadingItem implements AddressItme {
  final String heading;
  AddressHeadingItem(this.heading);
}
