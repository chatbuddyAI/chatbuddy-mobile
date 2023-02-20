import 'package:chat_buddy/features/home/pages/ai_writer_home_page.dart';
import 'package:chat_buddy/features/home/pages/chats_home_page.dart';
import 'package:chat_buddy/features/home/pages/new_chat_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          elevation: 1,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
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
