
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/responses/get_owner_response.dart';
import 'package:saving_helper/models/responses/group_member_response.dart';
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
}