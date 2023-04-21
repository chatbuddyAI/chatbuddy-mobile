import 'dart:convert';

import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/subscription/pages/payment_page.dart';
import 'package:chat_buddy/models/subscription_plan_model.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageSubscriptionPage extends StatelessWidget {
  static const routeName = '/manage-subscription-page';
  final bool _isSubscribed = false;
  const ManageSubscriptionPage({super.key});

  Future<void> _loadPlans(BuildContext context) async {
    await Provider.of<SubscriptionProvider>(context, listen: false)
        .fetchPlans();
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
          : SafeArea(
              child: Column(),
            ),
    );
  }
}

class SubscriptionPlan extends StatelessWidget {
  final String name;
  final String code;
  final String interval;
  final int amount;
  const SubscriptionPlan({
    super.key,
    required this.name,
    required this.code,
    required this.interval,
    required this.amount,
  });

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occured!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(child: SizedBox(width: 150, child: Text(name))),
              Text(
                NumberFormat.currency(
                  // locale: 'eu',
                  customPattern: '\u00a4 #,###',
                  symbol: '₦',
                ).format(amount / 100),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        try {
          await Provider.of<SubscriptionProvider>(context, listen: false)
              .subscribe(context, code);
        } on HttpException catch (e) {
          _showErrorDialog(context, e.toString());
        }
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(code),
          ),
        );
      },
    );
  }
}
