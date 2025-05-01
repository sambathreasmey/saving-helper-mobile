

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/delete_repay_loan_request.dart';
import 'package:saving_helper/models/requests/get_report_request.dart';
import 'package:saving_helper/models/requests/repay_loan_request.dart';
import 'package:saving_helper/models/responses/get_report_response.dart';
import 'package:saving_helper/services/api_provider.dart';

import '../models/result_message_model.dart';

class ReportRepository {
  final ApiProvider apiProvider;

  ReportRepository(this.apiProvider);

  Future<GetReportResponse> getReport(GetReportRequest getReportRequest) async {

    final response = await apiProvider.sendAuthenticatedRequest(
        '/api/saving/transaction_detail',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(getReportRequest.toJson()),
    );

    // Log the response status code and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return GetReportResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get dashboard: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ResultMessage> repayLoan(RepayLoanRequest repayLoanRequest) async {
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/repay_loan',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(repayLoanRequest.toJson()),
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

  Future<ResultMessage> deleteRepayLoan(DeleteRepayLoanRequest repayLoanRequest) async {
    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/delete_repay_loan_by_id',
      method: 'DELETE',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(repayLoanRequest.toJson()),
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