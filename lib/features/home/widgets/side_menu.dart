import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/features/home/pages/home_page.dart';
import 'package:chat_buddy/features/home/widgets/chat_history.dart';
import 'package:chat_buddy/features/home/widgets/drawer_menu_item.dart';
import 'package:chat_buddy/features/settings/pages/settings_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  ChatHistory chatHistory = ChatHistory();

  Future<void> _logoutUser(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
  }

  void _createGroupDialogForm(BuildContext context) {
    return AppUtility.showInfoDialog(
        context: context, message: 'The group feature is coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.35,
        child: Column(
          children: [
            ...chatHistory.chatList(context),
            const Divider(),
            DrawerMenuItem(
              title: "New Chat",
              icon: Icons.add,
              onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
            ),
            DrawerMenuItem(
              title: "Create Group",
              icon: Icons.group,
              onTap: () => _createGroupDialogForm(context),
            ),
            DrawerMenuItem(
              title: "Settings",
              icon: Icons.settings,
              onTap: () =>
                  Navigator.of(context).pushNamed(SettingsPage.routeName),
            ),
            DrawerMenuItem(
              iconColor: Coloors.red,
              title: "Logout",
              icon: Icons.logout,
              onTap: () => _logoutUser(context),
            ),
          ],
        ),
      ),
    );
  }
}
