import 'package:firebase_database/firebase_database.dart';

class Guidelines {
  String key;
  String author;
  String title;
  String description;
  String userId;
  String status;

  Guidelines(this.author, this.title, this.description, this.status, this.userId);

  Guidelines.fromSnapshot(DataSnapshot snapshot) :
      key         = snapshot.key,
      userId      = snapshot.value['userId'],
      author      = snapshot.value['author'],
      title       = snapshot.value['title'],
      description = snapshot.value['description'],
      status      = snapshot.value['status'];

  toJson() {
    return {
      'userId'      : userId,
      'author'      : author,
      'title'       : title,
      'description' : description,
      'status'      : status,
    };
  }
}