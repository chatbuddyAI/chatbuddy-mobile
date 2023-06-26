import 'dart:convert';

import 'package:chat_buddy/models/chat_model.dart';

class Message {
  final String id;
  final String sender;
  final String message;
  final bool isBotReply;
  final dynamic chat;
  final DateTime createdAt;
  final DateTime updatedAt;
  Message({
    required this.id,
    required this.sender,
    required this.message,
    required this.isBotReply,
    required this.chat,
    required this.createdAt,
    required this.updatedAt,
  });

  Message copyWith({
    String? id,
    String? sender,
    String? message,
    bool? isBotReply,
    dynamic chat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      isBotReply: isBotReply ?? this.isBotReply,
      chat: chat ?? this.chat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sender': sender,
      'message': message,
      'isBotReply': isBotReply,
      'chat': chat,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] as String,
      sender: map['sender'] as String,
      message: map['message'] as String,
      isBotReply: map['isBotReply'] as bool,
      chat: map['chat'] is Map ? Chat.fromMap(map['chat']) : map['chat'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, sender: $sender, message: $message, isBotReply: $isBotReply, chat: $chat, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sender == sender &&
        other.message == message &&
        other.isBotReply == isBotReply &&
        other.chat == chat &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        message.hashCode ^
        isBotReply.hashCode ^
        chat.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
