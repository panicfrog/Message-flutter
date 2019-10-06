import 'package:flutter/material.dart';

class MainButton extends MaterialButton {
  final VoidCallback onPress;
  final String title;

  MainButton(this.onPress, this.title);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Container(
          child: Text(
            this.title,
            style: TextStyle(color: Colors.white),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minHeight: 55,
            minWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).accentColor,
          ),
        ),
        padding: EdgeInsets.all(0),
        onPressed: this.onPress);
  }
}
