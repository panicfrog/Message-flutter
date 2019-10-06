import 'package:flutter/material.dart';
import 'package:message/Screens/setting.dart';

import 'address_book.dart';
import 'chat.dart';

class MessageTabbedPage extends StatefulWidget {
  const MessageTabbedPage({Key key}) : super(key: key);

  @override 
  _MessageTabbedPageState createState() => _MessageTabbedPageState();
}

class _MessageTabbedPageState extends State<MessageTabbedPage> {
  int _selectedIndex = 0;

  final List<String> myTabs = <String>["聊天", "通讯录", "设置",];
  final List<Widget> pages = <Widget>[ChatScreen(title: "聊天"), AddressScreen(title: "通讯录"),  SettingScreen(title: "设置")];

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text(myTabs[0])),
              BottomNavigationBarItem(icon: Icon(Icons.supervisor_account), title: Text(myTabs[1])),
              BottomNavigationBarItem(icon: Icon(Icons.build), title: Text(myTabs[2])),
            ],
            currentIndex: _selectedIndex,
            fixedColor: Colors.blue,
            onTap: _onItemTapped,
          ),
          body: IndexedStack(
                  children: <Widget>[
                    ChatScreen(title: "聊天"),
                    AddressScreen(title: "通讯录"),
                    SettingScreen(title: "设置"),
                  ],
                   index: _selectedIndex,
                ),
      );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody(int index) {
    return pages[index];
  } 
}