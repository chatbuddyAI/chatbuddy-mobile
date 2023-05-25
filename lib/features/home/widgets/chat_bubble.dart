import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final Color color;
  final TextStyle textStyle;

  const ChatBubble({
    super.key,
    required this.text,
    this.isSender = true,
    this.color = Colors.white70,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SelectableText(
                text,
                style: textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
