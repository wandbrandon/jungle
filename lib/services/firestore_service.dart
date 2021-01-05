import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jungle/models/models.dart' as models;

import '../utils.dart';

class FirestoreService {
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  FirestoreService(this.db, this.storage);

  Future<void> createUser(String uid, models.User user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .set(user.toJson())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> deleteUser(String uid) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .set({})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<models.User> getUserStreamByAuth(User authUser) {
    if (authUser == null) return null;
    return db
        .collection('users')
        .doc(authUser.uid)
        .snapshots()
        .map((snapshot) => models.User.fromJson(snapshot.data()));
  }

  Future<DocumentSnapshot> getUserSnapshotByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).get();
  }

  Stream<DocumentSnapshot> getUserSnapshotStreamByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).snapshots();
  }

  Future<void> updateUserByAuth(User authUser, models.User user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(authUser.uid)
        .update(user.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<bool> userExistsByAuth(User authUser) async {
    final snapShot = await db.collection('users').doc(authUser.uid).get();
    if (snapShot == null || !snapShot.exists) {
      return false;
    }
    return true;
  }
}
