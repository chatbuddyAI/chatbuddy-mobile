import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/chat.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';
import 'package:http/http.dart' as http;

import 'package:chat_buddy/models/user_model.dart';

class ChatService {
  static Future<Chat> getUserChats(String token) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse(BaseAPI.chatRoute),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('ALL CHATS: ' + responseData);

    return Chat.fromJson(responseData['data']);
  }

  static Future<Chat> getUserChat(String token, String uuid) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse('${BaseAPI.chatRoute}/$uuid'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('A CHAT: ' + responseData);

    return Chat.fromJson(responseData['data']);
  }
}
