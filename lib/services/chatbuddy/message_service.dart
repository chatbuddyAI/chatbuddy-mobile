import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/models/message_model.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';
import 'package:http/http.dart' as http;

import 'package:chat_buddy/models/user_model.dart';

class MessageService {
  static Future<List<Message>> getChatMessages(
      String token, String chatUuid) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse('${BaseAPI.messageRoute}/$chatUuid'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    final List<Message> messages = [];
    for (var messageData in responseData['data'] as List<dynamic>) {
      final chat = Message.fromMap(messageData);

      messages.add(chat);
    }

    print('ALL MESSAGES');
    // print(responseData['data']);

    return messages;
  }

  static Future<Message> sendNewChatMessage(
      String token, String message) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse(BaseAPI.messageRoute),
      headers: BaseAPI.headers,
      body: jsonEncode({'message': message}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('SEND NEW CHAT MESSAGE');
    // print(responseData['data']);

    return Message.fromMap(responseData['data']);
  }

  static Future<Message> sendChatMessage(
      String token, String chatUuid, String message) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('${BaseAPI.messageRoute}/$chatUuid'),
      headers: BaseAPI.headers,
      body: jsonEncode({'message': message}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('SEND CHAT MESSAGE');
    // print(responseData['data']);

    return Message.fromMap(responseData['data']);
  }
}
