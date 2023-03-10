import 'package:chat_buddy/models/user_model.dart';

class AuthModel {
  User user;
  String? token;
  DateTime? tokenExpiryDate;

  AuthModel({
    required this.user,
    required this.token,
    required this.tokenExpiryDate,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        user: User.fromMap(json['user']),
        token: json['token'],
        tokenExpiryDate: DateTime.fromMillisecondsSinceEpoch(
          json['expiresIn'] * 1000,
        ),
      );

  // factory User.parse(Map<String, dynamic> json) => User(
  //     id: json['id'],
  //     name: json['name'],
  //     email: json['email'],
  //     token: json['token'],
  //     tokenExpiryDate: DateTime.parse(json['tokenExpiryDate']));

  Map<String, dynamic> toJson() => {
        'user': user,
        'token': token,
        'tokenExpiryDate': tokenExpiryDate?.toIso8601String(),
      };
}
