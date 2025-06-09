
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/responses/saving_plan_calculate_response.dart';
import 'package:saving_helper/services/api_provider.dart';
import '../constants/app_global.dart' as app_global;

class SavingPlanCalculateRepository {
  final ApiProvider apiProvider;

  SavingPlanCalculateRepository(this.apiProvider);

  Future<SavingPlanCalculateResponse> calculate(double goalAmount, double currentAmount, String startDate, String endDate) async {
    final request = {
      'channel_id': app_global.channelId,
      'goal_amount': goalAmount,
      'current_amount': currentAmount,
      'start_date': startDate,
      'end_date': endDate
    };

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/calculate_saving_plan',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: request,
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return SavingPlanCalculateResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

}