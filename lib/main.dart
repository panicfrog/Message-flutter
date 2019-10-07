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