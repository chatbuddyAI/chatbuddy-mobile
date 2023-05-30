// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/theme/theme_manager.dart';
import 'package:chat_buddy/features/subscription/pages/manage_subscription_page.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings-page';

  const SettingsPage({super.key});

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Dark mode'),
              subtitle: const Text('toggle dark mode'),
              trailing: Consumer<ThemeManager>(
                builder: (_, themeManager, __) {
                  return Switch(
                    value: themeManager.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeManager.togggleTheme(value);
                    },
                  );
                },
              ),
            ),
            Consumer<SubscriptionProvider>(
              builder: (_, subscription, __) => ListTile(
                leading: const Icon(Icons.card_membership_rounded),
                title: const Text('Manage subscription'),
                subtitle: const Text('cancel, enable & update payment method'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () async {
                  await Provider.of<SubscriptionProvider>(context,
                          listen: false)
                      .checkIsUserSubscribed();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManageSubscriptionPage(
                        isSubscribed: subscription.isUserSubscribed!,
                      ),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.policy_rounded),
              title: const Text('Privacy policy'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () => _launchUrl(
                  'https://chatbuddy.gabrielibenye.com/privacy-policy.html'),
            ),
            ListTile(
              leading: const Icon(Icons.library_books_outlined),
              title: const Text('Terms of service'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () => _launchUrl(
                  'https://chatbuddy.gabrielibenye.com/terms-of-service.html'),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share the app'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the app'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
