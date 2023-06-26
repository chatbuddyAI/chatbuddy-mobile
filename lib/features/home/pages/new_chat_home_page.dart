import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:chat_buddy/common/utils/ad_state.dart';
import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/home/widgets/chat_message_bar.dart';
import 'package:chat_buddy/providers/message_provider.dart';

import '../../../providers/auth_provider.dart';
import '../widgets/chat_buddy_is_typing.dart';

class NewChatHomePage extends StatefulWidget {
  const NewChatHomePage({Key? key}) : super(key: key);

  @override
  State<NewChatHomePage> createState() => _NewChatHomePageState();
}

class _NewChatHomePageState extends State<NewChatHomePage> {
  BannerAd? banner;
  bool _isThinking = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isSubscribed!) {
      adState.initialization.then(
        (value) => setState(() {
          banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnitId,
            listener: adState.adListener,
            request: const AdRequest(),
          )..load();
        }),
      );
    }
  }

  Widget _buildChatBubbles() {
    return Column(
      children: [
        const SizedBox(height: 10),
        BubbleNormal(
          isSender: false,
          color: Theme.of(context).colorScheme.surface,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          text:
              'To start a new chat, enter your message and send, your chat buddy will respond promptly and guide you through your conversation.',
        ),
        const SizedBox(height: 10),
        BubbleNormal(
          isSender: true,
          color: Theme.of(context).colorScheme.surfaceVariant,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
          text:
              'You can also create group chats for you and your friends or colleagues to communicate with ChatBuddy together.',
        ),
        const SizedBox(height: 10),
        if (!Provider.of<AuthProvider>(context).isSubscribed!)
          BubbleNormal(
            isSender: false,
            color: Theme.of(context).colorScheme.surface,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
            text: 'You get 5 free messages daily as an unsubscribed user.',
          ),
        const SizedBox(height: 40),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSubscribed = Provider.of<AuthProvider>(context).isSubscribed;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildChatBubbles(),
            ),
          ),
          if (_isThinking) const ChatBuddyIsTyping(),
          if (banner != null)
            Container(
              height: 50,
              child: AdWidget(ad: banner!),
            ),
          ChatMessageBar(
            enabled: !_isThinking,
            onSend: (message) async {
              final adState = Provider.of<AdState>(context, listen: false);
              final messageProvider =
                  Provider.of<MessageProvider>(context, listen: false);

              if (!hasSubscribed!) {
                adState.loadInterstitialAd();
              }

              setState(() {
                _isThinking = true;
              });

              try {
                await messageProvider.sendNewChatMessage(context, message);
              } on HttpException catch (e) {
                AppUtility.showErrorDialog(
                    context: context, message: e.toString());
              } finally {
                setState(() {
                  _isThinking = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
