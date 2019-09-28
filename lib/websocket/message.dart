
class Message {
  String from;
  String to;
  int type;   // TextMessage = 0x01,  PictureMessage = 0x02, VoiceMessage = 0x03, FileMessage = 0x04
  String content;
  int mode;  // SingleChat = 0x01, GroupChat = 0x02
  String identifier;

  Message({this.from, this.to, this.type, this.content, this.mode, this.identifier});

  Message.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    type = json['type'];
    content = json['content'];
    mode = json['mode'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['type'] = this.type;
    data['content'] = this.content;
    data['mode'] = this.mode;
    data['identifier'] = this.identifier;
    return data;
  }
}