import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final Color? iconColor;
  final String? routeName;
  final Function()? onTap;
  const DrawerMenuItem(
      {super.key,
      required this.context,
      required this.title,
      required this.icon,
      this.iconColor,
      this.routeName,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        iconColor: iconColor ?? Theme.of(context).primaryColor,
        leading: Icon(icon),
        autofocus: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            // fontSize: 19.4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
