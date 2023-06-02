import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/subscription_provider.dart';

class SubscriptionPlan extends StatelessWidget {
  final String name;
  final String interval;
  final int amount;
  final Function()? onTap;
  const SubscriptionPlan({
    super.key,
    required this.name,
    required this.interval,
    required this.amount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
    );
  }
}
