import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_user.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ChatUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActive,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserToJson(this);

  @override
  List<Object?> get props => [uid, name, email, imageUrl, lastActive];

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
