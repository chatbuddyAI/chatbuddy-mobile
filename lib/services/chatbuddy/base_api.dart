class BaseAPI {
  static String base = "https://api.chatbuddy.ng";

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
