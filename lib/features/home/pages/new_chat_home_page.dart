import 'package:flutter/material.dart';

class NewChatHomePage extends StatelessWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: Container()),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (value) {},
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Colors.teal,
                      )),
                  // suffixIcon: Icon(Icons.send),
                  hintText: 'Tell us about yourself',
                  suffixStyle: TextStyle(color: Colors.green),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      ),
    ]);
  }
}
