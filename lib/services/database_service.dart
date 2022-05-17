import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Users";
const String MESSAGES_COLLECTION = "Users";

class DatabaseService {
  final FirebaseStorage _db = FirebaseStorage.instance;

  DatabaseService();
}