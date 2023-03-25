import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/home/widgets/chat_text_field.dart';
import 'package:chat_buddy/models/message_model.dart';
import 'package:chat_buddy/providers/message_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  static const routeName = '/messages-page';

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Message> messages = [];
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<MessageProvider>(context, listen: false)
          .fetchChatMessages(
              ModalRoute.of(context)?.settings.arguments as String);
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
    final chatUuid = ModalRoute.of(context)?.settings.arguments as String;
    final messageProvider = Provider.of<MessageProvider>(context);
    messages = messageProvider.messages;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: _isLoading
            ? const Loading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => BubbleNormal(
                      color: Colors.grey,
                      textStyle: const TextStyle(fontSize: 12),
                      text: messages[index].message,
                      isSender: !messages[index].isBotReply,
                    ),
                  )),
                  MessageBar(
                    onSend: (text) async {
                      setState(() {
                        messageProvider.addUserMessage(
                          Message(
                            id: 'new',
                            sender: 'user',
                            message: text,
                            isBotReply: false,
                            chat: chatUuid,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        );
                      });
                      try {
                        await messageProvider.sendChatmessage(chatUuid, text);
                      } on HttpException catch (e) {
                        _showErrorDialog(e.toString());
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }
}
