import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jungle/models/models.dart' as models;

import '../utils.dart';

class FirestoreService {
  final FirebaseFirestore db;
  FirestoreService(this.db);

  Future<void> createUser(String uid) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .set({})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<models.User> getUserByAuth(User authUser) {
    if (authUser == null) return null;
    return db
        .collection('users')
        .doc(authUser.uid)
        .snapshots()
        .map((snapshot) => models.User.fromMap(snapshot.data()));
  }

  Stream<DocumentSnapshot> getUserSnapshotByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).snapshots();
  }

  Future<void> updateUserByUid(String uid, models.User user) {
  CollectionReference users = db.collection('users');
  return users
    .doc(uid)
    .update(user.fromMap)
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}
}
