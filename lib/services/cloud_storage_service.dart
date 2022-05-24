import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = "users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();
}