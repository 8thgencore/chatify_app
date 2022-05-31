import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref = storage.ref().child("images/users/$uid/profile.${file.extension}");
      UploadTask task = ref.putFile(File(file.path!));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> saveChatImageToStorage(String chatID, String userID, PlatformFile file) async {
    try {
      Reference ref = storage.ref().child(
          "images/users/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}");
      UploadTask task = ref.putFile(File(file.path!));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return null;
  }
}
