import 'dart:async';
import 'dart:convert';

import 'package:message/screens/chat_detail.dart';
import 'package:message/network/env.dart';
import 'package:message/websocket/message.dart';
import 'package:web_socket_channel/io.dart';

enum ChatMessageType{ Text, Picture, Voice, File }

class Websocket {

  static final Websocket _singleton = new Websocket._internal();

  factory Websocket() => _singleton;
  Websocket._internal();

  IOWebSocketChannel _channel;
  bool _connected = false;
  bool get connected  => _connected;

  Stream<Message> msgStream;

  void connect(String token) {
    if (_connected) { return; }
    _channel = IOWebSocketChannel.connect("ws://" + Env.host + ":8081?token=$token");
    _connected = true;
    msgStream = _channel.stream.map((msg) {
      print("websocket: $msg");
      if (msg is String) {
        var map = JsonDecoder().convert(msg);
        if (map is Map) {
          Message m = Message.fromJson(map);
          return m;
        } else {
          throw Exception();
        }
      } else {
        throw Exception();
      }
    });
  }

  void disconnect() {
    if (_channel != null && _channel.sink != null) {
      _channel.sink.close();
    }
    _connected = false;
    _channel = null;
  }

  void sendMessage(String from, to, content, ChatType type, ChatMessageType msgType)  {
    int m = 1;
    switch (type) {
      case ChatType.Person: m = 1; break;
      case ChatType.Room: m = 2; break;
    }
    int t = 1;
    switch (msgType) {
      case ChatMessageType.Text: t = 1; break;
      case ChatMessageType.Picture: t = 2; break;
      case ChatMessageType.Voice: t = 3; break;
      case ChatMessageType.File: t = 4; break;
    }
    Message msg = Message(
      from: from,
      to: to,
      content: content,
      type: t,
      mode: m,
    );
    String str = JsonEncoder().convert(msg);
    _channel.sink.add(str);
  }
}