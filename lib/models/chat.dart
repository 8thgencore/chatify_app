import 'package:chatify_app/models/chat_message.dart';
import 'package:chatify_app/models/chat_user.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recipients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }) {
    _recipients = members.where((user) => user.uid != currentUserUid).toList();
  }

  List<ChatUser> recipients() => _recipients;

  String title() {
    return !group ? _recipients.first.name : _recipients.map((user) => user.name).join(", ");
  }

  String imageURL() {
    return !group
        ? _recipients.first.imageUrl
        : "https://images.unsplash.com/photo-1494976388531-d1058494cdd8?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170";
  }

  @override
  List<Object?> get props => [uid, currentUserUid, activity, group, members, messages];
}
