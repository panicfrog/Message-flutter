import 'package:flutter/material.dart';
import 'package:message/Screens/Tabbed.dart';
import 'package:message/Screens/login.dart';
import 'package:message/data/token.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "message",
      home: ScopedModel<TokenDataWidget>(
        model: new TokenDataWidget(),
        child: MainWidget(),
      )
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  @override 
  Widget build(BuildContext context) {
    final _token = ScopedModel.of<TokenDataWidget>(context, rebuildOnChange: true).token;
    return _token == "" ? LoginScreen() : MessageTabbedPage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}