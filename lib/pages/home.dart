import 'package:chat_buddy/pages/ai_writter.dart';
import 'package:chat_buddy/pages/chats.dart';
import 'package:chat_buddy/pages/new_chat.dart';
import 'package:chat_buddy/widgetsBuilder/theme.dart';
import 'package:chat_buddy/widgetsBuilder/widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key,
      required this.title,
      this.ncColor = Colors.black38,
      this.cColor = Colors.black38,
      this.aIWColor = Colors.black38});
  final String title;
  final Color ncColor;
  final Color cColor;
  final Color aIWColor;

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
              PersonalWidgets.pageList(context, widget.ncColor, widget.cColor, widget.aIWColor),
              // Positioned(
              //   top: (MediaQuery.of(context).size.height / 8) +
              //       (MediaQuery.of(context).size.height / 13),
              //   child: const Divider(
              //     height: 20.0,
              //     color: Colors.black54,
              //     endIndent: 25.0,
              //     indent: 25.0,
              //   ),
              // ),
              Positioned(
                top: (MediaQuery.of(context).size.height / 8) +
                    (MediaQuery.of(context).size.height / 13),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  height: MediaQuery.of(context).size.height -
                      ((MediaQuery.of(context).size.height / 8) +
                          (MediaQuery.of(context).size.height / 13)),
                  width: MediaQuery.of(context).size.width,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
