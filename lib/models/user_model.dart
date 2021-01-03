import 'package:meta/meta.dart';

import '../utils.dart';

enum Gender {
  male,
  female,
  other,
  all,
  malefemale,
}

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String uid;
  String name;
  String urlAvatar;
  String bio;
  int age;
  dynamic gender;
  dynamic lookingFor;
  String from;
  String work;
  String edu;
  String live;

  User({
    this.from,
    this.work,
    this.uid,
    this.edu,
    this.live,
    this.gender,
    this.lookingFor,
    this.name,
    this.urlAvatar,
    this.bio,
    this.age,
  });

  User.fromJson(Map<String, dynamic> data)
    : uid = data['uid'],
      name = data['name'] ?? '',
      urlAvatar = data['urlAvatar'] ?? '',
      age = data['age'] ?? 0,
      bio = data['bio'] ?? '',
      work = data['work'] ?? '',
      gender = data['gender'] ?? '',
      lookingFor = data['lookingFor'] ?? '',
      from = data['from'] ?? '',
      edu = data['edu'] ?? '',
      live = data['live'] ?? '';

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'urlAvatar': urlAvatar,
        'age': age,
        'bio': bio,
        'work': work,
        'gender': gender,
        'live': live,
        'from': from,
        'edu': edu,
      };
}
