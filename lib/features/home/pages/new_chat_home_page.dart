import 'package:flutter/material.dart';

import '../widgets/chat_text_field.dart';

class NewChatHomePage extends StatelessWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: Container()),
      const ChatTextField(),
    ]);
  }
}
