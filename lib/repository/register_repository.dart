import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/register_request.dart';
import 'package:saving_helper/models/responses/login_response.dart';
import 'package:saving_helper/services/api_provider.dart';

class RegisterRepository {
  final ApiProvider apiProvider;

  RegisterRepository(this.apiProvider);

  Future<LoginResponse> register(RegisterRequest request) async {

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/register',
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
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      // Throw an exception with the response body for better debugging
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }
}