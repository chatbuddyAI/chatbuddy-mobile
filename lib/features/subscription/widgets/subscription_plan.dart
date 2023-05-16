import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/subscription_provider.dart';

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
      },
    );
  }
}
