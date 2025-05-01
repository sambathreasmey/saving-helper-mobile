
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/deposit_saving_request.dart';
import 'package:saving_helper/models/result_message_model.dart';
import 'package:saving_helper/services/api_provider.dart';

class DepositSavingRepository {
  final ApiProvider apiProvider;

  DepositSavingRepository(this.apiProvider);

  Future<ResultMessage> depositSaving(DepositSavingRequest depositSavingRequest) async {
    final response = await apiProvider.sendAuthenticatedRequest(
        '/api/saving/deposit',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(depositSavingRequest.toJson()),
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