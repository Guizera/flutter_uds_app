import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uds_app/model/users.dart';
import 'package:flutter_uds_app/services/authService.dart';

class ProfileUser extends StatefulWidget {

  ProfileUser({Key key, this.userId, this.auth}) : super(key : key);

  final String userId;
  final BaseAuth auth;


  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {

  List<Users> _usersList;

  final databaseReference = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> _onUsersAdded;
  StreamSubscription<Event> _onUsersEdited;

  Query _usersQuery;

  @override
  void initState() {
    super.initState();

    _usersList = new List();

    _usersQuery = databaseReference.child('users').orderByChild('userId').equalTo(widget.userId);
    _onUsersAdded = _usersQuery.onChildAdded.listen(onEntryAdded);
    _onUsersEdited = _usersQuery.onChildChanged.listen(onEntryChanged);
  }
  @override
  void dispose() {
    _onUsersAdded.cancel();
    _onUsersEdited.cancel();
    super.dispose();
  }
  onEntryChanged(Event event) {
    var oldEntry = _usersList.singleWhere((entry) {
      return entry.key == event.snapshot.key;

    });
    setState(() {
      _usersList[_usersList.indexOf(oldEntry)] = Users.fromSnapshot(event.snapshot);
    });
  }
  onEntryAdded(Event event) {
    setState(() {
      _usersList.add(Users.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
      return ListView.builder(
        itemCount: _usersList.length,
          itemBuilder: (BuildContext context, int index) {
          String name = _usersList[index].name;
          String email = _usersList[index].email;
          return Container(
            alignment: Alignment.center,
            child: Card(
              elevation: 10,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                child: Container(
                  decoration: new BoxDecoration(boxShadow:[ new BoxShadow(color: Colors.grey[200], blurRadius: 20.0)]),
                  child: Padding(
                      padding: EdgeInsets.all(22.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              name,
                              style: TextStyle(color: Colors.blue, fontSize: 32.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              email,
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 24.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                  ),
                )
              ),
            ),


          );
          }
      );
  }
}
