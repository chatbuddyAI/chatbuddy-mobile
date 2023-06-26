// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/features/subscription/pages/payment_page.dart';
import 'package:chat_buddy/models/subscription_model.dart';
import 'package:chat_buddy/models/subscription_plan_model.dart';
import 'package:chat_buddy/services/chatbuddy/subscription_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class SubscriptionProvider with ChangeNotifier {
  List<Plan> _plans = [];
  late String? authToken;
  late Subscription _subscription;
  late CardModel _card;
  late bool? _isUserSubscribed;

  void update(String? token) {
    authToken = token;
  }

  List<Plan> get plans {
    return [..._plans];
  }

  bool? get isUserSubscribed => _isUserSubscribed;
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

  Future<String> cancelSubscription() async {
    try {
      final msg = await SubscriptionService.cancelSubscription(authToken!);

      return msg;
    } catch (e) {
      rethrow;
    }
  }

  Future checkIsUserSubscribed() async {
    try {
      _isUserSubscribed =
          await SubscriptionService.isUserSubscribed(authToken!);
      if (kDebugMode) {
        print("User is: $_isUserSubscribed");
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
