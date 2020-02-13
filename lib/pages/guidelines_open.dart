import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uds_app/model/guidelines.dart';
import 'package:flutter_uds_app/services/authService.dart';

class OpenGuides extends StatefulWidget {

  OpenGuides({Key key, this.auth, this.userId}) : super(key : key);

  final BaseAuth auth;
  final String userId;


  @override
  _OpenGuidesState createState() => _OpenGuidesState();
}

class _OpenGuidesState extends State<OpenGuides> {

  List<Guidelines> _guideList;

  final databaseReference = FirebaseDatabase.instance.reference();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onGuidelinesAdded;
  StreamSubscription<Event> _onGuidelinesEdited;

  Query _guidelinesQuery;

  @override
  void initState() {
    super.initState();

    _guideList = new List();
    _guidelinesQuery = databaseReference.child('guidelines').orderByChild('userId').equalTo(widget.userId);

    _onGuidelinesAdded = _guidelinesQuery.onChildAdded.listen(onEntryAdded);
    _onGuidelinesEdited = _guidelinesQuery.onChildChanged.listen(onEntryChanged);

  }
  @override
  void dispose() {
    _onGuidelinesAdded.cancel();
    _onGuidelinesEdited.cancel();
    super.dispose();
  }
  onEntryChanged(Event event) {
    var oldEntry = _guideList.singleWhere((entry) {
      return entry.key == event.snapshot.key;

    });
    setState(() {
      _guideList[_guideList.indexOf(oldEntry)] = Guidelines.fromSnapshot(event.snapshot);
    });
  }
  onEntryAdded(Event event) {
    setState(() {
      _guideList.add(Guidelines.fromSnapshot(event.snapshot));
    });
  }

  void updateGuide(Guidelines guidelines) async {
    if(guidelines.status == '1') {
      setState(() {
        databaseReference.child('guidelines').child(guidelines.key).update({
          'status': '2',
        });
        print('Pauta fechada');
      });
    }
  }
  showContentGuide(String author, String title, String description,status) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Autor: $author'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(title),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(description),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  updateGuide(status);
                },
                child: Text('Fechar Pauta'),
              )
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    if(_guideList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _guideList.length,
          itemBuilder: (BuildContext context, int index) {
            String guideId = _guideList[index].key;
            String author = _guideList[index].author;
            String title = _guideList[index].title;
            String description = _guideList[index].description;
            if(_guideList[index].status == '1') {
              return new Container(
                child: ListTile(
                  onTap: (){
                    showContentGuide(author, title, description, _guideList[index]);
                    print('clicado $title');
                  },
                  title: Text(title, style: TextStyle(fontSize: 16.0)),
                  subtitle: Text(description, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                ),
              );
            } return new Container();
          }
      );
    } else {
      return new Container();
    }
  }
}
