import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;
  final String urlAvatar;
  final String bio;
  final int age;
  final String hometown;
  final String work;
  final String uni;
  final String location;
  final DateTime lastMessageTime;

  const User({
    this.hometown,
    this.work,
    this.idUser,
    this.uni,
    this.location,
    @required this.name,
    @required this.urlAvatar,
    @required this.lastMessageTime,
    @required this.bio,
    @required this.age,
  });

  User copyWith({
    String idUser,
    String name,
    String urlAvatar,
    String lastMessageTime,
    int age,
    String bio,
    String work,
    String hometown
  }) =>
      User(
          idUser: idUser ?? this.idUser,
          name: name ?? this.name,
          urlAvatar: urlAvatar ?? this.urlAvatar,
          lastMessageTime: lastMessageTime ?? this.lastMessageTime,
          age: age ?? this.age,
          bio: bio ?? this.bio, 
          work: work ?? this.work,
          hometown: hometown ?? this.hometown);

  static User fromJson(Map<String, dynamic> json) => User(
      idUser: json['idUser'],
      name: json['name'],
      urlAvatar: json['urlAvatar'],
      lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      age: json['age'],
      bio: json['bio'],
      work: json['work'],
      hometown: json['hometown']
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
        'age': age,
        'bio': bio,
        'work': work,
        'hometown': hometown,
      };
}
