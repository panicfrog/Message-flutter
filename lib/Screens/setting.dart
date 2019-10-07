import 'package:flutter/material.dart';
import 'package:message/blocs/application_bloc.dart';
import 'package:message/blocs/bloc_provider.dart';
import 'package:message/component/main_button.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingScreen>  {
  ApplicationBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = BlocProvider.of<ApplicationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MainButton((){
              _authBloc.setLoginState("", "");
            }, "退出"),
          ],
        ),
      ),
    );
  }

}
