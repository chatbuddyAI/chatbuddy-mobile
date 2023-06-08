// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/theme/theme_manager.dart';
import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/features/settings/widgets/edit_user_form.dart';
import 'package:chat_buddy/features/subscription/pages/manage_subscription_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../widgets/change_password_form.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings-page';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              Consumer<AuthProvider>(
                builder: (_, authUser, child) {
                  return ListTile(
                    leading: RandomAvatar(authUser.user!.name,
                        height: 50, width: 50),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Row(
                            children: [
                              Text(authUser.user!.name.toUpperCase()),
                              const SizedBox(width: 5),
                              GestureDetector(
                                  onTap: () => showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text(
                                            'Update Name',
                                          ),
                                          content: EditUserForm(
                                            name: authUser.user!.name.trim(),
                                          ),
                                        ),
                                      ),
                                  child: const Icon(Icons.edit_outlined))
                            ],
                          ),
                        ),
                        FittedBox(child: Text(authUser.user!.email)),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                            title: Text(
                              'Change Password',
                            ),
                            content: ChangePasswordForm(),
                          ),
                        ),
                        child: const Text(
                          'change password',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Dark mode'),
                subtitle: const Text('toggle dark mode'),
                trailing: Consumer<ThemeManager>(
                  builder: (_, themeManager, __) {
                    return Switch(
                      inactiveThumbColor: Coloors.rustOrange,
                      inactiveTrackColor: Coloors.rustOrangeLight,
                      value: themeManager.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeManager.togggleTheme(value);
                      },
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.card_membership_rounded),
                title: const Text('Manage subscription'),
                subtitle: const Text('cancel, enable & update payment method'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () async {
                  await Provider.of<SubscriptionProvider>(
                    context,
                    listen: false,
                  ).checkIsUserSubscribed();
                  Navigator.of(context)
                      .popAndPushNamed(ManageSubscriptionPage.routeName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.policy_rounded),
                title: const Text('Privacy policy'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () => AppUtility.urlLauncher(
                    'https://chatbuddy.ng/privacy-policy.html'),
              ),
              ListTile(
                leading: const Icon(Icons.library_books_outlined),
                title: const Text('Terms of service'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () => AppUtility.urlLauncher(
                    'https://chatbuddy.ng/terms-of-service.html'),
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
      ),
    );
  }
}
