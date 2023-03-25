import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';
import 'package:http/http.dart' as http;

import 'package:chat_buddy/models/user_model.dart';

class ChatService {
  static Future<List<Chat>> getUserChats(String token) async {
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

    final List<Chat> chats = [];
    for (var chatData in responseData['data'] as List<dynamic>) {
      final chat = Chat.fromMap(chatData);

      // print(chat);

      chats.add(chat);
    }

    print('ALL CHATS');
    print(responseData['data']);

    return chats;
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

    print('A CHAT');
    print(responseData);

    return Chat.fromMap(responseData['data']);
  }

  static Future<Chat> updateUserChat(String token, Chat chat) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.patch(
      Uri.parse('${BaseAPI.chatRoute}/${chat.uuid}'),
      headers: BaseAPI.headers,
      body: chat.toJson(),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('UPDATE CHAT');
    print(responseData);

    return Chat.fromMap(responseData['data']);
  }

  static deleteUserChat(String token, String uuid) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.delete(
      Uri.parse('${BaseAPI.chatRoute}/$uuid'),
      headers: BaseAPI.headers,
    );

    var responseData;
    if (response.body.isNotEmpty) {
      responseData = json.decode(response.body);
    }

    if (response.statusCode >= 400) {
      throw HttpException(
          responseData['message'] ?? 'Could not delete chat, try again.');
    }

    print('DELETE CHAT');
    print(responseData);

    return true;
  }
}
