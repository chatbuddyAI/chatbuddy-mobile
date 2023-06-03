import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../subscription/pages/subscription_page.dart';

class GoProButton extends StatelessWidget {
  const GoProButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: const ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
        ),
        onPressed: () =>
            Navigator.of(context).pushNamed(SubscriptionPage.routeName),
        icon: const Icon(Icons.stars),
        label: const Text('Go PRO'));
  }
}
