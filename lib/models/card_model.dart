import 'dart:convert';

class CardModel {
  final String user;
  final String cardType;
  final String bin;
  final String last4;
  final String expMonth;
  final String expYear;
  final String bank;
  final String? accountName;
  CardModel({
    required this.user,
    required this.cardType,
    required this.bin,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.bank,
    required this.accountName,
  });

  CardModel copyWith({
    String? user,
    String? cardType,
    String? bin,
    String? last4,
    String? expMonth,
    String? expYear,
    String? bank,
    String? accountName,
  }) {
    return CardModel(
      user: user ?? this.user,
      cardType: cardType ?? this.cardType,
      bin: bin ?? this.bin,
      last4: last4 ?? this.last4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      bank: bank ?? this.bank,
      accountName: accountName ?? this.accountName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'cardType': cardType,
      'bin': bin,
      'last4': last4,
      'expMonth': expMonth,
      'expYear': expYear,
      'bank': bank,
      'accountName': accountName,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      user: map['user'] as String,
      cardType: map['cardType'] as String,
      bin: map['bin'] as String,
      last4: map['last4'] as String,
      expMonth: map['expMonth'] as String,
      expYear: map['expYear'] as String,
      bank: map['bank'] as String,
      accountName:
          map['accountName'] == null ? '' : map['accountName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) =>
      CardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CardModel(user: $user, cardType: $cardType, bin: $bin, last4: $last4, expMonth: $expMonth, expYear: $expYear, bank: $bank, accountName: $accountName)';
  }

  @override
  bool operator ==(covariant CardModel other) {
    if (identical(this, other)) return true;

    return other.user == user &&
        other.cardType == cardType &&
        other.bin == bin &&
        other.last4 == last4 &&
        other.expMonth == expMonth &&
        other.expYear == expYear &&
        other.bank == bank &&
        other.accountName == accountName;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        cardType.hashCode ^
        bin.hashCode ^
        last4.hashCode ^
        expMonth.hashCode ^
        expYear.hashCode ^
        bank.hashCode ^
        accountName.hashCode;
  }
}
