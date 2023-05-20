import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/Auth_model.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<AuthModel> register(String name, String email, String password,
      String passwordConfirm) async {
    // Send API request
    final response = await http.post(
      Uri.parse('${BaseAPI.userRoute}/register'),
      headers: BaseAPI.headers,
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

    print('REGISTER');
    print(responseData);

    return AuthModel.fromJson(responseData['data']);
  }

  static Future<AuthModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${BaseAPI.userRoute}/login'),
      headers: BaseAPI.headers,
      body: json.encode({'email': email, 'password': password}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('LOGIN');
    print(responseData);

    return AuthModel.fromJson(responseData['data']);
  }
}
