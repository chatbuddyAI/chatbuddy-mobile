import 'package:chat_buddy/widgetsBuilder/widgets.dart';
import 'package:flutter/material.dart';

class NewChat extends StatelessWidget {
  const NewChat(
      {Key? key,
      required this.title,
      this.ncColor = Colors.black38,
      this.cColor = Colors.black38,
      this.aIWColor = Colors.black38})
      : super(key: key);
  final String title;
  final Color ncColor;
  final Color cColor;
  final Color aIWColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      // color: Colors.lightGreenAccent,
      child: Column(
        children: [
          const Divider(
            height: 20.0,
            color: Colors.black54,
            endIndent: 25.0,
            indent: 25.0,
          ),
          PersonalWidgets.chatBox(context)
        ],
      ),
    );
  }
}
