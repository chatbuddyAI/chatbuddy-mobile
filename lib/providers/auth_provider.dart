// user_provider.dart

import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/services/chatbuddy/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late String? _userId;
  late User? _user;
  late String? _token;
  bool _isAuthenticated = false;
  late DateTime? _expiryDate;
  Timer? _authTimer;

  String? get userId => _userId;
  User? get user => _user;
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> register(String name, String email, String password,
      String passwordConfirm) async {
    try {
      final auth =
          await AuthService.register(name, email, password, passwordConfirm);
      final token = auth.token;
      final userId = auth.user.id;

      _userId = userId;
      _user = auth.user;
      _token = token;
      _isAuthenticated = true;
      _expiryDate = auth.tokenExpiryDate;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode({
          'userId': userId,
          'user': auth.user.toJson(),
          'token': token,
          'expiryDate': _expiryDate?.toIso8601String(),
        }),
      );

      // The autoLogout function starts a timer that runs till your token expires
      _autoLogout();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final auth = await AuthService.login(email, password);
      final token = auth.token;
      final userId = auth.user.id;

      _userId = userId;
      _user = user;
      _token = token;
      _isAuthenticated = true;
      _expiryDate = auth.tokenExpiryDate;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode({
          'userId': userId,
          'user': auth.user.toJson(),
          'token': token,
          'expiryDate': _expiryDate?.toIso8601String(),
        }),
      );

      // The autoLogout function starts a timer that runs till your token expires
      _autoLogout();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final token = extractedUserData['token'] as String;
    final user = extractedUserData['user'];
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    print(user);
    _token = token;
    _isAuthenticated = true;
    _userId = user['id'];
    _user = User.fromMap(user);
    _expiryDate = DateTime.parse(user['tokenExpiryDate']);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _userId = null;
    _isAuthenticated = false;
    _expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
