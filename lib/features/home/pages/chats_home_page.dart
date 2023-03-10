import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/providers/chat_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ChatsHomePage extends StatefulWidget {
  const ChatsHomePage({Key? key}) : super(key: key);

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  final titleController = TextEditingController();

  Future<void> _loadChats() async {
    Future.delayed(Duration.zero).then(
      (_) {
        Provider.of<ChatProvider>(context, listen: false).fetchChats();
      },
    );
  }

  Future<void> _deleteChat(String uuid) async {
    try {
      await Provider.of<ChatProvider>(context, listen: false).deleteChat(uuid);
    } on HttpException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<dynamic> _editChatDialogForm(BuildContext context, Chat chat) {
    titleController.text = chat.title;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Chat'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter group name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (chat.title.trim() == titleController.text.trim()) {
                print('Nothing changed with the title');
                return Navigator.of(context).pop();
              }
              Chat edittedChat = Chat(
                id: chat.id,
                user: chat.user,
                type: chat.type,
                members: chat.members,
                maxMembers: chat.maxMembers,
                title: titleController.text.trim(),
                uuid: chat.uuid,
                createdAt: chat.createdAt,
                updatedAt: chat.updatedAt,
              );

              try {
                Provider.of<ChatProvider>(context, listen: false)
                    .updateChat(edittedChat);
              } on HttpException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.of(context).pop();
              }

              Navigator.of(context).pop();
              print(titleController.text);
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createGroupDialogForm(context),
        label: const Text('Create group chat'),
        icon: const Icon(Icons.chat_rounded),
      ),
      body: Consumer<ChatProvider>(
        builder: (_, chat, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: _loadChats,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                height: 30,
                endIndent: 30,
                thickness: 0.4,
              ),
              itemCount: chat.chats.length,
              itemBuilder: (context, index) => Slidable(
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const DrawerMotion(),

                  // A pane can dismiss the Slidable.
                  // dismissible: DismissiblePane(onDismissed: () {}),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (_) => _deleteChat(chat.chats[index].uuid),
                    ),
                    SlidableAction(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      backgroundColor: Coloors.mustardYellow,
                      foregroundColor: Colors.white,
                      icon: Icons.edit_square,
                      label: 'edit',
                      onPressed: (_) =>
                          _editChatDialogForm(context, chat.chats[index]),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    chat.chats[index].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19.4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () async {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
