import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_helper/models/requests/product_new_feed_request.dart';
import 'package:saving_helper/models/shop/product_new_feed.dart';
import 'package:saving_helper/services/api_provider.dart';

class ProductRepository {
  final ApiProvider apiProvider;

  ProductRepository(this.apiProvider);

  Future<ProductNewFeed> fetchProductNewFeed(ProductNewFeedRequest request) async {

    final response = await apiProvider.sendAuthenticatedRequest(
      '/api/saving/shop_new_feed',
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
      return ProductNewFeed.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get fetchProductNewFeed: ${response.statusCode} - ${response.body}');
    }
  }
}