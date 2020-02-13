import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uds_app/components/button.dart';
import 'package:flutter_uds_app/model/guidelines.dart';
import 'package:flutter_uds_app/pages/guidelines_open.dart';
import 'package:flutter_uds_app/pages/login_page.dart';
import 'package:flutter_uds_app/pages/profile.dart';
import 'package:flutter_uds_app/services/authService.dart';
import 'package:flutter_uds_app/pages/guidelines_closes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Guidelines> _guideList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textAuthorController = TextEditingController();
  final _textTitleController = TextEditingController();
  final _textDescriptionController = TextEditingController();
  StreamSubscription<Event> _onGuidelinesAdded;
  StreamSubscription<Event> _onGuidelinesEdited;

  Query _guidelinesQuery;

  int _currentIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _guideList = new List();
    _guidelinesQuery = _database.reference().child('guidelines').orderByChild('userId').equalTo(widget.userId);

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

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
      return new LoginPage();
    } catch (e) {
      print(e);
    }
  }

  addNewGuide(String author, String title, String description) {
    if(author.length > 0 && title.length > 0 && description.length > 0) {
      Guidelines guidelines = new Guidelines(author.toString(), title.toString(), description.toString(), '1', widget.userId);
      _database.reference().child('guidelines').push().set(guidelines.toJson());
    }
  }

  Widget dialogError() {
    return AlertDialog(
      title: Text('Existem campos que nao foram Preenchidos'),
    );
  }
  
  showAddGuidesDialog(BuildContext context) async {
    _textAuthorController.clear();
    _textTitleController.clear();
    _textDescriptionController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('Cadastre uma pauta'),
              actions: <Widget>[
              ],
            ),
            body: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _textAuthorController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'adicione um Autor',
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.0)),
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _textTitleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Adicione um titulo',
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.0)),
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _textDescriptionController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'adicione uma nova descrição',
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.0)),
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: new ButtonDefault(
                      title: 'Salvar',
                      onPressed: () {
                        if(_textAuthorController.text.isEmpty && _textTitleController.text.isEmpty && _textDescriptionController.text.isEmpty) {
                              print('existem campos vazios');
                              dialogError();
                        }else {
                          addNewGuide(_textAuthorController.text.toString(),_textTitleController.text.toString(),_textDescriptionController.text.toString());
                          Navigator.pop(context);
                        }
                      }),
                ),
              ],
            ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('App de pautas UDS'),
        actions: <Widget>[
          new FlatButton(
              onPressed: signOut, 
              child: Icon(Icons.exit_to_app, color: Colors.white,)
          )
        ],
      ),
      body: new PageView(
        controller: _pageController,
        children: [
          OpenGuides(userId: widget.userId),
          CloseGuides(userId: widget.userId),
          ProfileUser(userId: widget.userId),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddGuidesDialog(context);
        },
        tooltip: 'increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInCirc);
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text('Pautas Abertas'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.collections_bookmark),
            title: new Text('Pautas Fechadas'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Perfil')
          )
        ],
      ),
    );
  }
}

