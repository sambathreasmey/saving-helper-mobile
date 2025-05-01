import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/responses/login_response.dart';
import 'package:saving_helper/services/api_provider.dart';

class LoginRepository {
  final ApiProvider apiProvider;

  LoginRepository(this.apiProvider);

  Future<LoginResponse> login(String username, String password) async {

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/partner/user_login',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_name': username,
        'password': password,
        'channel_id': 'sambathreasmey',
      }),
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