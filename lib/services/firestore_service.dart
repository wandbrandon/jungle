import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils.dart';

class FirestoreService {
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  FirestoreService(this.db, this.storage);

  Future<void> createUser(String uid, UserModel user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .set(user.toJson())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> createActivity(Activity activity, String type) async {
    CollectionReference activities =
        db.collection('activities').doc(type).collection('activities');
    activities
        .doc(activity.aid)
        .set(activity.toJson())
        .then((value) => print("Activity Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> createActivities(List<Activity> activities, String type) async {
    await Future.forEach(activities, (element) async {
      await createActivity(element, type);
    })
        .then((value) => print('Activities Added'))
        .catchError((error) => print('Failed to add Activites. $error'));
  }

  Future<Map<String, List<Activity>>> getAllActivities() async {
    try {
      Map<String, List<Activity>> activitiesMap = {};
      CollectionReference activities = db.collection('activities');
      QuerySnapshot activitiesSnapshot = await activities.get();
      await Future.forEach(activitiesSnapshot.docs,
          (QueryDocumentSnapshot element) async {
        QuerySnapshot subActivities = await element.reference
            .collection('activities')
            .orderBy('name')
            .get();
        List<Activity> activityModels = [];
        subActivities.docs.forEach((element) {
          activityModels.add(Activity.fromJson(element.data()));
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

  Future<void> deleteUser(String uid) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<UserModel> getUserStreamByAuth(User authUser) {
    if (authUser == null) return null;
    return db
        .collection('users')
        .doc(authUser.uid)
        .snapshots()
        .map((snapshot) => UserModel.fromJson(snapshot.data()));
  }

  Future<DocumentSnapshot> getUserSnapshotByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).get();
  }

  Stream<DocumentSnapshot> getUserSnapshotStreamByAuth(User authUser) {
    if (authUser == null) return null;
    return db.collection('users').doc(authUser.uid).snapshots();
  }

  Future<void> updateUserByAuth(User authUser, UserModel user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(authUser.uid)
        .update(user.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserByUID(String uid, UserModel user) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
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

  Future<void> updateUserFieldByUID(
      String uid, String identifier, dynamic value) {
    CollectionReference users = db.collection('users');
    return users
        .doc(uid)
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

  Future<QuerySnapshot> getChatRoomsByUID(String uid) {
    print('querying chat rooms...');
    CollectionReference chats = db.collection('chats');
    return chats
        .where('UIDs', arrayContains: uid)
        .orderBy('last_updated')
        .get();
    // .then((value) => print('Successfully got all relevant chat rooms.'))
    // .catchError((onError) => print('Failed to get chat rooms: $onError'));
  }

  Future<void> createChatRoom(UserModel user1, UserModel user2) {
    String chatid = user1.uid.compareTo(user1.uid) > 0
        ? user1.uid + user2.uid
        : user2.uid + user1.uid;
    CollectionReference chats = db.collection('chats');
    return chats
        .doc(chatid)
        .set({
          'UIDs': [user1.uid, user2.uid],
          'users': [user1.toJson(), user2.toJson()],
          'dateSet': false,
          'last_updated': DateTime.now()
        })
        .then((value) => print("ChatRoom created"))
        .catchError((error) => print("Failed to create chat room: $error"));
  }

  Stream<QuerySnapshot> getMessagesStream(String uid1, String uid2) {
    String chatid = uid1.compareTo(uid2) > 0 ? uid1 + uid2 : uid2 + uid2;
    CollectionReference chats = db.collection('chats');
    return chats
        .doc(chatid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<void> sendMessage(String fromUID, String uid2, Message message) {
    String chatid = fromUID.compareTo(uid2) > 0 ? fromUID + uid2 : uid2 + uid2;
    CollectionReference chats = db.collection('chats');
    chats
        .doc(chatid)
        .update({'last_updated': DateTime.now()})
        .then((value) => print('Chat Room updated.'))
        .catchError((error) => print('Failed to update Chat Room'));
    return chats
        .doc(chatid)
        .collection('messages')
        .add(message.toJson())
        .then((value) => print('Message sent'))
        .catchError((error) => print('Failed to send message'));
  }

  Future<List<Map<String, dynamic>>> getUnaffectedUsers(UserModel user) async {
    print('querying...');
    List<dynamic> likedOrDisliked = user.likes + user.dislikes;
    likedOrDisliked.add(user.uid);
    QuerySnapshot qs1;
    Query query;
    try {
      //query for activities.
      if (user.activities == null || user.activities.isEmpty) {
        print('No activities have been chosen yet!');
        throw "You haven't chosen any activities yet!";
      } else {
        query = db
            .collection('users')
            .where('uid', whereNotIn: likedOrDisliked)
            .orderBy('uid')
            .limit(50);
        qs1 = await query.get();
      }

      if (qs1.size == 0) {
        print('done, found nothing');
        return [];
      }

      List<Map<String, dynamic>> firstQueryList = qs1.docs
          .map((e) => e.data())
          .toList()
          .where((item) =>
              user.lookingFor.contains(item['gender']) &&
              user.activities
                  .where((element) => item['activities']?.contains(element))
                  .toList()
                  .isNotEmpty)
          .toList();

      if (qs1.docs.length < 50) {
        print('done, but it is trickling down');
        return firstQueryList;
      }

      while (firstQueryList.isEmpty && qs1.docs.isNotEmpty) {
        query = db
            .collection('users')
            .where('uid', whereNotIn: likedOrDisliked)
            .orderBy('uid')
            .startAfterDocument(qs1.docs.last)
            .limit(50);
        qs1 = await query.get();
        firstQueryList = qs1.docs
            .map((e) => e.data())
            .toList()
            .where((item) =>
                !user.lookingFor.contains(item['gender']) ||
                user.activities
                    .where((element) => item['activities'].contains(element))
                    .toList()
                    .isNotEmpty)
            .toList();
      }
      print('done, went through the loop!');
      return firstQueryList;
    } on FirebaseException catch (e) {
      print(e);
      throw e;
    }
  }
}
