import 'package:flutter/material.dart';
import 'package:flutter_uds_app/components/button.dart';
import 'package:flutter_uds_app/services/authService.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _name;
  String _errorMessage;

  bool _isLoginForm = false;
  bool _isLoading = false;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  void validateAndSubmit() async {
    if(validateAndSave()) {
      String userId = '';
      try {
        if(_isLoginForm) {
          userId = await widget.auth.login(_email, _password);
          print('logado como: $userId');
        } else {
          userId = await widget.auth.register(_name, _email, _password);
          print('registrado como $userId');
          alertConfirm();
        }
        setState(() {
          _isLoading = false;
        });
        if(userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = '';
  }
  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
  Widget alertConfirm() {
    return AlertDialog(
      title: Text('sucesso'),
      content: Text('Usuario cadastrado com sucesso'),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  Widget setNameField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: TextFormField(
          autofocus: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Coloque seu nome',
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.blue, width: 1.0)),
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          validator: (value) => value.isEmpty ? 'Nome não pode ser vazio' : null,
          onSaved: (value) => _name = value.trim(),
        )
    );
  }
  Widget emptySpace() {
    return new Container();
  }

  Widget loginForm() {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
             _isLoginForm ? emptySpace() : setNameField(),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Coloque seu email',
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) => value.isEmpty ? 'Email não pode ser vazio' : null,
                    onSaved: (value) => _email = value.trim(),
                  )
              ),
              Padding(
                padding:EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Coloque sua senha',
                    contentPadding: EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.0)),
                  ),
                  validator: (value) => value.isEmpty ? 'Senha não pode ser vazia' : null,
                  onSaved: (value) => _password = value.trim(),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: ButtonDefault(
                  title: _isLoginForm ? 'Entrar' : 'Registrar',
                  onPressed: validateAndSubmit,),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: FlatButton(
                  onPressed: toggleFormMode,
                  child: Text(_isLoginForm ? 'Criar uma conta' : 'Ja possuo uma conta'),
                  color: Colors.transparent,
                  textColor: Colors.blue,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              bottom: MediaQuery.of(context).size.height/2,
              child: Image.asset('lib/assets/login-img.jpg'),
            ),
            Padding(
              padding: EdgeInsets.all(120),
              child: Image(image: AssetImage('lib/assets/logo-branco.png')),
            ),
            Positioned(
              top: 190,
              child: Container(
                padding: EdgeInsets.all(32),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(62),
                      topRight: Radius.circular(62)
                  ),
                ),
                child: loginForm(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

