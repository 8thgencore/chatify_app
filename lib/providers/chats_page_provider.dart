import 'dart:async';

import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatStream = _db.getChatsForUser(_auth.chatUser.uid).listen((snapshot) async {
        chats = await Future.wait(snapshot.docs.map((doc) async {

          Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;

          // get users in chat
          List<ChatUser> members = [];
          for (var uid in chatData["members"]) {
            DocumentSnapshot userSnapshot = await _db.getUser(uid);
            Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
            userData["uid"] = userSnapshot.id;
            members.add(ChatUser.fromJson(userData));
          }

          // get last message for chat
          List<ChatMessage> messages = [];
          QuerySnapshot chatMessage = await _db.getLastMessageForChat(doc.id);
          if (chatMessage.docs.isNotEmpty) {
            Map<String, dynamic> messageData =
                chatMessage.docs.first.data()! as Map<String, dynamic>;
            ChatMessage message = ChatMessage.fromJson(messageData);
            messages.add(message);
          }

          // return chat instance
          return Chat(
            uid: doc.id,
            currentUserUid: _auth.chatUser.uid,
            activity: chatData["is_activity"],
            group: chatData["is_group"],
            members: members,
            messages: messages,
          );
        }).toList());
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
