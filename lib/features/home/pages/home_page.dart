import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/home/pages/ai_writer_home_page.dart';
import 'package:chat_buddy/features/home/pages/chats_home_page.dart';
import 'package:chat_buddy/features/home/pages/messages_page.dart';
import 'package:chat_buddy/features/home/pages/new_chat_home_page.dart';
import 'package:chat_buddy/features/settings/pages/settings_page.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home-page';

  Future<void> _logoutUser(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
  }

  Future<void> _loadChats(BuildContext context) async {
    await Provider.of<ChatProvider>(context, listen: false).fetchChats();
  }

  Future<dynamic> _editChatDialogForm(BuildContext context, Chat chat) {
    final titleController = TextEditingController();

    titleController.text = chat.title;
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
                print('Nothing changed with the title');
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
              print(titleController.text);
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChat(String uuid, BuildContext context) async {
    try {
      await Provider.of<ChatProvider>(context, listen: false).deleteChat(uuid);
    } on HttpException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            width: MediaQuery.of(context).size.width / 1.35,
            child: Column(
              children: [
                // const SizedBox(
                //   height: 40,
                // ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Chat History'.toUpperCase()),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _loadChats(context),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return Consumer<ChatProvider>(
                          builder: (_, chat, __) =>
                              GroupedListView<Chat, DateTime>(
                            elements: chat.chats,
                            order: GroupedListOrder.DESC,
                            groupBy: (chat) => DateTime(
                              chat.updatedAt.year,
                              chat.updatedAt.month,
                              chat.updatedAt.day,
                            ),
                            separator: const Divider(),
                            groupSeparatorBuilder: (value) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DateChip(
                                date: value,
                                color: Colors.transparent,
                              ),
                            ),
                            // groupHeaderBuilder: (Chat chat) => SizedBox(
                            //   height: 40,
                            //   child: FittedBox(
                            //     child: DateChip(
                            //       date: chat.updatedAt,
                            //       color: Colors.transparent,
                            //     ),
                            //   ),
                            // ),
                            itemBuilder: (context, Chat chat) => Slidable(
                              key: ValueKey(chat.uuid),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    // label: 'Delete',
                                    onPressed: (_) =>
                                        _deleteChat(chat.uuid, context),
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
                              child: ListTile(
                                  leading: const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 16,
                                  ),
                                  title: Text(
                                    chat.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      // fontSize: 19.4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed(
                                      MessagesPage.routeName,
                                      arguments: chat,
                                    );
                                  }),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const Divider(),
                _buildDrawerMenuItem(
                  context: context,
                  title: "New Chat",
                  icon: Icons.add,
                  onTap: () =>
                      Navigator.of(context).pushNamed(HomePage.routeName),
                ),
                _buildDrawerMenuItem(
                  context: context,
                  title: "Logout",
                  icon: Icons.logout,
                  onTap: () => _logoutUser(context),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'ChatBuddy',
            style: TextStyle(letterSpacing: 1),
          ),
          // backgroundColor: Coloors.white,
          // foregroundColor: Coloors.black,
          elevation: 0,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.settings_outlined),
              onSelected: (value) {
                switch (value) {
                  case '/logout':
                    _logoutUser(context);
                    break;
                  case '/settings':
                    Navigator.of(context).pushNamed(SettingsPage.routeName);
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext bc) {
                return const [
                  PopupMenuItem(
                    value: '/hello',
                    child: Text("Hello"),
                  ),
                  PopupMenuItem(
                    value: '/settings',
                    child: Text("Settings"),
                  ),
                  PopupMenuItem(
                    value: '/logout',
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ];
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'NEW CHAT'),
              Tab(text: 'CHATS'),
              Tab(text: 'AI WRITER'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(children: [
            NewChatHomePage(),
            ChatsHomePage(),
            AiWriterHomePage(),
          ]),
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    String? routeName,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        autofocus: true,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
