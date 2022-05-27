// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      userId: json['user_id'] as String,
      msgType: $enumDecode(_$MessageTypeEnumMap, json['msg_type']),
      content: json['content'] as String,
      createdAt: json['created_at'].toDate(),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) => <String, dynamic>{
      'user_id': instance.userId,
      'msg_type': _$MessageTypeEnumMap[instance.msgType],
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGE',
  MessageType.UNKNOWN: 'UNKNOWN',
};
