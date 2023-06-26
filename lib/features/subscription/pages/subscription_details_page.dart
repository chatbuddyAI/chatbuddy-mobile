// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/features/settings/pages/settings_page.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  static const routeName = '/subscription-details-page';
  const SubscriptionDetailsPage({super.key});

  Future<void> _loadSubscriptionData(BuildContext context) async {
    try {
      await Provider.of<SubscriptionProvider>(context, listen: false)
          .fetchSubscriptionData();
    } on HttpException catch (e) {
      AppUtility.showErrorDialog(
        context: context,
        message: e.message,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Subscription')),
      body: FutureBuilder(
        future: _loadSubscriptionData(context),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Loading()
              : Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Consumer<SubscriptionProvider>(
                    builder: (_, subscription, __) => SafeArea(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              ListTile(
                                  title:
                                      Text(subscription.subscription.planName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'status: ${subscription.subscription.status}',
                                      ),
                                      subscription.subscription
                                                  .nextPaymentDate ==
                                              null
                                          ? const Text(
                                              'Next payment date: No date')
                                          : Text(
                                              'Next payment date: ${DateFormat.MMMMEEEEd().format(
                                                DateTime.parse(
                                                  subscription.subscription
                                                      .nextPaymentDate!,
                                                ),
                                              )}',
                                            ),
                                    ],
                                  ),
                                  trailing: subscription.subscription.status ==
                                          'active'
                                      ? InkWell(
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Coloors.red,
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            await AppUtility.areYouSureDialog(
                                              context: context,
                                              prompt:
                                                  "Do you really want to cancel your subscription?",
                                              yes: () async {
                                                try {
                                                  final msg = await subscription
                                                      .cancelSubscription();

                                                  await subscription
                                                      .checkIsUserSubscribed();

                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const SettingsPage(),
                                                    ),
                                                  );

                                                  AppUtility.showSuccessDialog(
                                                    context: context,
                                                    message: msg,
                                                  );
                                                } on HttpException catch (e) {
                                                  AppUtility.showErrorDialog(
                                                    context: context,
                                                    message: e.message,
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        )
                                      : const Text('')),
                              const SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                title: Text(
                                    '${toBeginningOfSentenceCase(subscription.card.cardType.trim())} **** ${subscription.card.last4}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${toBeginningOfSentenceCase(subscription.card.bank.toLowerCase())}',
                                    ),
                                    Text(
                                      'Expires ${subscription.card.expMonth} / ${subscription.card.expYear}',
                                    ),
                                    Text(
                                      subscription.card.accountName!
                                          .toUpperCase(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
