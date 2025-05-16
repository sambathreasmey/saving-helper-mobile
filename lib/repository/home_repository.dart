

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/get_dashboard_request.dart';
import 'package:saving_helper/models/responses/get_dashboard_response.dart';
import 'package:saving_helper/services/api_provider.dart';

class HomeRepository {
  final ApiProvider apiProvider;

  HomeRepository(this.apiProvider);

  Future<GetDashboardResponse> getDashboard(GetDashboardRequest getDashboardRequest) async {
    final response = await apiProvider.sendAuthenticatedRequest(
        '/api/saving/dashboard',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
      body: getDashboardRequest.toJson(),
    );

    // Log the response status code and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GetDashboardResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get dashboard: ${response.statusCode} - ${response.body}');
    }
  }

}