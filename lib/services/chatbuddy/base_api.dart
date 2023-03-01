class BaseAPI {
  static String base = "http://127.0.0.1:7576";

  static var api = "$base/api/v1";

  static final String userRoute = "$api/users";
  static final String chatRoute = "$api/chats";
  static final String messageRoute = "$api/messages";

  // more routes
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
  };
}
