import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/services/chatbuddy/chat_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];
  late String? authToken;

  void update(String? token) {
    authToken = token;
  }

  List<Chat> get chats {
    return [..._chats];
  }

  Map<DateTime, List<Chat>> get groupedChats {
    Map<DateTime, List<Chat>> groupedChats = {};

    for (var chat in chats) {
      final date = DateTime(
          chat.updatedAt.year, chat.updatedAt.month, chat.updatedAt.day);
      if (groupedChats.containsKey(date)) {
        groupedChats[date]!.add(chat);
      } else {
        groupedChats[date] = [chat];
      }
    }

    return groupedChats;
  }

  Future<void> fetchChats() async {
    try {
      final chats = await ChatService.getUserChats(authToken!);

      _chats = chats;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateChat(Chat updatedChat) async {
    final chatIndex = _chats.indexWhere((chat) => chat.id == updatedChat.id);

    if (chatIndex < 0) return;

    try {
      await ChatService.updateUserChat(authToken!, updatedChat);

      _chats[chatIndex] = updatedChat;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteChat(String uuid) async {
    /// Opitmistic Deleting
    /// simply means removing the item from the
    /// list while saving a copy of it in memory inorder
    /// to check if the http request was successful.
    /// if it was successful the copy of the item wil be remove from memory
    /// else the copy will be restored back into the list.
    /// As shown below
    final existingChatIndex = _chats.indexWhere((chat) => chat.uuid == uuid);
    var existingChat =
        _chats[existingChatIndex]; // saving a copy of the selected item
    _chats.removeAt(existingChatIndex); // removing the item from the list
    notifyListeners();
    try {
      await ChatService.deleteUserChat(authToken!, uuid);

      _chats = chats;
      notifyListeners();
    } catch (error) {
      _chats.insert(
        existingChatIndex,
        existingChat,
      );
      notifyListeners();
      rethrow;
    }
  }
}
