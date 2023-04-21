import 'dart:convert';

class Plan {
  final String name;
  final String code;
  final String interval;
  final int amount;
  Plan({
    required this.name,
    required this.code,
    required this.interval,
    required this.amount,
  });

  Plan copyWith({
    String? name,
    String? code,
    String? interval,
    int? amount,
  }) {
    return Plan(
      name: name ?? this.name,
      code: code ?? this.code,
      interval: interval ?? this.interval,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'interval': interval,
      'amount': amount,
    };
  }

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      name: map['name'] as String,
      code: map['code'] as String,
      interval: map['interval'] as String,
      amount: map['amount'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Plan.fromJson(String source) =>
      Plan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Plan(name: $name, code: $code, interval: $interval, amount: $amount)';
  }

  @override
  bool operator ==(covariant Plan other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.code == code &&
        other.interval == interval &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return name.hashCode ^ code.hashCode ^ interval.hashCode ^ amount.hashCode;
  }
}
