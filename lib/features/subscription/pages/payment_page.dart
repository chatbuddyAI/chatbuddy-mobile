// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';

class PaymentPage extends StatefulWidget {
  static const routeName = '/payment-page';
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // late final WebViewController _controller;
  late final PlatformWebViewControllerCreationParams params;

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)?.settings.arguments as String;
    if (kDebugMode) {
      print(url);
    }

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
// ···
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return WillPopScope(
      onWillPop: () async {
        await Provider.of<SubscriptionProvider>(context, listen: false)
            .checkIsUserSubscribed();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MyApp(),
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Coloors.white,
        body: SafeArea(
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
