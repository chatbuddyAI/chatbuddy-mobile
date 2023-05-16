import 'dart:convert';
import 'package:chat_buddy/features/subscription/pages/payment_page.dart';
import 'package:chat_buddy/models/chat_model.dart';
import 'package:chat_buddy/models/message_model.dart';
import 'package:chat_buddy/models/subscription_model.dart';
import 'package:chat_buddy/models/subscription_plan_model.dart';
import 'package:chat_buddy/services/chatbuddy/chat_service.dart';
import 'package:chat_buddy/services/chatbuddy/message_service.dart';
import 'package:chat_buddy/services/chatbuddy/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/home/pages/messages_page.dart';
import '../models/card_model.dart';

class SubscriptionProvider with ChangeNotifier {
  List<Plan> _plans = [];
  late String? authToken;
  late Subscription _subscription;
  late CardModel _card;

  void update(String? token) {
    authToken = token;
  }

  List<Plan> get plans {
    return [..._plans];
  }

  Subscription get subscription => _subscription;
  CardModel get card => _card;

  Future fetchPlans() async {
    try {
      final plans = await SubscriptionService.getPlans(authToken!);

      _plans = plans;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future fetchSubscriptionData() async {
    try {
      final subscription =
          await SubscriptionService.getSubscription(authToken!);

      final card = await SubscriptionService.getSubscriptionCard(authToken!);

      _subscription = subscription;
      _card = card;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future subscribe(BuildContext context, String planCode) async {
    try {
      final paymentUrl =
          await SubscriptionService.subscribe(authToken!, planCode);

      return Navigator.of(context)
          .pushNamed(PaymentPage.routeName, arguments: paymentUrl);
    } catch (e) {
      rethrow;
    }
  }
}
