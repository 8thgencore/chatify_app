// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      userId: json['user_id'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      content: json['content'] as String,
      createdAt: json['created_at'].toDate(),
      // createdAt: DateTime.parse(json['created_at'] as String));
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) => <String, dynamic>{
      'user_id': instance.userId,
      'type': _$MessageTypeEnumMap[instance.type],
      'content': instance.content,
      'created_at': Timestamp.fromDate(instance.createdAt),
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGE',
  MessageType.UNKNOWN: 'UNKNOWN',
};
