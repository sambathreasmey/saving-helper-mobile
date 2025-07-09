import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/shop/product_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/shop/product_repository.dart';
import 'package:saving_helper/screen/shop/ProductCard.dart';
import 'package:saving_helper/screen/shop/ProductDetailScreen.dart';
import 'package:saving_helper/screen/shop/widgets/ShimmerGridLoader.dart';
import 'package:saving_helper/screen/widgets/EmptyState.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

class ProductFeedScreen extends StatefulWidget {
  const ProductFeedScreen({super.key});

  @override
  State<ProductFeedScreen> createState() => _ProductFeedScreenState();
}

class _ProductFeedScreenState extends State<ProductFeedScreen> {
  final ProductController controller = Get.put(
      ProductController(ProductRepository(ApiProvider()))
  );
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchProducts(refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150) {
        controller.fetchProducts();
      }
    });
  }

  Future<void> _onRefresh() async {
    controller.fetchProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Obx(() {
                  if (controller.isLoading.value && controller.data.isEmpty) {
                    // ✅ Show shimmer while loading
                    return const ShimmerGridLoader();
                  }
                  if (controller.data.isEmpty) {
                    return const EmptyState(message: 'No products found');
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.data.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= controller.data.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final product = controller.data[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Shop Products",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'MyBaseEnFont',
              color: themeController.theme.value?.textColor ?? Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                color: themeController.theme.value?.textColor ?? Colors.black),
            onPressed: () {
              Get.snackbar("Cart", "Go to your shopping cart");
            },
          ),
        ],
      ),
    );
  }
}