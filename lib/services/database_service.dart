import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(String uid, String email, String name, String imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set({
        "name": name,
        "email": email,
        "image_url": imageURL,
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db.collection(CHAT_COLLECTION).where('members', arrayContains: uid).snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("created_at", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("created_at", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatId, ChatMessage message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatId)
          .collection(MESSAGES_COLLECTION)
          .add(message.toJson());
    } catch (e) {
      print("addMessageToChat: $e");
    }
  }

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).update(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }
}
