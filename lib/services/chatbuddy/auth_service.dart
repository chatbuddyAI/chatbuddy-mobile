import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';
import 'package:http/http.dart' as http;

import 'package:chat_buddy/models/user_model.dart';

class AuthService extends BaseAPI {
  static Future<User> register(String name, String email, String password,
      String passwordConfirm) async {
    // Send API request
    final response = await http.post(
      super.userRoute + '/register',
      headers: super.headers,
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return User.fromJson(responseData);
  }

  static Future<User> login(String email, String password) async {
    final response = await http.post(
      super.userRoute + '/login',
      headers: super.headers,
      body: json.encode({'email': email, 'password': password}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return User.fromJson(responseData);
  }
}
