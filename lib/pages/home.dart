import 'package:chat_buddy/pages/ai_writter.dart';
import 'package:chat_buddy/pages/chats.dart';
import 'package:chat_buddy/pages/new_chat.dart';
import 'package:chat_buddy/widgetsBuilder/theme.dart';
import 'package:chat_buddy/widgetsBuilder/widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = PageController(initialPage: 0);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          height: MediaQuery.of(context).size.height,
          duration: const Duration(seconds: 1),
          child: Stack(
            children: [
              PersonalWidgets.appBar(context, widget.title),
              Padding(
                padding: const EdgeInsets.only(top:100.0),
                child: PageView(
                  controller: _controller,
                  children: [
                    NewChat(
                      title: widget.title,
                      ncColor: AppColors.primaryColor(),
                    ),
                    Chats(
                      title: widget.title,
                      cColor: AppColors.primaryColor(),
                    ),
                    AIWritter(
                      title: widget.title,
                      aIWColor: AppColors.primaryColor(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
