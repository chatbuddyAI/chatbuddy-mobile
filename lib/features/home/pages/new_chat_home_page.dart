import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/features/authentication/widgets/my_button.dart';
import 'package:chat_buddy/features/home/widgets/custom_normal_bubble.dart';
import 'package:flutter/material.dart';

class NewChatHomePage extends StatefulWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  State<NewChatHomePage> createState() => _NewChatHomePageState();
}

class _NewChatHomePageState extends State<NewChatHomePage> {
  bool _showSecondContainer = false;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(const Duration(milliseconds: 5000), () {
      setState(() {
        _showSecondContainer = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
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
                  text:
                      'To start a new chat, enter your message and send, your chat buddy will respond promptly and guide you through your conversation.',
                  color: Colors.black12,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                width: _showSecondContainer ? null : 0,
                height: _showSecondContainer ? null : 0,
                duration: const Duration(seconds: 2),
                child: CustomBubbleNormal(
                  isSender: true,
                  text:
                      'You can also create group chats for you and your friends or collegues. Go to the chats page',
                  color: Colors.black12,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        )),

        // Expanded(child: Container()),
        MessageBar(
          sendButtonColor: Coloors.rustOrange,
          onSend: (_) => print(_),
        ),
      ],
    );
  }

  Future<dynamic> _createGroupDialogForm(BuildContext context) {
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
