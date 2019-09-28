import 'package:flutter/material.dart';
import 'package:message/data/token.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingScreen>  {

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
            RaisedButton(
              child: Text("退出"),
              onPressed: () {
                 ScopedModel.of<TokenDataWidget>(context, rebuildOnChange: true).setLoginState("", "");
              },
            )
          ],
        ),
      ),
    );
  }

}
