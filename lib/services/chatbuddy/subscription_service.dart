import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/models/card_model.dart';
import 'package:chat_buddy/models/subscription_model.dart';
import 'package:chat_buddy/models/subscription_plan_model.dart';
import 'package:chat_buddy/services/chatbuddy/base_api.dart';

class SubscriptionService {
  static Future<List<Plan>> getPlans(String token) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse('${BaseAPI.subscriptionRoute}/plans'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    if (kDebugMode) {
      print(responseData['data']);
    }
    final List<Plan> plans = [];
    for (var planData in responseData['data'] as List<dynamic>) {
      final plan = Plan.fromMap(planData);

      plans.add(plan);
    }

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

    return responseData['data']['authorization_url'];
  }

  static Future cancelSubscription(
    String token,
  ) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('${BaseAPI.subscriptionRoute}/cancel'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return responseData['message'];
  }

  static Future<bool> isUserSubscribed(
    String token,
  ) async {
    // Send API request
    BaseAPI.headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('${BaseAPI.subscriptionRoute}/is-user-subscribed'),
      headers: BaseAPI.headers,
    );

    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(responseData['message']);
    }

    return responseData['data'];
  }
}
