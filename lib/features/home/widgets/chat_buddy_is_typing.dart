import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatBuddyIsTyping extends StatelessWidget {
  const ChatBuddyIsTyping({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        const Text(
          'Your chat buddy is typing',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
        ),
        const SizedBox(
          width: 3,
        ),
        ...[
          SpinKitThreeBounce(
            color: Theme.of(context).colorScheme.primary,
            size: 14,
          )
        ]
      ]),
    );
  }
}
