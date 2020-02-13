import 'package:flutter/material.dart';


class DialogWaiting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10.0,
      backgroundColor: Colors.white,
      insetAnimationDuration: Duration(milliseconds: 100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        height: 200,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Carregando...',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w300),),
            )
          ],
        ),
      ),
    );
  }
}

