class User {
  String id;
  String name;
  String email;
  String token;
  DateTime tokenExpiryDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.tokenExpiryDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['data']['user']['_id'],
      name: json['data']['user']['name'],
      email: json['data']['user']['email'],
      token: json['token'],
      tokenExpiryDate: DateTime.now().add(
        Duration(
          seconds: int.parse(json['expiresIn']),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'tokenExpiryDate': tokenExpiryDate,
    };
  }
}
