import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/features/home/widgets/custom_normal_bubble.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_text_field.dart';

class NewChatHomePage extends StatefulWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  State<NewChatHomePage> createState() => _NewChatHomePageState();
}

class _NewChatHomePageState extends State<NewChatHomePage> {
  bool _showSecondContainer = false;
  bool _showThirdContainer = false;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _showSecondContainer = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 7000), () {
      setState(() {
        _showThirdContainer = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(height: 20),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                child: CustomBubbleNormal(
                  isSender: false,
                  text: '${user?.name} you are welcome',
                  color: Colors.black12,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                width: _showSecondContainer ? null : 0,
                height: _showSecondContainer ? null : 0,
                duration: const Duration(seconds: 2),
                child: CustomBubbleNormal(
                  isSender: false,
                  text:
                      'To start a new chat, enter your message and send, your chat buddy will respond promptly and guide you through your conversation.',
                  color: Colors.black12,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                width: _showThirdContainer ? null : 0,
                height: _showThirdContainer ? null : 0,
                duration: const Duration(seconds: 2),
                child: CustomBubbleNormal(
                  isSender: true,
                  text:
                      'You can also create group chats for you and your friends or collegues. Click the plus button to create a group.',
                  color: Colors.black12,
                ),
              ),
            ],
          ),
        )),

        // Expanded(child: Container()),
        MessageBar(
          onSend: (_) => print(_),
        ),
      ],
    );
  }

  Future<dynamic> createGroupDialogForm(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: const TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter group name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }
}
