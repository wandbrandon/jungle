import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String uid;
  //User profile information
  //unchangeable
  String name;
  int age;
  //changeable
  String bio;
  String gender;
  List<dynamic> images;
  List<dynamic> lookingFor;
  String from;
  String work;
  String edu;
  String live;
  //matching values
  List<dynamic> likes;
  List<dynamic> dislikes;
  List<dynamic> matches;
  List<dynamic> foods;

  User(
      {this.from,
      this.work,
      this.uid,
      this.edu,
      this.live,
      this.gender,
      this.lookingFor,
      this.images,
      this.name,
      this.bio,
      this.age,
      this.likes,
      this.dislikes,
      this.matches,
      this.foods});

  User.fromJson(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        age = data['age'] ?? 0,
        bio = data['bio'] ?? '',
        work = data['work'] ?? '',
        gender = data['gender'] ?? '',
        lookingFor = data['lookingFor'] ?? [],
        from = data['from'] ?? '',
        edu = data['edu'] ?? '',
        live = data['live'] ?? '',
        images = data['images'] ?? [],
        likes = data['likes'] ?? [],
        dislikes = data['dislikes'] ?? [],
        matches = data['matches'] ?? [],
        foods = data['foods'] ?? [];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'age': age,
        'bio': bio,
        'work': work,
        'gender': gender,
        'live': live,
        'from': from,
        'edu': edu,
        'lookingFor': lookingFor,
        'images': images,
        'likes': likes,
        'dislikes': dislikes,
        'matches': matches,
        'foods': foods,
      };
}
