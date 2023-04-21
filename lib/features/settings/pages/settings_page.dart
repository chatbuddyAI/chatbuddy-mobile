import 'package:chat_buddy/features/subscription/pages/manage_subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings-page';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLightMode = true;
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
              title: const Text('Mode'),
              subtitle: const Text('Dark & Light'),
              trailing: Switch(
                  value: _isLightMode,
                  onChanged: (_) {
                    setState(() {
                      _isLightMode = !_isLightMode;
                    });
                  }),
            ),
            ListTile(
              leading: const Icon(Icons.card_membership_rounded),
              title: const Text('Manage Subscription'),
              subtitle: const Text('cancel, enable & update payment method'),
              trailing: IconButton(
                icon: const Icon(Icons.keyboard_arrow_right_rounded),
                onPressed: () => Navigator.of(context)
                    .pushNamed(ManageSubscriptionPage.routeName),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.policy_rounded),
              title: const Text('Privacy policy'),
              // subtitle: const Text('cancel, enable & update payment method'),
              trailing: IconButton(
                icon: const Icon(Icons.keyboard_arrow_right_rounded),
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share the app'),
              // subtitle: const Text('cancel, enable & update payment method'),
              trailing: IconButton(
                icon: const Icon(Icons.keyboard_arrow_right_rounded),
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the app'),
              // subtitle: const Text('cancel, enable & update payment method'),
              trailing: IconButton(
                icon: const Icon(Icons.keyboard_arrow_right_rounded),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
