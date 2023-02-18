import 'package:chat_buddy/widgetsBuilder/theme.dart';
import 'package:flutter/material.dart';

class PersonalWidgets {
  static const Duration _duration = Duration(seconds: 2);

  static Widget appBar(context, title) {
    return SizedBox(
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        duration: _duration,
        child: ListTile(
          title: Text(
            title,
            style: AppTextStyle.titleText(),
          ),
          trailing: const Icon(
            Icons.settings,
            size: 40.0,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  static Widget pageList(context, Color ncColor, cColor, aIWColor) {
    // TextStyle textStyle = const ;
    double sizedboxWidth = MediaQuery.of(context).size.width / 3;
    TextAlign textAlign = TextAlign.center;
    return AnimatedContainer(
      padding: const EdgeInsets.only(bottom: 20.0),
      // decoration: BoxDecoration(border: Border.all()),
      duration: _duration,
      child: Row(
        children: [
          SizedBox(
            width: sizedboxWidth,
            child: Text("New Chat",
                textAlign: textAlign,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: ncColor)),
          ),
          SizedBox(
            width: sizedboxWidth,
            child: Text("Chats",
                textAlign: textAlign,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: cColor)),
          ),
          SizedBox(
            width: sizedboxWidth,
            child: Text("AI Writter",
                textAlign: textAlign,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: aIWColor)),
          ),
        ],
      ),
    );
  }

  static Widget chatBox(context) {
    TextEditingController textController = TextEditingController(text: "");
    return AnimatedContainer(
      duration: _duration,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.3,
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
                duration: _duration,
                // color: Colors.lightGreenAccent,
                height: (MediaQuery.of(context).size.height / 1.3),
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Text("New Chat"))),
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              duration: _duration,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                    controller: textController,
                    style: const TextStyle(color: Colors.black45),
                    decoration: const InputDecoration(
                      hintText: "Write your message here",
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      // sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        // color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(child: Icon(Icons.send, color: AppColors.primaryColor())),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
