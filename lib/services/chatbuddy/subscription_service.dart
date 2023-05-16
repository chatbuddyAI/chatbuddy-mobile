import 'dart:async';
import 'dart:convert';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/Auth_model.dart';
import 'package:chat_buddy/models/card_model.dart';
import 'package:chat_buddy/models/subscription_model.dart';
import 'package:chat_buddy/models/subscription_plan_model.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';
import 'package:http/http.dart' as http;

import 'package:chat_buddy/models/user_model.dart';

class SubscriptionService {
  static Future<List<Plan>> getPlans(String token) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse('${BaseAPI.subscriptionRoute}/plans'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    print(responseData['data']);
    final List<Plan> plans = [];
    for (var planData in responseData['data'] as List<dynamic>) {
      final plan = Plan.fromMap(planData);

      plans.add(plan);
    }

    print('ALL PLANS');
    // print(responseData['data']);

    return plans;
  }

  static Future<Subscription> getSubscription(String token) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse(BaseAPI.subscriptionRoute),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('GET USER SUBSCRIPTION');
    print(responseData);

    return Subscription.fromMap(responseData['data']);
  }

  static Future<CardModel> getSubscriptionCard(String token) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse('${BaseAPI.subscriptionRoute}/card'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('GET USER SUBSCRIPTION CARD');
    print(responseData);

    return CardModel.fromMap(responseData['data']);
  }

  static Future subscribe(String token, String planCode) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('${BaseAPI.subscriptionRoute}/subscribe'),
      headers: BaseAPI.headers,
      body: jsonEncode({'planCode': planCode}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    print('SUBSCRIBE');
    print(responseData);

    return responseData['data']['authorization_url'];
  }
}
