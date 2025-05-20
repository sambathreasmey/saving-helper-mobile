
import 'dart:convert';
import 'dart:io';

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
        body: depositSavingRequest.toJson(),
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

  Future<ResultMessage> uploadDocumentImage(File imageFile, {String fieldName = 'file'}) async {
    final response = await apiProvider.uploadImageWithAuth(
      endpoint: '/api/saving/upload',
      imageFile: imageFile,
      fieldName: fieldName,
      fields: {
        'documentType': 'identity',
      },
    );

    // Debug logging
    if (kDebugMode) {
      print('Upload status: ${response.statusCode}');
      print('Upload response: ${response.body}');
    }

    if (response.statusCode == 200) {
      return ResultMessage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to upload document: ${response.statusCode} - ${response.body}');
    }
  }

}