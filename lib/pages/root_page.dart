import 'package:flutter/material.dart';
import 'package:flutter_uds_app/pages/guidelines_closes.dart';
import 'package:flutter_uds_app/services/authService.dart';
import 'package:flutter_uds_app/pages/login_page.dart';
import 'package:flutter_uds_app/pages/home_page.dart';
import 'package:flutter_uds_app/components/dialogWaiting.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {

  RootPage({this.auth});

  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  String _userid = '';

  @override
  void initState() {

    super.initState();

    widget.auth.getCurrentUser().then((user){
      setState(() {
        if(user != null) _userid = user?.uid;

        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;

      });
    });
  }
  void loginCallback() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userid = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }
  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userid = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    switch(authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return DialogWaiting();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if(_userid.length > 0 && _userid != null)
        return new HomePage(
          userId: _userid,
          auth: widget.auth,
          logoutCallback: logoutCallback,
        );
        else
           return DialogWaiting();
        break;
      default:
        return DialogWaiting();
    }
  }
}

