class BaseAPI {
  static String base = "https://api-chatbuddy.onrender.com";

  static String api = "$base/api/v1";

  static String userRoute = "$api/users";
  static String chatRoute = "$api/chats";
  static String messageRoute = "$api/messages";

  // more routes
  static Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
  };
}
