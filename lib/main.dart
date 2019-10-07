import 'package:flutter/material.dart';
import 'package:message/Screens/Tabbed.dart';
import 'package:message/Screens/login.dart';
import 'package:message/blocs/application_bloc.dart';
import 'package:message/blocs/bloc_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "message",
      home: BlocProvider(
        bloc: ApplicationBloc(),
        child: MainWidget(),
      )
    );
  }
}


class MainBlocWidget extends StatefulWidget {
  @override 
  _MainBlocWidgetState createState() => _MainBlocWidgetState();
}

class _MainBlocWidgetState extends State<MainBlocWidget> {

  ApplicationBloc appBloc;
  @override 
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder<String>(
          stream: appBloc.token$,
          builder: (context, snapshot) {
            if (snapshot.data.length > 0) { // 登录了
              return Text("登录了");
            } else {
              return Text("为登录");
            }
          },
        )
      );
  }

  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    appBloc = BlocProvider.of<ApplicationBloc>(context);
  }
}

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  ApplicationBloc appBloc;

  @override 
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: appBloc.token$.stream,
      builder: (context, snapshot) {
        return snapshot.data.length > 0 ? MessageTabbedPage() : LoginScreen();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appBloc = BlocProvider.of<ApplicationBloc>(context);
  }
}