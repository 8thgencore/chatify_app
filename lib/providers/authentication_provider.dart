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

  late ChatUser chat_user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _databaseService.updateUserLastSeenTime(user.uid);
        _databaseService.getUser(user.uid).then((snapshot) {
          Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
          chat_user = ChatUser.fromJson({
            "uid": user.uid,
            "name": userData["name"],
            "email": userData["email"],
            "last_active": userData["last_active"],
            "image_url": userData["image_url"],
          });
          _navigationService.removeAndNavigateToRoute('/home');
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(String email, String password) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
