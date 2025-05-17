
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/get_user_info_request.dart';
import 'package:saving_helper/models/requests/notification_request.dart';
import 'package:saving_helper/models/responses/get_user_info_response.dart';
import 'package:saving_helper/models/result_message_model.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/services/share_storage.dart';

class HeaderRepository {
  final ApiProvider apiProvider;

  HeaderRepository(this.apiProvider);

  Future<GetUserInfoResponse> getUserInfo() async {
    final shareStorage = ShareStorage();
    final storedUserId = await shareStorage.getUserCredential();
    final notificationRequest = GetUserInfoRequest(
      channelId: 'sambathreasmey',
      par: storedUserId!,
    );

    final response = await apiProvider.sendAuthenticatedRequest(
        '/api/saving/get_user_by_username_or_id',
        method: 'GET',
        headers: {'Content-Type': 'application/json'},
        body: notificationRequest.toJson(),
    );

    // Log the response status code and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GetUserInfoResponse.fromJson(json.decode(response.body));
    } else {
      // Throw an exception with the response body for better debugging
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResultMessage> notification() async {
    final shareStorage = ShareStorage();
    final groupId = await shareStorage.getGroupId();
    final notificationRequest = NotificationRequest(
      channelId: 'sambathreasmey',
      groupId: groupId!,
    );

    final response = await apiProvider.sendAuthenticatedRequest(
        '/api/saving/notification',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: notificationRequest.toJson(),
    );

    // Log the response status code and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return ResultMessage.fromJson(json.decode(response.body));
    } else {
      // Throw an exception with the response body for better debugging
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }
}