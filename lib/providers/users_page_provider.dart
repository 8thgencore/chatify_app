import 'package:chatify_app/models/chat.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/pages/chat_page.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _database;
  late NavigationService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers => _selectedUsers;

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _database.getUsers(name: name).then((snapshot) {
        users = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data["uid"] = doc.id;
          return ChatUser.fromJson(data);
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      print("Error getting users.");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      //Create Chat
      List<String> membersIds = _selectedUsers.map((user) => user.uid).toList();
      membersIds.add(_auth.chatUser.uid);
      bool isGroup = _selectedUsers.length > 1;
      DocumentReference? doc = await _database.createChat(
        {
          "is_group": isGroup,
          "is_activity": false,
          "members": membersIds,
        },
      );
      //Navigate To Chat Page
      List<ChatUser> members = [];
      for (var uid in membersIds) {
        DocumentSnapshot userSnapshot = await _database.getUser(uid);
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = userSnapshot.id;
        members.add(ChatUser.fromJson(userData));
      }
      ChatPage chatPage = ChatPage(
        chat: Chat(
          uid: doc!.id,
          currentUserUid: _auth.chatUser.uid,
          members: members,
          messages: [],
          activity: false,
          group: isGroup,
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(chatPage);
    } catch (e) {
      if (kDebugMode) {
        print("Error creating chat.");
      }
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
