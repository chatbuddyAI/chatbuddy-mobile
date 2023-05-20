import 'package:flutter/material.dart';

import 'package:chat_buddy/models/message_model.dart';
import 'package:chat_buddy/services/chatbuddy/message_service.dart';

import '../features/home/pages/messages_page.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];
  late String? authToken;
  String? _newChatUuid;

  void update(String? token) {
    authToken = token;
  }

  List<Message> get messages {
    return [..._messages.reversed];
  }

  List<Message> getMessagesById(chatUuid) {
    return [...messages.where((element) => element.chat == chatUuid)];
  }

  String get newChatUuid {
    return _newChatUuid!;
  }

  Future<List<Message>> fetchChatMessages(String chatUuid) async {
    _messages.clear();
    try {
      final messages =
          await MessageService.getChatMessages(authToken!, chatUuid);

      _messages.addAll(messages);
      notifyListeners();
      return messages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Message> sendChatmessage(String chatUuid, String message) async {
    try {
      final chatMessage =
          await MessageService.sendChatMessage(authToken!, chatUuid, message);
      _messages.insert(0, chatMessage);
      notifyListeners();
      return chatMessage;
    } catch (error) {
      rethrow;
    }
  }

  Future<Future<Object?>> sendNewChatMessage(
      BuildContext context, String message) async {
    _messages.clear();
    try {
      final chatMessage =
          await MessageService.sendNewChatMessage(authToken!, message);
      _messages.add(chatMessage);
      notifyListeners();

      return Navigator.of(context)
          .pushNamed(MessagesPage.routeName, arguments: chatMessage.chat);
    } catch (error) {
      rethrow;
    }
  }

  void addUserMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}
