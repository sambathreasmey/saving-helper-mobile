
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/responses/get_owner_response.dart';
import 'package:saving_helper/models/responses/group_member_response.dart';
import 'package:saving_helper/models/result_message_model.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/services/share_storage.dart';

class MemberRepository {
  final ApiProvider apiProvider;

  MemberRepository(this.apiProvider);

  Future<GroupMemberResponse> getMember() async {
    final shareStorage = ShareStorage();
    final storedUserId = await shareStorage.getUserCredential();
    final request = {
      'user_id': storedUserId!
    };

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/get_group_member',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request,
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GroupMemberResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResultMessage> deleteMember(request) async {
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/delete_member_by_id',
      method: 'DELETE',
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return ResultMessage.fromJson(json.decode(response.body));
    } else {
      // Throw an exception with the response body for better debugging
      throw Exception('Failed to delete repay loan: ${response.statusCode} - ${response.body}');
    }
  }

}