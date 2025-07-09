import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/screen/widgets/button/base_button.dart';
import '../../controllers/theme_controller.dart';
import '../../models/shop/product_new_feed.dart' as product_new_feed;

class ProductDetailScreen extends StatelessWidget {
  final product_new_feed.Data product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final theme = themeController.theme.value;
    final textColor = Colors.black;
    final backgroundColor = Colors.white;

    // Observable to track selected variant and quantity
    Rx<product_new_feed.Variant> selectedVariant = Rx<product_new_feed.Variant>(product.variant?.first ?? product_new_feed.Variant());
    Rx<int> quantity = Rx<int>(1); // Default quantity is 1

    // Calculate total amount based on selected variant and quantity
    Rx<double> totalAmount = Rx<double>(selectedVariant.value.price != null ? double.parse(selectedVariant.value.price!) * quantity.value : 0);

    // Update total amount when variant or quantity changes
    ever(selectedVariant, (_) {
      totalAmount.value = selectedVariant.value.price != null ? double.parse(selectedVariant.value.price!) * quantity.value : 0;
    });

    ever(quantity, (_) {
      totalAmount.value = selectedVariant.value.price != null ? double.parse(selectedVariant.value.price!) * quantity.value : 0;
    });

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.image ?? '', // Replace with actual image URL
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? 'Unknown Product',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        const SizedBox(height: 12),

                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.redAccent, Colors.red],
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyBaseEnFont',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          product.description ?? "Default Description",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.8),
                            height: 1.6,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Variant Section
                        if (product.variant != null && product.variant!.isNotEmpty)
                          _buildVariantSelection(selectedVariant, quantity),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50, // Bigger size
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme?.firstControlColor ?? Colors.blue,
                        theme?.secondControlColor ?? Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Get.back(),
                    splashRadius: 28,
                  ),
                ),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme?.firstControlColor ?? Colors.blue,
                        theme?.secondControlColor ?? Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                    onPressed: () {
                      Get.snackbar("Wishlist", "Added to wishlist!");
                    },
                    splashRadius: 28,
                  ),
                ),
              ],
            ),
          ),

          // Positioned Buy Button at Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Container(
                  //   height: double.infinity,
                  //   width: 50,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade200,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.favorite_border, color: Colors.red),
                  //     onPressed: () {
                  //       Get.snackbar("Wishlist", "Added to wishlist!");
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  // Total Amount Section
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Total: \$${totalAmount.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BaseButtonWidget(
                      onPressed: () {
                        Get.snackbar("Order", "Proceeding to checkout...");
                      },
                      label: "ទិញឥឡូវនេះ",
                      fontFamily: "MyBaseFont",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSelection(Rx<product_new_feed.Variant> selectedVariant, Rx<int> quantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ជម្រើស (${product.variant!.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont'),
            ),
            Expanded(
                child: _buildQuantitySection(quantity),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: product.variant!.length,
          itemBuilder: (context, index) {
            final variant = product.variant![index];
            return GestureDetector(
              onTap: () {
                selectedVariant.value = variant; // Update selected variant
              },
              child: Obx(
                    () {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedVariant.value == variant
                          ? Colors.blue.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedVariant.value == variant
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          variant.image ?? '',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            variant.variantName ?? 'Unknown Variant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "\$${variant.price}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuantitySection(Rx<int> quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        // Reset Button (to set quantity back to 1)
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(12)
          ),
          child: InkWell(
            onTap: () {
              quantity.value = 1; // Reset quantity to 1
            },
            child: const Icon(Icons.delete, color: Colors.white, size: 18,),
          ),
        ),

        const SizedBox(width: 8),

        // Display the Quantity
        Obx(() {
          return Text(
            "${quantity.value}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'MyBaseEnFont',
            ),
          );
        }),

        const SizedBox(width: 8),

        // Increment Button
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12)
          ),
          child: InkWell(
            onTap: () {
              quantity.value++; // Increase quantity
            },
            child: const Icon(Icons.add, color: Colors.white, size: 18,),
          ),
        ),
      ],
    );
  }


}
