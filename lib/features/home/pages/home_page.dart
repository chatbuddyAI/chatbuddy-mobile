import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/features/home/pages/ai_writer_home_page.dart';
import 'package:chat_buddy/features/home/pages/chats_home_page.dart';
import 'package:chat_buddy/features/home/pages/new_chat_home_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _logoutUser(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  case 'logout':
                    _logoutUser(context);
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
                    value: '/about',
                    child: Text("About"),
                  ),
                  PopupMenuItem(
                    value: 'logout',
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
        body: const TabBarView(children: [
          NewChatHomePage(),
          ChatsHomePage(),
          AiWriterHomePage(),
        ]),
      ),
    );
  }
}
