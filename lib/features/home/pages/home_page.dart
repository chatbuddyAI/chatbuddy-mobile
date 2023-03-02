import 'package:chat_buddy/features/home/pages/ai_writer_home_page.dart';
import 'package:chat_buddy/features/home/pages/chats_home_page.dart';
import 'package:chat_buddy/features/home/pages/new_chat_home_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _logoutUser() async {
      await Provider.of<AuthProvider>(context, listen: false).logout();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ChatBuddy',
            style: TextStyle(letterSpacing: 1),
          ),
          elevation: 1,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'logout':
                    _logoutUser();
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
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              splashFactory: NoSplash.splashFactory,
              tabs: [
                Tab(text: 'NEW CHAT'),
                Tab(text: 'CHATS'),
                Tab(text: 'AI WRITER'),
              ]),
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
