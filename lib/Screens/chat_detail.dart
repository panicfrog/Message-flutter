
import 'package:flutter/material.dart';
import 'package:message/websocket/message.dart';
import 'package:message/websocket/websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ChatType { Person, Room }

class ChatDetailPage extends StatefulWidget {
  ChatDetailPage({this.identity, this.type, this.nickName, this.userAccount, Key key}): super(key: key);
  final String identity;
  final ChatType type;
  final String nickName;
  final String userAccount;
  @override
  State<StatefulWidget> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetailPage> {
  List<Message> _messages = [];
  Websocket ws;

  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    connectWebsocket();
    super.initState();
  }

  @override
  void deactivate() {
    if (ws != null) {
      ws.disconnect();
    }
    super.deactivate();
  }

  void connectWebsocket() async {
    ws = Websocket();
    if (ws != null && ws.connected) {
      ws.disconnect();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("message.token");
    ws.connect(token);
    dealMessage(ws);
  }

  void dealMessage(Websocket ws) async {
    if (!ws.connected) {
      Future.delayed(const Duration(seconds: 1), () {
        dealMessage(ws);
      });
    } else {
      ws.msgStream.listen((msg) {
        print("webosckt listen ${msg.toJson()} identity: ${widget.identity}");
        if (msg.mode == 1) { // 单聊
          if((msg.from == widget.userAccount && msg.to == widget.identity) || (msg.from == widget.identity && msg.to == widget.userAccount)) {
            setState(() {
              _messages.add(msg);
            });
          }
        } else if (msg.mode == 2) { // 群聊
          if (msg.to == widget.identity) {
            setState(() {
              _messages.add(msg);
            });
          }
        }
      });
    }
  }


  @override 
  void dispose() {
    inputController.dispose();
    if (ws != null ) {
      ws.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nickName),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  // return ListTile(
                  //   title: Text(_messages[index].from),
                  //   subtitle: Text(_messages[index].content),
                  // );
                  return buildChatItem(context, index);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(22, 0, 12, 0),
              color: Colors.white70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        hintText: "请输入聊天内容"
                      ),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    highlightColor: Colors.transparent,
                    child: Container(
                        child: Text("发送", style: TextStyle(color: Colors.white),),
                        padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                      ),
                    onPressed: () {
                      if (inputController.text != null && inputController.text.length > 0) {
                        Websocket ws = new Websocket();
                        ws.sendMessage(widget.userAccount, widget.identity, inputController.text, widget.type, ChatMessageType.Text);
                        inputController.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        )
      )
    );
  }
  Widget buildChatItem(BuildContext context, int index) {
      final d = _messages[index];
      bool fromSelf = false;
      if (d.from == widget.userAccount) {// 自己发的
        fromSelf = true;
      } else { // 别人发的
        fromSelf = false;
      }

      return Padding(
        padding: EdgeInsets.fromLTRB(fromSelf ? 75 : 12, 6,  fromSelf ? 12 : 75, 6),
        child: Column(
            children: <Widget>[
              Text(d.from),
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                decoration: BoxDecoration(
                  color: fromSelf ? Theme.of(context).accentColor : Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Text(d.content, style: TextStyle(color: fromSelf ? Colors.white : Colors.black),),
              ),
            ],
            crossAxisAlignment: fromSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          ),
        );
    }
}