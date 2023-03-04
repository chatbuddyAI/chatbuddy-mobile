import 'dart:convert';

import 'package:flutter/foundation.dart';

class Chat {
  final String id;
  final String user;
  final String type;
  final List<String> members;
  final int maxMembers;
  final String title;
  final String uuid;
  final String createdAt;
  final String updatedAt;

  Chat({
    required this.id,
    required this.user,
    required this.type,
    required this.members,
    required this.maxMembers,
    required this.title,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
  });

  Chat copyWith({
    String? id,
    String? user,
    String? type,
    List<String>? members,
    int? maxMembers,
    String? title,
    String? uuid,
    String? createdAt,
    String? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      user: user ?? this.user,
      type: type ?? this.type,
      members: members ?? this.members,
      maxMembers: maxMembers ?? this.maxMembers,
      title: title ?? this.title,
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'type': type,
      'members': members,
      'maxMembers': maxMembers,
      'title': title,
      'uuid': uuid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      user: map['user'] as String,
      type: map['type'] as String,
      members: List<String>.from((map['members'] as List<String>)),
      maxMembers: map['maxMembers'].toInt() as int,
      title: map['title'] as String,
      uuid: map['uuid'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, user: $user, type: $type, members: $members, maxMembers: $maxMembers, title: $title, uuid: $uuid, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.type == type &&
        listEquals(other.members, members) &&
        other.maxMembers == maxMembers &&
        other.title == title &&
        other.uuid == uuid &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        type.hashCode ^
        members.hashCode ^
        maxMembers.hashCode ^
        title.hashCode ^
        uuid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
