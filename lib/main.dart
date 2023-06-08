import 'package:chat_buddy/common/theme/dark_theme.dart';
import 'package:chat_buddy/common/theme/light_theme.dart';
import 'package:chat_buddy/common/theme/theme_manager.dart';
import 'package:chat_buddy/features/authentication/pages/email_verification_page.dart';
import 'package:chat_buddy/features/authentication/pages/forgot_password_page.dart';
import 'package:chat_buddy/features/authentication/pages/login_or_register_page.dart';
import 'package:chat_buddy/features/authentication/pages/login_page.dart';
import 'package:chat_buddy/features/authentication/pages/reset_password_page.dart';
import 'package:chat_buddy/features/home/pages/home_page.dart';
import 'package:chat_buddy/features/home/pages/messages_page.dart';
import 'package:chat_buddy/features/settings/pages/settings_page.dart';
import 'package:chat_buddy/features/subscription/pages/manage_subscription_page.dart';
import 'package:chat_buddy/features/subscription/pages/payment_page.dart';
import 'package:chat_buddy/features/subscription/pages/subscription_details_page.dart';
import 'package:chat_buddy/features/subscription/pages/subscription_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/chat_provider.dart';
import 'package:chat_buddy/providers/message_provider.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:chat_buddy/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: const MyApp(),
    ),
  );
}

// ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create: (_) => ChatProvider(),
          update: (ctx, auth, data) => data!
            ..update(
              auth.token,
            ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, MessageProvider>(
          create: (_) => MessageProvider(),
          update: (ctx, auth, data) => data!
            ..update(
              auth.token,
            ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SubscriptionProvider>(
          create: (_) => SubscriptionProvider(),
          update: (ctx, auth, data) => data!
            ..update(
              auth.token,
            ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          routes: {
            HomePage.routeName: (_) => const HomePage(),
            MessagesPage.routeName: (_) => const MessagesPage(),
            SettingsPage.routeName: (_) => const SettingsPage(),
            PaymentPage.routeName: (_) => const PaymentPage(),
            ForgotPasswordPage.routeName: (_) => const ForgotPasswordPage(),
            LoginOrRegisterPage.routeName: (_) => const LoginOrRegisterPage(),
            ManageSubscriptionPage.routeName: (_) =>
                const ManageSubscriptionPage(),
            SubscriptionPage.routeName: (_) => const SubscriptionPage(),
            SubscriptionDetailsPage.routeName: (_) =>
                const SubscriptionDetailsPage(),
          },
          debugShowCheckedModeBanner: false,
          title: 'ChatBuddy',
          darkTheme: darkTheme(),
          theme: lightTheme(),
          themeMode: _themeManager.themeMode,
          home: auth.isAuthenticated
              ? auth.userHasVerifiedEmail
                  ? const HomePage()
                  : EmailVerificationPage(email: auth.user!.email)
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const LoginOrRegisterPage(),
                ),
        ),
      ),
    );
  }
}
