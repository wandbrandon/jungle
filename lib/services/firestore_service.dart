import 'dart:io';
import 'package:path/path.dart';
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
        .delete()
        .then((value) => print("User deleted"))
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

  Future<String> uploadFile(File file, String ref) async {
    UploadTask uploadTask =
        storage.ref('$ref/${basename(file.path)}').putFile(file);
    await uploadTask;
    print('File Uploaded');
    String returnURL;
    await storage
        .ref('$ref/${basename(file.path)}')
        .getDownloadURL()
        .then((fileURL) {
      returnURL = fileURL;
      print(returnURL);
    });
    return returnURL;
  }

  Future<void> saveImages(List<File> files, User authUser) async {
    await Future.forEach(files, (file) async {
      String imageURL = await uploadFile(file, authUser.uid);
      db
          .collection('users')
          .doc(authUser.uid)
          .update({
            "images": FieldValue.arrayUnion([imageURL])
          })
          .then((value) => print('Added Images'))
          .catchError((onError) => print("There was a problem $onError"));
    });
  }

  Future<void> removeFiles(String ref) async {
    ListResult files = await storage.ref(ref).listAll();
    await Future.forEach(files.items, (element) async {
      await element.delete();
      print("${element.name} deleted successfully");
    });
  }

  Future<List<QueryDocumentSnapshot>> getUsers(models.User user) async {
    List<dynamic> liked = user.likes;
    List<dynamic> disliked = user.dislikes;
    if (liked == null || disliked == null) {
      Query query = db
          .collection('users')
          .where('uid', isNotEqualTo: user.uid)
          .where('gender', whereIn: user.lookingFor)
          .limit(50);
      QuerySnapshot qs =
          await query.get().catchError((onError) => print(onError));
      print('no users have been liked or disliked (null list)');
      return qs.docs;
    } else if (liked.isEmpty || disliked.isEmpty) {
      Query query = db
          .collection('users')
          .where('uid', isNotEqualTo: user.uid)
          .where('gender', whereIn: user.lookingFor)
          .limit(50);
      QuerySnapshot qs =
          await query.get().catchError((onError) => print(onError));
      print('no users have been liked or disliked (empty list)');
      return qs.docs;
    } else {
      List<dynamic> likedOrDisliked = liked + disliked;
      Query query = db
          .collection('users')
          .where('uid', whereNotIn: likedOrDisliked, isNotEqualTo: user.uid)
          .where('gender', whereIn: user.lookingFor)
          .limit(50);
      QuerySnapshot qs =
          await query.get().catchError((onError) => print(onError));
      print('Queried by liked and disliked');
      return qs.docs;
    }
  }
}
