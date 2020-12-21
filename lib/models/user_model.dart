import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String uid;
  String name;
  String urlAvatar;
  String bio;
  int age;
  String gender;
  String hometown;
  String work;
  String uni;
  String location;
  DateTime lastMessageTime;

  User({
    this.hometown,
    this.work,
    this.uid,
    this.uni,
    this.location,
    this.gender,
    this.name,
    this.urlAvatar,
    this.lastMessageTime,
    this.bio,
    this.age,
  });

  factory User.fromMap(Map data) {
    return User(
        uid: data['uid'] ?? '',
        name: data['name'] ?? '',
        urlAvatar: data['urlAvatar'] ?? '',
        lastMessageTime: data['lastmessageTime'] ?? '',
        age: data['age'] ?? '',
        bio: data['age'] ?? '',
        work: data['work'] ?? '',
        gender: data['gender'] ?? '',
        hometown: data['hometown'] ?? '');
  }
}
