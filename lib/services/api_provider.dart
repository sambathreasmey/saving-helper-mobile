import 'dart:convert';
import 'dart:io';
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

  Future<http.Response> _sendRequest(
      String endpoint,
      String method,
      Map<String, String> headers,
      dynamic body,
      ) async {
    Uri uri;
    if (method.toUpperCase() == 'GET' && body is Map<String, dynamic>) {
        final queryParams = body.map(
              (key, value) => MapEntry(key, value?.toString() ?? ''),
        );
      uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    } else {
      uri = Uri.parse('$baseUrl$endpoint');
    }

    // Encode body for JSON requests if needed
    String? encodedBody;
    if (body != null && method.toUpperCase() != 'GET') {
      if (headers['Content-Type']?.contains('application/json') ?? false) {
        encodedBody = jsonEncode(body);
      } else {
        encodedBody = body.toString(); // fallback
      }
    }

    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(uri, headers: headers, body: encodedBody);
      case 'PUT':
        return await http.put(uri, headers: headers, body: encodedBody);
      case 'DELETE':
        return await http.delete(uri, headers: headers, body: encodedBody);
      case 'GET':
      default:
        return await http.get(uri, headers: headers);
    }
  }

  Future<http.Response> uploadImageWithAuth({
    required String endpoint,
    required File imageFile,
    Map<String, String>? fields,
    String fieldName = 'file', // commonly 'image' or 'file'
  }) async {
    // Ensure access token
    if (_accessToken == null) {
      _accessToken = await shareStorage.getToken();
      if (_accessToken == null) {
        if (kDebugMode) {
          print('✅ accessToken is null then call to login JWT 🔐');
        }
        await _loginJWT();
      }
    }

    // Create multipart request
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_accessToken';

    // Attach file
    request.files.add(
      await http.MultipartFile.fromPath(fieldName, imageFile.path),
    );

    // Attach additional fields if any
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Send
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // If unauthorized, try refresh and retry
    if (response.statusCode == 401) {
      if (kDebugMode) {
        print('🔄 Token expired, attempting refresh...');
      }

      bool refreshSuccess = await _refreshAccessToken();
      if (!refreshSuccess && !await _loginJWT()) {
        throw Exception("Authentication failed");
      }

      // Retry with new token
      final retryRequest = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $_accessToken'
        ..files.add(await http.MultipartFile.fromPath(fieldName, imageFile.path));

      if (fields != null) {
        retryRequest.fields.addAll(fields);
      }

      final retryStreamed = await retryRequest.send();
      return await http.Response.fromStream(retryStreamed);
    }

    return response;
  }


}

