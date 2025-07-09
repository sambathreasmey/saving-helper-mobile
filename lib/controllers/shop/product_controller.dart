import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/requests/product_new_feed_request.dart';
import 'package:saving_helper/repository/shop/product_repository.dart';
import '../../constants/app_color.dart' as app_color;
import '../../models/shop/product_new_feed.dart' as product_new_feed;
import '../../services/share_storage.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;
  ProductController(this.productRepository);

  RxList<product_new_feed.Data> data = RxList<product_new_feed.Data>([]);
  var isLoading = false.obs;
  RxBool hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (isLoading.value) return; // prevent duplicate calls
    if (!hasMore.value && !refresh) return; // no more data unless refreshing

    try {
      isLoading.value = true;
      if (refresh) {
        pageNum = 1;
        hasMore.value = true;
        data.clear();
      }

      final ShareStorage shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();

      var request = ProductNewFeedRequest(
        userId: userId!,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      final response = await productRepository.fetchProductNewFeed(request);

      if (response.status == 0) {
        final newReports = response.data ?? [];
        if (refresh) {
          data.value = newReports;
        } else {
          data.addAll(newReports);
        }
        if (newReports.length < pageSize) {
          hasMore.value = false; // no more pages
        } else {
          pageNum++;
        }
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "Get report failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
      }
    } catch (e) {
      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
    } finally {
      isLoading.value = false;
    }
  }
}