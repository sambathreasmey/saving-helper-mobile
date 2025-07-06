import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/screen/widgets/button/base_button.dart';
import '../../controllers/theme_controller.dart';
import '../../models/responses/get_goal_response.dart' as GetSummaryReportResponse;

class ProductDetailScreen extends StatelessWidget {
  final GetSummaryReportResponse.Data product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    final theme = themeController.theme.value;
    final textColor = Colors.black;
    final backgroundColor = Colors.white;
    final gradientColors = [
      theme?.firstControlColor ?? Colors.blue,
      theme?.secondControlColor ?? Colors.purple,
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Background Image
          Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://img.alicdn.com/bao/uploaded/i2/1870919581/O1CN01kYGZJs2Ke9lEQnBoi_!!1870919581.jpg_460x460q90.jpg_.webp', // Replace with actual image URL
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
                        // 📝 Product Name
                        Text(
                          product.groupName ?? 'Unknown Product',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 💵 Price
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.redAccent, Colors.red],
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            "\$${product.goalAmount?.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyBaseEnFont',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 📜 Description
                        Text(
                          "ចូលមើលហើយ ទិញអត់ហ្នឹង ?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.8),
                            height: 1.6,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 🌟 Ratings & Sold
                        Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontFamily: 'MyBaseEnFont',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "• Sold 3.2k",
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.6),
                                fontFamily: 'MyBaseEnFont',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100), // Spacer for bottom bar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 🧭 AppBar with Back & Favorite Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔙 Back Button (Enhanced Size)
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24), // Bigger icon
                    onPressed: () => Get.back(),
                    splashRadius: 28, // Matches larger circle
                  ),
                ),

                // ❤️ Favorite Button (Enhanced Size)
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
                    icon: const Icon(Icons.favorite_border, color: Colors.white, size: 24), // Bigger icon
                    onPressed: () {
                      Get.snackbar("Wishlist", "Added to wishlist!");
                    },
                    splashRadius: 28, // Matches larger circle
                  ),
                ),
              ],
            ),
          ),

          // 🛒 Floating Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  // 🖤 Favorite Button
                  Container(
                    height: double.infinity,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        Get.snackbar("Wishlist", "Added to wishlist!");
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 🛒 Add to Cart
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Get.snackbar("Cart", "Added to cart!");
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       backgroundColor: gradientColors.first,
                  //       foregroundColor: Colors.white,
                  //     ),
                  //     child: const Text(
                  //       "Add to Cart",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600,
                  //         fontFamily: 'MyBaseEnFont',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // ⚡ Buy Now
                  Expanded(
                    child: BaseButtonWidget(
                      onPressed: () {
                        Get.snackbar("Order", "Proceeding to checkout...");
                      },
                      label: "Buy Now",
                      fontFamily: "MyBaseEnFont",
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
}
