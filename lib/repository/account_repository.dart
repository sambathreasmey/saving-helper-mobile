import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/update_user_email_request.dart';
import 'package:saving_helper/models/requests/update_user_full_name_request.dart';
import 'package:saving_helper/models/result_message_model.dart';
import 'package:saving_helper/services/api_provider.dart';

class AccountRepository {
  final ApiProvider apiProvider;

  AccountRepository(this.apiProvider);

  Future<ResultMessage> updateUserFullName(UpdateUserFullNameRequest request) async {
    // Adjust path/method to match your backend route
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/update_user_full_name',
      method: 'PUT',
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
      throw Exception('Failed to update full name: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResultMessage> updateUserEmail(UpdateUserEmailRequest request) async {
    // Adjust path/method to match your backend route
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/update_user_email',
      method: 'PUT',
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
      throw Exception('Failed to update email: ${response.statusCode} - ${response.body}');
    }
  }
}
