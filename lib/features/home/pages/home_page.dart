import 'package:chat_buddy/features/home/pages/new_chat_home_page.dart';
import 'package:chat_buddy/features/home/widgets/go_pro_button.dart';
import 'package:chat_buddy/features/home/widgets/side_menu.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../subscription/pages/subscription_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home-page';

  @override
  Widget build(BuildContext context) {
    final hasSubscribed = Provider.of<AuthProvider>(context).isSubscribed;

    if (!hasSubscribed!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => const SubscriptionPage(),
        );
      });
    }
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text(
          'ChatBuddy',
          style: TextStyle(letterSpacing: 1),
        ),
        elevation: 0,
        actions: [
          if (!hasSubscribed)
            Container(
              padding: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
              child: const GoProButton(),
            )
        ],
      ),
      body: const SafeArea(
        child: NewChatHomePage(),
      ),
    );
  }
}
