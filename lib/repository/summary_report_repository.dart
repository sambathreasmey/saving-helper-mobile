

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/get_summary_report_request.dart';
import 'package:saving_helper/models/responses/get_summary_report_response.dart';
import 'package:saving_helper/services/api_provider.dart';

class SummaryReportRepository {
  final ApiProvider apiProvider;

  SummaryReportRepository(this.apiProvider);

  Future<GetSummaryReportResponse> getSummaryReport(GetSummaryReportRequest getReportRequest) async {

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/summary_report',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: getReportRequest.toJson(),
    );

    // Log the response status code and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GetSummaryReportResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get dashboard: ${response.statusCode} - ${response.body}');
    }
  }

}