
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/get_user_info_request.dart';
import 'package:saving_helper/models/responses/get_owner_response.dart';
import 'package:saving_helper/models/responses/get_user_info_response.dart';
import 'package:saving_helper/models/responses/invite_user_response.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/services/share_storage.dart';

class InviteRepository {
  final ApiProvider apiProvider;

  InviteRepository(this.apiProvider);

  Future<GetOwnerGroupResponse> getOwnerGroup() async {
    final shareStorage = ShareStorage();
    final storedUserId = await shareStorage.getUserCredential();
    final request = {
      'user_id': storedUserId!
    };

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/get_owner_group',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request,
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GetOwnerGroupResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

  Future<GetUserInfoResponse> findUserByUsername(String userName) async {
    final notificationRequest = GetUserInfoRequest(
      channelId: 'sambathreasmey',
      par: userName,
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

  Future<InviteUserResponse> inviteUser(String userId, String groupId) async {
    final shareStorage = ShareStorage();
    final storedUserId = await shareStorage.getUserCredential();
    final request = {
      'user_id': userId,
      'group_id': groupId,
      'role': 'reporter',
      "invited_by": storedUserId
    };

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/assign_user_to_group',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request,
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return InviteUserResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

}