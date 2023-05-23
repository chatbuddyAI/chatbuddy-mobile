// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
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

  const ManageSubscriptionPage({super.key});

  @override
  State<ManageSubscriptionPage> createState() => _ManageSubscriptionPageState();
}

class _ManageSubscriptionPageState extends State<ManageSubscriptionPage> {
  bool _isSubscribed = false;

  @override
  void initState() {
    _isSubscribed = Provider.of<SubscriptionProvider>(context, listen: false)
        .isUserSubscribed!;
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadPlans(BuildContext context) async {
    await Provider.of<SubscriptionProvider>(context, listen: false)
        .fetchPlans();
  }

  Future<void> _loadSubscriptionData(BuildContext context) async {
    await Provider.of<SubscriptionProvider>(context, listen: false)
        .fetchSubscriptionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage subscription'),
      ),
      body: !_isSubscribed
          ? FutureBuilder(
              future: _loadPlans(context),
              builder: (context, _) => Consumer<SubscriptionProvider>(
                builder: (_, plan, __) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: ListView.separated(
                    separatorBuilder: (context, _) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: plan.plans.length,
                    itemBuilder: (context, index) => SubscriptionPlan(
                      name: plan.plans[index].name,
                      code: plan.plans[index].code,
                      interval: plan.plans[index].interval,
                      amount: plan.plans[index].amount,
                    ),
                  ),
                ),
              ),
            )
          : FutureBuilder(
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
                                        title: Text(
                                            subscription.subscription.planName),
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
                                                        subscription
                                                            .subscription
                                                            .nextPaymentDate!,
                                                      ),
                                                    )}',
                                                  ),
                                          ],
                                        ),
                                        trailing: subscription
                                                    .subscription.status ==
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
                                                onTap: () {
                                                  AppUtility.areYouSureDialog(
                                                    context: context,
                                                    prompt:
                                                        "Do you really want to cancel your subscription?",
                                                    yes: () async {
                                                      try {
                                                        final msg =
                                                            await subscription
                                                                .cancelSubscription();

                                                        await subscription
                                                            .checkIsUserSubscribed();

                                                        Navigator.of(context)
                                                            .pop();

                                                        setState(() {
                                                          _isSubscribed =
                                                              subscription
                                                                  .isUserSubscribed!;
                                                        });

                                                        AppUtility
                                                            .showSuccessDialog(
                                                          context: context,
                                                          message: msg,
                                                        );
                                                      } on HttpException catch (e) {
                                                        AppUtility
                                                            .showErrorDialog(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
