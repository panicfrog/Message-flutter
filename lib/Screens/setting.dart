import 'package:flutter/material.dart';
import 'package:message/component/main_button.dart';
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
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MainButton((){
              ScopedModel.of<TokenDataWidget>(context, rebuildOnChange: true).setLoginState("", "");
            }, "退出"),
          ],
        ),
      ),
    );
  }

}
