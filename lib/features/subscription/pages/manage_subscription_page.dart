import 'dart:convert';

import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/subscription/pages/payment_page.dart';
import 'package:chat_buddy/models/subscription_model.dart';
import 'package:chat_buddy/models/subscription_plan_model.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/subscription_plan.dart';

class ManageSubscriptionPage extends StatelessWidget {
  static const routeName = '/manage-subscription-page';
  final bool _isSubscribed = false;
  const ManageSubscriptionPage({super.key});

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
      body: Consumer<AuthProvider>(
        builder: (_, user, __) => !user.isSubscribed!
            ? FutureBuilder(
                future: _loadPlans(context),
                builder: (context, _) => Consumer<SubscriptionProvider>(
                  builder: (_, plan, __) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 30),
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
                                      Text(
                                        'Subscription plan name'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        // height: 40,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(subscription
                                                .subscription.planName),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Subscription status'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        // height: 40,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(subscription
                                                .subscription.status),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Next repayment date'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        // height: 40,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: subscription.subscription
                                                        .nextPaymentDate ==
                                                    null
                                                ? const Text('No-date')
                                                : Text(
                                                    DateFormat.MMMMEEEEd()
                                                        .format(
                                                      DateTime.parse(subscription
                                                          .subscription
                                                          .nextPaymentDate!),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      CreditCardWidget(
                                        isChipVisible: false,
                                        isSwipeGestureEnabled: false,
                                        isHolderNameVisible: true,

                                        bankName: subscription.card.bank
                                            .toUpperCase(),
                                        obscureCardNumber: false,
                                        // width: 250,
                                        height: 200,
                                        cardNumber:
                                            '${subscription.card.bin}*******${subscription.card.last4}',
                                        expiryDate:
                                            '${subscription.card.expMonth}/${subscription.card.expYear}',
                                        cardHolderName: subscription
                                            .card.accountName!
                                            .toUpperCase(),
                                        cvvCode: '123',
                                        showBackView:
                                            false, //true when you want to show cvv(back) view
                                        onCreditCardWidgetChange: (_) {},
                                      ),
                                      MyButton(
                                        buttonText: 'Update Subscription Card',
                                        onTap: () {},
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyButton(
                                        buttonText: 'Cancel Subscription',
                                        onTap: () {},
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
      ),
    );
  }
}
