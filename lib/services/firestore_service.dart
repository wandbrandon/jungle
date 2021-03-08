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

  Future<void> createActivity(Activity activity) async {
    CollectionReference activities = db.collection('activities');
    activities
        .doc(activity.aid)
        .set(activity.toJson())
        .then((value) => print("Activity Added"))
        .catchError((error) => print("Failed to add Activity: $error"));
  }

  Future<void> createActivities(List<Activity> activities) {
    final batch = db.batch();
    activities.forEach((element) => batch.set(
        db.collection("activities").doc(element.aid), element.toJson()));
    return batch
        .commit()
        .then((value) => print("Successfully added all activities"))
        .catchError((e) => print('Yikes, could not add activities: $e'));
  }

  Future<List<Activity>> getAllActivities() {
    try {
      CollectionReference activities = db.collection('activities');
      return activities.orderBy('popularity', descending: true).get().then(
          (qs) => qs.docs.map((e) => Activity.fromJson(e.data())).toList());
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
          .limit(75)
          .snapshots()
          .map((event) => event.docs
              .map((e) => Message.fromJson(e.data()))
              .toList()
              .reversed
              .toList());
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

  List<UserModel> helper(List<UserModel> list, UserModel user) {
    list.removeWhere((element) => !(user.lookingFor.contains(element.gender) &&
        user.activities
            .any((activity) => element.activities.contains(activity))));
    return list;
  }

  Stream<List<UserModel>> getUnseenUsers(UserModel user) {
    print('querying unseen users...');
    List<dynamic> likedOrDisliked = user.likes + user.dislikes;
    likedOrDisliked.add(user.uid);
    Query query;

    //query for activities.
    if (user.activities == null || user.activities.isEmpty) {
      print('No activities have been chosen yet!');
      throw Exception('No activities have been chosen yet!');
    } else {
      query = db
          .collection('users')
          .where('uid', whereNotIn: likedOrDisliked)
          .orderBy('uid')
          .limit(50);
      return query.snapshots().map((event) => helper(
          event.docs.map((e) => UserModel.fromJson(e.data())).toList(), user));
    }
  }
}
