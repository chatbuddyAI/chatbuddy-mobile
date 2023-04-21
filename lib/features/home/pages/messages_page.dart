import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/home/widgets/chat_buddy_is_typing.dart';
import 'package:chat_buddy/features/home/widgets/chat_message_bar.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/models/message_model.dart';
import 'package:chat_buddy/providers/message_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool _isThinking = false;
  @override
  void initState() {
    // TODO: implement initState
    _isLoading = true;

    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<MessageProvider>(context, listen: false)
          .fetchChatMessages(
              (ModalRoute.of(context)?.settings.arguments as Chat).uuid);
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
    final arg = ModalRoute.of(context)?.settings.arguments as Chat;
    final chatUuid = arg.uuid;
    final messageProvider = Provider.of<MessageProvider>(context);
    messages = messageProvider.messages;
    return Scaffold(
      // backgroundColor: Coloors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Coloors.white,
        // foregroundColor: Coloors.black,
        title: Text(arg.title),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Loading()
            : Column(
                children: [
                  Expanded(
                    child: GroupedListView<Message, DateTime>(
                      floatingHeader: true,
                      // useStickyGroupSeparators: true,
                      reverse: true,
                      order: GroupedListOrder.DESC,
                      elements: messages,
                      groupBy: (message) => DateTime(
                        message.createdAt.year,
                        message.createdAt.month,
                        message.createdAt.day,
                      ),
                      groupHeaderBuilder: (Message message) => SizedBox(
                        height: 40,
                        child: Center(
                          child: FittedBox(
                            child: DateChip(
                              date: message.createdAt,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 30,
                      //   child: FittedBox(
                      //     child: Center(
                      //       child: Card(
                      //         color: Theme.of(context).colorScheme.surface,
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8),
                      //           child: Text(
                      //             DateFormat.yMMMd().format(message.createdAt),
                      //             style: TextStyle(
                      //               color:
                      //                   Theme.of(context).colorScheme.onSurface,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      itemBuilder: (context, Message message) => Column(
                        children: [
                          BubbleNormal(
                            color: message.isBotReply
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.surfaceVariant,
                            textStyle: TextStyle(
                              color: message.isBotReply
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            text: message.message,
                            isSender: !message.isBotReply,
                          ),
                          if (message.isBotReply)
                            Align(
                              alignment: !message.isBotReply
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: message.message));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          },
                                        ),
                                        content: const Text(
                                            'Text copied to clipboard!'),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.content_copy_rounded,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_isThinking) const ChatBuddyIsTyping(),
                  ChatMessageBar(
                    enabled: !_isThinking,
                    onSend: (text) async {
                      setState(() {
                        _isThinking = true;
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
                      } finally {
                        setState(() {
                          _isThinking = false;
                        });
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
