import 'models.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class UserModel {
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
  String work;
  String edu;
  //matching values
  List<dynamic> likes;
  List<dynamic> dislikes;
  List<dynamic> matches;
  List<dynamic> activities;

  UserModel(
      {this.work,
      this.uid,
      this.edu,
      this.gender,
      this.lookingFor,
      this.images,
      this.name,
      this.bio,
      this.age,
      this.likes,
      this.dislikes,
      this.matches,
      this.activities});

  UserModel.fromJson(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        age = data['age'] ?? 0,
        bio = data['bio'] ?? '',
        work = data['work'] ?? '',
        gender = data['gender'] ?? '',
        lookingFor = data['lookingFor'] ?? [],
        edu = data['edu'] ?? '',
        images = data['images'] ?? [],
        likes = data['likes'] ?? [],
        dislikes = data['dislikes'] ?? [],
        matches = data['matches'] ?? [],
        activities = data['activities'] ?? [];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'age': age,
        'bio': bio,
        'work': work,
        'gender': gender,
        'edu': edu,
        'lookingFor': lookingFor,
        'images': images,
        'likes': likes,
        'dislikes': dislikes,
        'matches': matches,
        'activities': activities,
      };
}
