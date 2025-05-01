import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:saving_helper/services/share_storage.dart';

class ApiProvider {
  final String baseUrl = "http://sambathreasmey1app.pythonanywhere.com";
  final shareStorage = ShareStorage();

  String? _accessToken;
  String? _refreshToken;

  // Save login credentials to auto-login if needed
  final String _savedUsername = 'smey.dev';
  final String _savedPassword = '\$mey@168';

  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/api/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': _refreshToken}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      return true;
    }
    return false;
  }

  Future<bool> _loginJWT() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _savedUsername,
        'password': _savedPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      await shareStorage.saveToken(_accessToken!);
      return true;
    }
    return false;
  }

  Future<http.Response> sendAuthenticatedRequest(String endpoint, {String method = 'GET', Map<String, String>? headers, dynamic body}) async {
    if ( _accessToken == null ) {
      _accessToken = await shareStorage.getToken();
      if ( _accessToken == null ) {
        if (kDebugMode) {
          print('✅ accessToken is null then call to login JWT 🔐');
        }
        await _loginJWT();
      }
    }
    headers ??= {};
    headers['Authorization'] = 'Bearer $_accessToken';

    http.Response response = await _sendRequest(endpoint, method, headers, body);

    if (response.statusCode == 401) {
      if (kDebugMode) {
        print('🔄 call to refreshToken 🔄');
      }
      bool refreshSuccess = await _refreshAccessToken();

      if (!refreshSuccess) {
        bool loginSuccess = await _loginJWT();
        if (!loginSuccess) {
          throw Exception("Failed to re-authenticate");
        }
      }

      headers['Authorization'] = 'Bearer $_accessToken';
      response = await _sendRequest(endpoint, method, headers, body);
    }
    return response;
  }

  Future<http.Response> _sendRequest(String endpoint, String method, Map<String, String> headers, dynamic body) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(uri, headers: headers, body: body);
      case 'PUT':
        return await http.put(uri, headers: headers, body: body);
      case 'DELETE':
        return await http.delete(uri, headers: headers, body: body);
      case 'GET':
      default:
        return await http.get(uri, headers: headers);
    }
  }
}

