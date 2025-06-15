import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/DeleteTransactionRequest.dart';
import 'package:saving_helper/models/requests/create_goal_request.dart';
import 'package:saving_helper/models/requests/delete_repay_loan_request.dart';
import 'package:saving_helper/models/requests/get_goal_request.dart';
import 'package:saving_helper/models/requests/get_report_request.dart';
import 'package:saving_helper/models/requests/repay_loan_request.dart';
import 'package:saving_helper/models/responses/get_report_response.dart';
import 'package:saving_helper/services/api_provider.dart';

import '../models/responses/get_goal_response.dart';
import '../models/result_message_model.dart';

class GoalManagementRepository {
  final ApiProvider apiProvider;

  GoalManagementRepository(this.apiProvider);

  Future<GetGoalResponse> getGoals(GetGoalRequest getGoalRequest) async {

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/get_goals',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: getGoalRequest.toJson(),
    );

    // Log the response status code and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GetGoalResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get dashboard: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResultMessage> createGoal(CreateGoalRequest request) async {
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/create_goal',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
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
      throw Exception('Failed to repay loan: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResultMessage> deleteGoal(int groupId, String userId) async {
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/delete_goal',
      method: 'DELETE',
      headers: {'Content-Type': 'application/json'},
      body: {
        'group_id': groupId,
        'user_id': userId
      },
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
      throw Exception('Failed to delete repay loan: ${response.statusCode} - ${response.body}');
    }
  }
}