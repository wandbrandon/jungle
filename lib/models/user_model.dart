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
  String hometown;
  String work;
  String uni;
  String location;

  User({
    this.hometown,
    this.work,
    this.uid,
    this.uni,
    this.location,
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
      hometown = data['hometown'] ?? '';

  Map<dynamic, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'urlAvatar': urlAvatar,
        'age': age,
        'bio': bio,
        'work': work,
        'gender': gender,
        'hometown': hometown,
      };
}
