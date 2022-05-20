// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      imageUrl: json['image_url'] as String,
      lastActive: DateTime.parse(json['last_active'] as String),
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'image_url': instance.imageUrl,
      'last_active': instance.lastActive.toIso8601String(),
    };
