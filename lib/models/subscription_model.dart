import 'dart:convert';

class Subscription {
  final String id;
  final String user;
  final String planName;
  final String planCode;
  final String subscriptionCode;
  final int subscriptionAmount;
  final String subscriptionInterval;
  final String status;
  final String? nextPaymentDate;
  final String emailToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  Subscription({
    required this.id,
    required this.user,
    required this.planName,
    required this.planCode,
    required this.subscriptionCode,
    required this.subscriptionAmount,
    required this.subscriptionInterval,
    required this.status,
    required this.nextPaymentDate,
    required this.emailToken,
    required this.createdAt,
    required this.updatedAt,
  });

  Subscription copyWith({
    String? id,
    String? user,
    String? planName,
    String? planCode,
    String? subscriptionCode,
    int? subscriptionAmount,
    String? subscriptionInterval,
    String? status,
    String? nextPaymentDate,
    String? emailToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      user: user ?? this.user,
      planName: planName ?? this.planName,
      planCode: planCode ?? this.planCode,
      subscriptionCode: subscriptionCode ?? this.subscriptionCode,
      subscriptionAmount: subscriptionAmount ?? this.subscriptionAmount,
      subscriptionInterval: subscriptionInterval ?? this.subscriptionInterval,
      status: status ?? this.status,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      emailToken: emailToken ?? this.emailToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'planName': planName,
      'planCode': planCode,
      'subscriptionCode': subscriptionCode,
      'subscriptionAmount': subscriptionAmount,
      'subscriptionInterval': subscriptionInterval,
      'status': status,
      'nextPaymentDate': nextPaymentDate,
      'emailToken': emailToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['_id'] as String,
      user: map['user'] as String,
      planName: map['planName'] as String,
      planCode: map['planCode'] as String,
      subscriptionCode: map['subscriptionCode'] as String,
      subscriptionAmount: map['subscriptionAmount'].toInt() as int,
      subscriptionInterval: map['subscriptionInterval'] as String,
      status: map['status'] as String,
      nextPaymentDate: map['nextPaymentDate'] == null
          ? null
          : map['nextPaymentDate'] as String,
      emailToken: map['emailToken'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Subscription.fromJson(String source) =>
      Subscription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Subscription(_id: $id, user: $user, planName: $planName, planCode: $planCode, subscriptionCode: $subscriptionCode, subscriptionAmount: $subscriptionAmount, subscriptionInterval: $subscriptionInterval, status: $status, nextPaymentDate: $nextPaymentDate, emailToken: $emailToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Subscription other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.planName == planName &&
        other.planCode == planCode &&
        other.subscriptionCode == subscriptionCode &&
        other.subscriptionAmount == subscriptionAmount &&
        other.subscriptionInterval == subscriptionInterval &&
        other.status == status &&
        other.nextPaymentDate == nextPaymentDate &&
        other.emailToken == emailToken &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        planName.hashCode ^
        planCode.hashCode ^
        subscriptionCode.hashCode ^
        subscriptionAmount.hashCode ^
        subscriptionInterval.hashCode ^
        status.hashCode ^
        nextPaymentDate.hashCode ^
        emailToken.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
