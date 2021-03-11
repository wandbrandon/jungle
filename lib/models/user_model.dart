import 'models.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class UserModel {
  final String uid;
  //User profile information
  //unchangeable
  String name;
  DateTime birthday;
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
  List<dynamic> activities;
  String startAtUID;

  UserModel(
      {this.work,
      this.uid,
      this.edu,
      this.gender,
      this.lookingFor,
      this.images,
      this.name,
      this.bio,
      this.birthday,
      this.likes,
      this.dislikes,
      this.activities,
      this.startAtUID});

  UserModel.fromJson(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        birthday = data['birthday'] == null
            ? DateTime.now()
            : data['birthday'].toDate() ?? 0,
        bio = data['bio'] ?? '',
        work = data['work'] ?? '',
        gender = data['gender'] ?? '',
        lookingFor = data['lookingFor'] ?? [],
        edu = data['edu'] ?? '',
        images = data['images'] ?? [],
        likes = data['likes'] ?? [],
        dislikes = data['dislikes'] ?? [],
        activities = data['activities'] ?? [],
        startAtUID = data['startAtUID'] ?? '';

  Map<String, dynamic> toJson() => {
        'uid': uid ?? '',
        'name': name ?? '',
        'birthday': birthday ?? '',
        'bio': bio ?? '',
        'work': work ?? '',
        'gender': gender ?? '',
        'edu': edu ?? '',
        'lookingFor': lookingFor ?? [],
        'images': images ?? [],
        'likes': likes ?? [],
        'dislikes': dislikes ?? [],
        'activities': activities ?? [],
        'startAtUID': startAtUID ?? '',
      };
}
