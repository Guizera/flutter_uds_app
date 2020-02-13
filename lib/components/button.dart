import 'package:flutter/material.dart';

class ButtonDefault extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;

  ButtonDefault({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blue)
      ),
      color: Colors.blue,
      textColor: Colors.white,
      child: Text(this.title,
      style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}
