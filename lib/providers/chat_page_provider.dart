import 'dart:async';

import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/media_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  AuthenticationProvider _auth;
  final ScrollController _messagesListViewController;

  final String chatId;
  String? _message;
  List<ChatMessage>? messages;

  String get message => message;

  set message(String value) => _message = value;

  ChatPageProvider(this.chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(chatId).listen((snapshot) {
        List<ChatMessage> _messages = snapshot.docs.map((msg) {
          Map<String, dynamic> messageData = msg.data() as Map<String, dynamic>;
          return ChatMessage.fromJson(messageData);
        }).toList();
        messages = _messages;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messagesListViewController.hasClients) {
            _messagesListViewController
                .jumpTo(_messagesListViewController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print("Error getting messages.");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((event) {
      _db.updateChatData(chatId, {"is_activity": event});
    });
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void goBack() {
    _navigation.goBack();
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage messageToSend = ChatMessage(
        userId: _auth.chatUser.uid,
        type: MessageType.TEXT,
        content: _message!,
        createdAt: DateTime.now().toUtc(),
      );
      _db.addMessageToChat(chatId, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await _media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL =
            await _storage.saveChatImageToStorage(chatId, _auth.chatUser.uid, file);

        ChatMessage messageToSend = ChatMessage(
          userId: _auth.chatUser.uid,
          type: MessageType.IMAGE,
          content: downloadURL!,
          createdAt: DateTime.now().toUtc(),
        );
        _db.addMessageToChat(chatId, messageToSend);
      }
    } catch (e) {
      print("Error sending image message");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(chatId);
  }
}
