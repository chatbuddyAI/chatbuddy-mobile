class User {
  String id;
  String name;
  String email;
  String? token;
  DateTime? tokenExpiryDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.tokenExpiryDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['data']['user']['_id'],
        name: json['data']['user']['name'],
        email: json['data']['user']['email'],
        token: json['data']['token'],
        tokenExpiryDate: DateTime.fromMillisecondsSinceEpoch(
          json['data']['expiresIn'] * 1000,
        ),
      );

  factory User.parse(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      tokenExpiryDate: DateTime.parse(json['tokenExpiryDate']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token,
        'tokenExpiryDate': tokenExpiryDate?.toIso8601String(),
      };
}
