// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_buddy/features/subscription/pages/subscription_details_page.dart';
import 'package:chat_buddy/features/subscription/pages/subscription_page.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';

class ManageSubscriptionPage extends StatefulWidget {
  static const routeName = '/manage-subscription-page';

  const ManageSubscriptionPage({super.key});

  @override
  State<ManageSubscriptionPage> createState() => _ManageSubscriptionPageState();
}

class _ManageSubscriptionPageState extends State<ManageSubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    final hasSub = Provider.of<SubscriptionProvider>(context, listen: false)
        .isUserSubscribed!;
    return !hasSub ? const SubscriptionPage() : const SubscriptionDetailsPage();
  }
}
