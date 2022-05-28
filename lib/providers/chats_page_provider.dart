import 'dart:async';

import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/database_service.dart';
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

    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
