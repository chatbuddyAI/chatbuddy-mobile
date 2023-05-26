// user_provider.dart

import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/services/chatbuddy/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late String? _userId;
  late String? _token;
  late User? _user;
  bool _isAuthenticated = false;
  late bool? _isSubscribed;
  late DateTime? _expiryDate;
  Timer? _authTimer;

  User? get user => _user;
  String? get userId => _userId;
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get userHasVerifiedEmail {
    return _user!.emailVerifiedAt != null;
  }

  bool get isAuthenticated => _isAuthenticated;
  bool? get isSubscribed => _isSubscribed;

  set SetIsSubscribed(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password,
      String passwordConfirm) async {
    try {
      final auth =
          await AuthService.register(name, email, password, passwordConfirm);
      final token = auth.token;
      final userId = auth.user.id;

      _user = auth.user;
      _userId = userId;
      _token = token;
      _isSubscribed = auth.user.isSubscribed;
      _isAuthenticated = true;
      _expiryDate = auth.tokenExpiryDate;
      print(_user.toString());

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode({
          'user': _user.toString(),
          'userId': userId,
          'token': token,
          'expiryDate': _expiryDate?.toIso8601String(),
          'isSubscribed': _isSubscribed
        }),
      );

      // The autoLogout function starts a timer that runs till your token expires
      _autoLogout();

      if (!userHasVerifiedEmail) {
        await sendOtp();
      }
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

      _user = auth.user;
      _userId = userId;
      _token = token;
      _isSubscribed = auth.user.isSubscribed;
      _isAuthenticated = true;
      _expiryDate = auth.tokenExpiryDate;
      print(_user.toString());

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode({
          'user': _user.toString(),
          'userId': userId,
          'token': token,
          'expiryDate': _expiryDate?.toIso8601String(),
          'isSubscribed': _isSubscribed
        }),
      );

      // The autoLogout function starts a timer that runs till your token expires
      _autoLogout();

      if (!userHasVerifiedEmail) {
        await sendOtp();
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> resetPassword(
    String otp,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    try {
      final auth = await AuthService.resetPassword(
          otp, email, password, passwordConfirm);
      final token = auth.token;
      final userId = auth.user.id;

      _user = auth.user;
      _userId = userId;
      _token = token;
      _isSubscribed = auth.user.isSubscribed;
      _isAuthenticated = true;
      _expiryDate = auth.tokenExpiryDate;
      print(_user.toString());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode({
          'user': _user.toString(),
          'userId': userId,
          'token': token,
          'expiryDate': _expiryDate?.toIso8601String(),
          'isSubscribed': _isSubscribed
        }),
      );

      // The autoLogout function starts a timer that runs till your token expires
      _autoLogout();

      if (!userHasVerifiedEmail) {
        await sendOtp();
      }

      notifyListeners();

      return 'Password reset complete. Signing in you in now...';
    } catch (error) {
      rethrow;
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      final msg = await AuthService.forgotPassword(email);

      return msg;
    } catch (e) {
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
    final user = extractedUserData['user'];
    final userId = extractedUserData['userId'] as String;
    final token = extractedUserData['token'] as String;
    final isSubscribed = extractedUserData['isSubscribed'] as bool;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    Map<String, dynamic> userMap = jsonDecode(user);
    _user = User.fromMap(userMap);
    _token = token;
    _isSubscribed = isSubscribed;
    _isAuthenticated = true;
    _userId = userId;
    _expiryDate = expiryDate;

    if (!userHasVerifiedEmail) {
      await sendOtp();
    }

    notifyListeners();

    return true;
  }

  Future<String> sendOtp() async {
    try {
      final msg = await AuthService.sendOtp(_token!);
      return msg;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verifyOtp(
    String otp,
  ) async {
    try {
      final user = await AuthService.verifyOtp(_token!, otp);

      _user = user;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode({
          'user': _user.toString(),
          'userId': user.id,
          'token': _token,
          'expiryDate': _expiryDate?.toIso8601String(),
          'isSubscribed': _isSubscribed
        }),
      );

      notifyListeners();

      return 'Email verified successfully';
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _isAuthenticated = false;
    _isSubscribed = null;
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
