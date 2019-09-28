import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '聊天',
            ),
          ],
        ),
      ),
    );
  }
}