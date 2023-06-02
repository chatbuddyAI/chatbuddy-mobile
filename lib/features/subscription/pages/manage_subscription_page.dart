// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/features/settings/pages/settings_page.dart';
import 'package:chat_buddy/features/subscription/pages/subscription_details_page.dart';
import 'package:chat_buddy/features/subscription/pages/subscription_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/subscription_plan.dart';

class ManageSubscriptionPage extends StatefulWidget {
  static const routeName = '/manage-subscription-page';

  final bool isSubscribed;
  const ManageSubscriptionPage({super.key, required this.isSubscribed});

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
