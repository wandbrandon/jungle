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
  List<dynamic> images;
  List<dynamic> lookingFor;
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
    this.images,
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
        lookingFor = data['lookingFor'] ?? [],
        from = data['from'] ?? '',
        edu = data['edu'] ?? '',
        live = data['live'] ?? '',
        images = data['images'] ?? [];

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
        'lookingFor': lookingFor,
        'images': images
      };
}
