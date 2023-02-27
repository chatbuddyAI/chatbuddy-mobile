import 'package:flutter/material.dart';

import '../widgets/chat_text_field.dart';

class NewChatHomePage extends StatelessWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: Container()),
      AnimatedContainer(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.black12),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 1.2,
        duration: const Duration(seconds: 2),
        child: const Text(
          "To start a new chat, enter your message and send. The boy will respond promptly and guide you through your conversation.",
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      AnimatedContainer(
        duration: const Duration(seconds: 2),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AnimatedContainer(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12),
                duration: const Duration(seconds: 2),
                child: const Text(
                  "You can also create group chats for you and your friends or collegues. Click the plus button to create a group.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 1,
              child: AnimatedContainer(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12),
                duration: const Duration(seconds: 2),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 35, color: Colors.amber),
                  color: Colors.black12,
                  onPressed: () {
                    createGroupDialogForm(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(child: Container()),
      const ChatTextField(),
    ]);
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
