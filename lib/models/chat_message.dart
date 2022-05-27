import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

enum MessageType {
  TEXT,
  IMAGE,
  UNKNOWN,
}

@JsonSerializable(fieldRename: FieldRename.kebab)
class ChatMessage extends Equatable {
  final String userId;
  final MessageType msgType;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.userId,
    required this.msgType,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  @override
  List<Object?> get props => [userId, msgType, content, createdAt];
}
