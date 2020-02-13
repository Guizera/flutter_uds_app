import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_uds_app/model/users.dart';

abstract class BaseAuth {

  Future<String> login(String email, String password);

  Future<String> register(String name, String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> emailVerification();

  Future<void> emailVerified();

  Future<void> signOut();


}
class Auth implements BaseAuth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //final Firestore _firestore = Firestore.instance;

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> login(String email, String password) async {

    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    FirebaseUser user = result.user;

    return user.uid;

  }

  Future<String> register(String name, String email, String password) async {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      FirebaseUser userRegister = result.user;

      if(userRegister != null) {
        Users users = new Users(name.toString(), email.toString(), userRegister.uid.toString());
        databaseReference.child('users').push().set(users.toJson());
      }
      return userRegister.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {

    FirebaseUser user = await _firebaseAuth.currentUser();

    return user;

  }

  Future<void> signOut() async {
    print('Desconectado');
    return _firebaseAuth.signOut();
  }

  Future<void> emailVerification() async {

    FirebaseUser user = await _firebaseAuth.currentUser();

    user.sendEmailVerification();

  }

  Future<bool> emailVerified() async {

    FirebaseUser user = await _firebaseAuth.currentUser();

    return user.isEmailVerified;

  }

}