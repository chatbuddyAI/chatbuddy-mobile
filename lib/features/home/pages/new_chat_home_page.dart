import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
    return Column(
      children: [
        // const SizedBox(height: 20),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              BubbleNormal(
                isSender: false,
                text:
                    'To start a new chat, enter your message and send, your chat buddy will respond promptly and guide you through your conversation.',
                color: Colors.black12,
              ),
              const SizedBox(height: 10),
              BubbleNormal(
                isSender: true,
                text:
                    'You can also create group chats for you and your friends or collegues. Go to the chats page',
                color: Colors.black12,
              ),
              const SizedBox(height: 40),
            ],
          ),
        )),

        // Expanded(child: Container()),
        if (_isThinking) ...[
          const SpinKitThreeBounce(
            color: Coloors.rustOrange,
            size: 18,
          )
        ],
        MessageBar(
            sendButtonColor: Coloors.rustOrange,
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
            }),
      ],
    );
  }
}
