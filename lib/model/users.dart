import 'package:firebase_database/firebase_database.dart';

class Users {
 String key;
 String name;
 String email;
 String userId;

 Users(this.name, this.email, this.userId);

 Users.fromSnapshot(DataSnapshot snapshot) :
     key = snapshot.key,
     name = snapshot.value['name'],
     email = snapshot.value['email'];

 toJson() {
   return {
     'name' : name,
     'email' : email,
     'userId' : userId
   };
 }
}