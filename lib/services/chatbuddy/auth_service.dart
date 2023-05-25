import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/Auth_model.dart';
import 'package:chat_buddy/models/user_model.dart';
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
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('LOGIN');
    print(responseData);

    return AuthModel.fromJson(responseData['data']);
  }

  static Future<String> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('${BaseAPI.userRoute}/forgotPassword'),
      headers: BaseAPI.headers,
      body: json.encode({
        'email': email,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return responseData['message'];
  }

  static Future<AuthModel> resetPassword(
    String otp,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    final response = await http.patch(
      Uri.parse('${BaseAPI.userRoute}/resetPassword'),
      headers: BaseAPI.headers,
      body: json.encode({
        'otp': otp,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return AuthModel.fromJson(responseData['data']);
  }

  static Future<User> getMe(String token) async {
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse('${BaseAPI.userRoute}/me'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return User.fromMap(responseData['data']);
  }

  static Future<String> sendOtp(String token) async {
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('${BaseAPI.otpRoute}/send'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return responseData['message'];
  }

  static Future<User> verifyOtp(String token, String otp) async {
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('${BaseAPI.otpRoute}/verify'),
      headers: BaseAPI.headers,
      body: json.encode({
        'otp': otp,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return User.fromMap(responseData['data']);
  }
}
