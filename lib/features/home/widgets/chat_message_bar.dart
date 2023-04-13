import 'package:flutter/material.dart';

class ChatMessageBar extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final void Function(String)? onSend;

  ChatMessageBar({
    Key? key,
    this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSubmitted: (value) {},
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                ),
                // suffixIcon: Icon(Icons.send),
                hintText: 'Type your message here',
                suffixStyle: TextStyle(color: Colors.green),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (_textController.text.trim() != '') {
                if (onSend != null) {
                  onSend!(_textController.text.trim());
                }
                _textController.text = '';
              }
            },
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          )
        ],
      ),
    );
  }
}
