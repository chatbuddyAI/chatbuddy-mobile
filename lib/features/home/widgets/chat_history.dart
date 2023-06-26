import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:chat_buddy/common/utils/ad_state.dart';
import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/home/pages/messages_page.dart';
import 'package:chat_buddy/features/home/widgets/drawer_menu_item.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/chat_provider.dart';

class ChatHistory {
  Future<void> _loadChats(BuildContext context) async {
    await Provider.of<ChatProvider>(context, listen: false).fetchChats();
  }

  Future<dynamic> _editChatDialogForm(BuildContext context, Chat chat) {
    final titleController = TextEditingController();

    titleController.text = chat.title.trim();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Chat'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (chat.title.trim() == titleController.text.trim()) {
                if (kDebugMode) {
                  print('Nothing changed with the title');
                }
                return Navigator.of(context).pop();
              }
              Chat edittedChat = Chat(
                id: chat.id,
                user: chat.user,
                type: chat.type,
                members: chat.members,
                maxMembers: chat.maxMembers,
                title: titleController.text.trim(),
                uuid: chat.uuid,
                createdAt: chat.createdAt,
                updatedAt: chat.updatedAt,
              );

              try {
                Provider.of<ChatProvider>(context, listen: false)
                    .updateChat(edittedChat);
              } on HttpException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.of(context).pop();
              }

              Navigator.of(context).pop();
              if (kDebugMode) {
                print(titleController.text);
              }
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChat(Chat chat, BuildContext context) async {
    try {
      await Provider.of<ChatProvider>(context, listen: false)
          .deleteChat(chat.uuid);
    } on HttpException catch (e) {
      // Navigator.of(context).pop();
      AppUtility.showErrorDialog(context: context, message: e.toString());
    }
  }

  List<Widget> chatList(BuildContext context) {
    final hasSubscribed = Provider.of<AuthProvider>(context).isSubscribed;
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Chat History'.toUpperCase()),
      ),
      Expanded(
        child: FutureBuilder(
          future: _loadChats(context),
          builder: (_, snapshot) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () => _loadChats(context),
              child: Consumer<ChatProvider>(
                builder: (_, chat, __) => ListView.builder(
                  itemCount: chat.groupedChats.length,
                  itemBuilder: (context, index) {
                    final date = chat.groupedChats.keys.elementAt(index);
                    final chatsForDate = chat.groupedChats[date];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DateChip(
                            date: date,
                            color: Colors.transparent,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chatsForDate!.length,
                          itemBuilder: (context, index) {
                            final chat = chatsForDate[index];
                            return Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Coloors.red,
                                    foregroundColor: Coloors.white,
                                    icon: Icons.delete,
                                    // label: 'Delete',
                                    onPressed: (_) =>
                                        _deleteChat(chat, context),
                                  ),
                                  SlidableAction(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                    backgroundColor: Coloors.mustardYellow,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit_square,
                                    // label: 'edit',
                                    onPressed: (_) =>
                                        _editChatDialogForm(context, chat),
                                  ),
                                ],
                              ),
                              child: DrawerMenuItem(
                                title: chat.title,
                                iconColor:
                                    Theme.of(context).colorScheme.onSurface,
                                icon: Icons.chat_bubble_outline,
                                onTap: () {
                                  if (!hasSubscribed!) {
                                    Provider.of<AdState>(context, listen: false)
                                        .loadInterstitialAd();
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                    MessagesPage.routeName,
                                    arguments: chat,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
