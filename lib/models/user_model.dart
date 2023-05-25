import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isSubscribed;
  final bool hasUsedFreeTrial;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isSubscribed,
    required this.hasUsedFreeTrial,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isSubscribed,
    bool? hasUsedFreeTrial,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      hasUsedFreeTrial: hasUsedFreeTrial ?? this.hasUsedFreeTrial,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isSubscribed': isSubscribed,
      'hasUsedFreeTrial': hasUsedFreeTrial,
      'emailVerifiedAt': emailVerifiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? map['id'],
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      isSubscribed: map['isSubscribed'] as bool,
      hasUsedFreeTrial: map['hasUsedFreeTrial'] as bool,
      emailVerifiedAt: map['emailVerifiedAt'] == null
          ? null
          : DateTime.parse(map['emailVerifiedAt']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '{"id": "$id", "name": "$name", "email": "$email", "role": "$role", "isSubscribed": $isSubscribed, "hasUsedFreeTrial": $hasUsedFreeTrial, "emailVerifiedAt": ${emailVerifiedAt == null ? null : "$emailVerifiedAt"}, "createdAt": "$createdAt", "updatedAt": "$updatedAt"}';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.isSubscribed == isSubscribed &&
        other.hasUsedFreeTrial == hasUsedFreeTrial &&
        other.emailVerifiedAt == emailVerifiedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        isSubscribed.hashCode ^
        hasUsedFreeTrial.hashCode ^
        emailVerifiedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
