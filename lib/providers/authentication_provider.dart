import 'package:chatify_app/models/chat_user.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then((snapshot) {
          Map<String, dynamic> _userData = snapshot.data() as Map<String, dynamic>;
          user = ChatUser.fromJson({
            "uid": _user.uid,
            "name": _userData["name"],
            "email": _userData["email"],
            "last_active": _userData["last_active"],
            "image_url": _userData["image_url"],
          });
          // user = ChatUser(
          //   uid: _user.uid,
          //   name: _userData["name"],
          //   email: _userData["email"],
          //   imageUrl: _userData["image_url"],
          //   lastActive: _userData["last_active"],
          // );
        });
      } else {
        print("Not Authenticated");
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }
}
