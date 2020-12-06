import 'message_model.dart';

class User {
  final int id;
  final int age;
  final String name;
  final String imageUrl;
  final String location;
  final String bio;
  final String work;
  final String uni;
  final String hometown;
  final List<Message> messages;

  User({
    this.messages,
    this.bio,
    this.age,
    this.work,
    this.uni,
    this.hometown,
    this.id,
    this.name,
    this.imageUrl,
    this.location,
  });
}
