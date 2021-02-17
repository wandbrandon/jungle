import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jungle/models/models.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore db;
  final FirebaseStorage storage;
  final FirebaseMessaging fbmessaging;

  FirestoreService(this.db, this.storage, this.fbmessaging);

  Future<void> createUser(String uid, UserModel user) async {
    CollectionReference users = db.collection('users');
    final usermap = user.toJson();

    return users
        .doc(uid)
        .set(usermap)
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

  Future<void> updateUserByAuth(User authUser, UserModel user) async {
    CollectionReference users = db.collection('users');
    CollectionReference chats = db.collection('chats');
    QuerySnapshot qs =
        await chats.where('UIDs', arrayContains: authUser.uid).get();
    if (qs != null) {
      if (qs.size != 0) {
        Future.forEach(qs.docs, (QueryDocumentSnapshot element) async {
          element.reference.update({'users.${authUser.uid}': user.toJson()});
        });
      }
    }
    return users
        .doc(authUser.uid)
        .update(user.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserByUID(String uid, UserModel user) async {
    CollectionReference users = db.collection('users');
    CollectionReference chats = db.collection('chats');
    QuerySnapshot qs = await chats.where('UIDs', arrayContains: uid).get();
    if (qs != null) {
      if (qs.size != 0) {
        Future.forEach(qs.docs, (QueryDocumentSnapshot element) async {
          element.reference.update({'users.$uid': user.toJson()});
        });
      }
    }
    return users
        .doc(uid)
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

  Stream<QuerySnapshot> getChatRoomsByUID(String uid) {
    print('querying chat rooms for $uid...');
    CollectionReference chats = db.collection('chats');
    return chats
        .where('UIDs', arrayContains: uid)
        .orderBy('last_updated')
        .snapshots();
  }

  Future<void> createChatRoom(UserModel user1, UserModel user2) {
    String chatid = user1.uid.compareTo(user1.uid) > 0
        ? user1.uid + user2.uid
        : user2.uid + user1.uid;
    CollectionReference chats = db.collection('chats');
    return chats
        .doc(chatid)
        .set({
          'chatID': chatid,
          'UIDs': [user1.uid, user2.uid],
          'users': {
            '${user1.uid}': user1.toJson(),
            '${user2.uid}': user2.toJson()
          },
          'dateUsersAccepted': {'${user1.uid}': false, '${user2.uid}': false},
          'created': DateTime.now(),
          'last_updated': DateTime.now(),
          'lastMessage': "",
          'lastMessageSentBy': "",
          'lastMessageRead': false
        })
        .then((value) => print("ChatRoom created"))
        .catchError((error) => print("Failed to create chat room: $error"));
  }

  Future<void> updateChatRoom(String chatid, String field, dynamic data) {
    CollectionReference chats = db.collection('chats');
    return chats
        .doc(chatid)
        .update({field: data})
        .then((value) => print("ChatRoom updated"))
        .catchError((error) => print("Failed to update chat room: $error"));
  }

  Future<void> updateChatRoomMessage(String chatid, Message message) {
    CollectionReference chats = db.collection('chats');
    return chats
        .doc(chatid)
        .update({
          'lastMessage': message.message,
          'lastMessageSentBy': message.fromUID,
          'lastMessageRead': false
        })
        .then((value) => print("ChatRoom updated"))
        .catchError((error) => print("Failed to update chat room: $error"));
  }

  Future<void> updateChatRoomDateSet(String chatid, bool date, UserModel from) {
    CollectionReference chats = db.collection('chats');
    if (chatid.indexOf(from.uid) == 0) {
      return chats
          .doc(chatid)
          .update({
            'dateUser1Accepted': true,
          })
          .then((value) => print("ChatRoom updated"))
          .catchError((error) => print("Failed to update chat room: $error"));
    } else if (chatid.indexOf(from.uid) > 0) {
      return chats
          .doc(chatid)
          .update({
            'dateUser2Accepted': true,
          })
          .then((value) => print("ChatRoom updated"))
          .catchError((error) => print("Failed to update chat room: $error"));
    } else {
      throw 'Uh-oh that should not have happened.';
    }
  }

  Stream<List<Message>> getMessagesStream(String chatid) {
    print('getting messages for $chatid...');
    CollectionReference chats = db.collection('chats');
    try {
      return chats
          .doc(chatid)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Message.fromJson(e.data())).toList());
    } on Exception catch (e) {
      print(e);
      return Stream.error(e.toString());
    }
  }

  Future<void> sendMessage(String chatid, Message message) {
    CollectionReference chats = db.collection('chats');
    chats
        .doc(chatid)
        .update({
          'lastMessage': message.message,
          'lastMessageSentBy': message.fromUID,
          'lastMessageRead': false,
          'last_updated': DateTime.now(),
        })
        .then((value) => print('Chat Room updated.'))
        .catchError((error) => print('Failed to update Chat Room'));
    return chats
        .doc(chatid)
        .collection('messages')
        .add(message.toJson())
        .then((value) => print('Message sent'))
        .catchError((error) => print('Failed to send message'));
  }

  Future<void> unmatch(String chatid) {
    CollectionReference chats = db.collection('chats');
    return chats
        .doc(chatid)
        .delete()
        .then((value) => print('Successfully deleted Chat Room'))
        .catchError((e) => print('Could not delete Chat Room: $e'));
  }

  Stream<QuerySnapshot> getUnaffectedUsers(UserModel user) {
    print('querying...');
    List<dynamic> likedOrDisliked = user.likes + user.dislikes;
    likedOrDisliked.add(user.uid);
    Query query;
    //query for activities.
    if (user.activities == null || user.activities.isEmpty) {
      print('No activities have been chosen yet!');
      return Stream.error('No activities have been chosen yet!');
    } else {
      query = db
          .collection('users')
          .where('uid', whereNotIn: likedOrDisliked)
          .orderBy('uid')
          .limit(50);
      return query.snapshots();
    }
  }
}
