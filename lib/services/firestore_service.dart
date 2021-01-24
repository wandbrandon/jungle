import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  Future<void> createUser(String uid, models.UserModel user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .set(user.toJson())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> createActivity(models.Activity activity, String type) async {
    CollectionReference activities =
        db.collection('activities').doc(type).collection('activities');
    activities
        .doc(activity.aid)
        .set(activity.toJson())
        .then((value) => print("Activity Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<Map<String, List<models.Activity>>> getAllActivities() async {
    try {
      Map<String, List<models.Activity>> activitiesMap = {};
      CollectionReference activities = db.collection('activities');
      QuerySnapshot activitiesSnapshot = await activities.get();
      await Future.forEach(activitiesSnapshot.docs,
          (QueryDocumentSnapshot element) async {
        QuerySnapshot subActivities = await element.reference
            .collection('activities')
            .orderBy('name')
            .get();
        List<models.Activity> activityModels = [];
        subActivities.docs.forEach((element) {
          activityModels.add(models.Activity.fromJson(element.data()));
        });
        final s = element.id;
        activitiesMap[s[0].toUpperCase() + s.substring(1)] = activityModels;
      });
      print('Successfully got all the lists!');
      return activitiesMap;
    } catch (e) {
      print('There was an error: $e');
    }
    return null;
  }

  Future<void> createActivities(
      List<models.Activity> activities, String type) async {
    await Future.forEach(activities, (element) async {
      await createActivity(element, type);
    })
        .then((value) => print('Activities Added'))
        .catchError((error) => print('Failed to add Activites. $error'));
  }

  Future<void> deleteUser(String uid) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<models.UserModel> getUserStreamByAuth(User authUser) {
    if (authUser == null) return null;
    return db
        .collection('users')
        .doc(authUser.uid)
        .snapshots()
        .map((snapshot) => models.UserModel.fromJson(snapshot.data()));
  }

  Future<DocumentSnapshot> getUserSnapshotByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).get();
  }

  Stream<DocumentSnapshot> getUserSnapshotStreamByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).snapshots();
  }

  Future<void> updateUserByAuth(User authUser, models.UserModel user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(authUser.uid)
        .update(user.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserFieldByAuth(
      User authUser, String identifier, dynamic value) {
    CollectionReference users = db.collection('users');
    return users
        .doc(authUser.uid)
        .update({identifier: value})
        .then((value) => print("User Field Updated"))
        .catchError((error) => print("Failed to update user field: $error"));
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

  Future<List<Map<String, dynamic>>> getUnaffectedUsers(
      models.UserModel user) async {
    List<dynamic> liked = user.likes;
    List<dynamic> disliked = user.dislikes;
    List<dynamic> activities = user.activities;
    QuerySnapshot qs1;
    QuerySnapshot qs2;
    Query firstQuery;
    Query secondQuery;
    if (activities == null || activities.isEmpty) {
      print('No activities chosen!');
      throw "You haven't chosen any activities yet!";
    } else {
      firstQuery = db
          .collection('users')
          //.where('uid', isNotEqualTo: user.uid)
          .where('activities', arrayContainsAny: user.activities)
          .limit(50);
      qs1 = await firstQuery.get().catchError((e) => print(e));
    }
    if (liked == null || disliked == null) {
      secondQuery = db
          .collection('users')
          .where('uid', isNotEqualTo: user.uid)
          .where('gender', whereIn: user.lookingFor)
          .limit(50);
      qs2 = await secondQuery.get().catchError((onError) => print(onError));
      print('no users have been liked or disliked (null list)');
    } else if (liked.isEmpty || disliked.isEmpty) {
      secondQuery = db
          .collection('users')
          .where('uid', isNotEqualTo: user.uid)
          .where('gender', whereIn: user.lookingFor)
          .limit(50);
      qs2 = await secondQuery.get().catchError((onError) => print(onError));
      print('no users have been liked or disliked (empty list)');
    } else {
      List<dynamic> likedOrDisliked = liked + disliked;
      secondQuery = db
          .collection('users')
          .where('uid', whereNotIn: likedOrDisliked, isNotEqualTo: user.uid)
          .where('gender', whereIn: user.lookingFor)
          .limit(50);
      qs2 = await secondQuery.get().catchError((onError) => print(onError));
      print('Queried by liked and disliked');
    }
    List<Map<String, dynamic>> firstQueryList =
        qs1.docs.map((e) => e.data()).toList();
    List<Map<String, dynamic>> secondQueryList =
        qs2.docs.map((e) => e.data()).toList();
    List<Map<String, dynamic>> total = [];

    firstQueryList.forEach((firstElement) {
      final fuid = firstElement['uid'];
      secondQueryList.forEach((element) {
        final suid = element['uid'];
        if (fuid == suid) {
          print('Matches found.');
          total.add(firstElement);
        }
      });
    });

    return total;
  }
}
