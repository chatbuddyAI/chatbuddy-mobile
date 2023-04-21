import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/home/widgets/chat_message_bar.dart';
import 'package:chat_buddy/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_buddy_is_typing.dart';

class NewChatHomePage extends StatefulWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  State<NewChatHomePage> createState() => _NewChatHomePageState();
}

class _NewChatHomePageState extends State<NewChatHomePage> {
  bool _isThinking = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occured!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Coloors.white,
      body: Column(
        children: [
          // const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                BubbleNormal(
                  isSender: false,
                  color: Theme.of(context).colorScheme.surface,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  text:
                      'To start a new chat, enter your message and send, your chat buddy will respond promptly and guide you through your conversation.',
                  // color: Colors.black12,
                ),
                const SizedBox(height: 10),
                BubbleNormal(
                  isSender: true,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  text:
                      'You can also create group chats for you and your friends or collegues. Go to the chats page',
                  // color: Colors.black12,
                ),
                const SizedBox(height: 40),
              ],
            ),
          )),

          // Expanded(child: Container()),
          if (_isThinking) const ChatBuddyIsTyping(),

          ChatMessageBar(
            enabled: !_isThinking,
            onSend: (message) async {
              setState(() {
                _isThinking = true;
              });
              try {
                await Provider.of<MessageProvider>(context, listen: false)
                    .sendNewChatMessage(context, message);
              } on HttpException catch (e) {
                _showErrorDialog(e.toString());
              } finally {
                setState(() {
                  _isThinking = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
