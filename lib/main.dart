import 'package:flutter/material.dart';
import 'package:flutter_uds_app/pages/login_page.dart';
import 'services/authService.dart';
import 'pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uds app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: Auth()),
    );
  }
}


