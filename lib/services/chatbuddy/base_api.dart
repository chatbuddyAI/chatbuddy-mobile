import 'package:flutter/foundation.dart';

class BaseAPI {
  static const String base = kDebugMode
      ? "https://79ohyswtjb.execute-api.eu-west-2.amazonaws.com/staging" // staging
      : "https://api.chatbuddy.ng"; // prod

  static String api = "$base/api/v1";

  static String userRoute = "$api/users";
  static String chatRoute = "$api/chats";
  static String messageRoute = "$api/messages";
  static String subscriptionRoute = "$api/subscription";
  static String otpRoute = "$api/otp";

  // more routes
  static Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
  };
}
