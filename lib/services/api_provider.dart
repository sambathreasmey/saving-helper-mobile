// lib/providers/api_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl = "http://sambathreasmey1app.pythonanywhere.com"; // Replace with your API base URL

  // final String baseUrl = "http://172.16.1.15:5000"; // Replace with your API base URL

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    String username = 'smey.dev';
    String password = '\$mey@168'; // Ensure this is the correct password

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
      },
      body: json.encode(data),
    );

    // Log the response status and body for debugging
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
    }
    if (kDebugMode) {
      print('Response body: ${response.body}');
    }

    return response;
  }
}