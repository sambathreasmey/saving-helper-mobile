import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:saving_helper/controllers/goal_management_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/screen/animated_Invite_banner.dart';
import 'package:saving_helper/screen/create_goal_screen.dart';
import 'package:saving_helper/screen/shop/create_edit_product_screen.dart';
import 'package:saving_helper/screen/widgets/EmptyState.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/widgets/button/base_button.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../../controllers/shop/product_controller.dart';
import '../../models/shop/product_new_feed.dart' as product_new_feed;
import '../../repository/shop/product_repository.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
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
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 150) {
        controller.fetchProducts();
      }
    });
  }

  Future<void> _onRefresh() async {
    // Call the refresh method to reload the data
    controller.fetchProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomHeader(),
                    const SizedBox(height: 16),
                    DynamicBreadcrumbWidget(
                      title: 'គ្រប់គ្រងទំនិញ',
                      subTitle: 'គ្រប់គ្រង',
                      path: 'គ្រប់គ្រងទំនិញ',
                      textColor: themeController.theme.value?.textColor ?? Colors.white,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,  // Set the scroll direction to horizontal
                      child: Row(
                        spacing: 8,
                        children: [
                          BaseButtonWidget(
                            label: 'បន្ថែម',
                            icon: Icons.add,
                            height: 10,
                            weight: 20,
                            fontSize: 14,
                            onPressed: () {
                              controller.clear();
                              Get.to(() => CreateEditProductScreen());
                            },
                          ),
                          BaseButtonWidget(
                            label: 'Assign',
                            icon: Icons.add_link_sharp,
                            height: 10,
                            weight: 20,
                            fontSize: 14,
                            fontFamily: 'MyBaseEnFont',
                            onPressed: () {
                              AnimatedInviteBanner();
                            },
                          ),
                          BaseButtonWidget(
                            label: 'កែប្រែ',
                            icon: Icons.edit_road_rounded,
                            height: 10,
                            weight: 20,
                            fontSize: 14,
                            onPressed: () {
                              print("You're clicked button");
                            },
                          ),
                          BaseButtonWidget(
                            label: 'View',
                            icon: Icons.visibility,
                            height: 10,
                            weight: 20,
                            fontSize: 14,
                            onPressed: () {
                              print("View clicked");
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: Obx(() {
                    if (controller.data.isEmpty && controller.isLoading.value) {
                      return const LoadingIndicator();
                    }
                    if (controller.data.isEmpty) {
                      return EmptyState(message: 'មិនមានប្រតិបត្តិការ');
                    }
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: controller.data.length + (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= controller.data.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final item = controller.data[index];
                          return _buildTransactionTile(context, controller, item, themeController, index);
                        },
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTile(
      BuildContext context,
      ProductController controller,
      product_new_feed.Data txn,
      ThemeController themeController,
      int index,
      ) {
    return Dismissible(
      key: ValueKey(txn.productId ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,

      // ✅ Show OTP confirmation, and remove immediately if confirmed
      // confirmDismiss: (direction) async {
      //   final confirmed = await _showDeleteConfirmationDialog(context, controller);
      //   if (confirmed == true) {
      //     // controller.deleteGoal(txn.groupId!);
      //     controller.data.removeAt(index);
      //     controller.data.refresh();
      //     return true;
      //   }
      //   return false;
      // },

      // ✅ No-op; deletion handled in confirmDismiss
      onDismissed: (_) {},

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                height: 100,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeController.theme.value?.firstControlColor ?? Colors.black,
                      themeController.theme.value?.secondControlColor ?? Colors.black,
                    ],
                  ),
                ),
                child: txn.image != null && txn.image!.isNotEmpty
                    ? Image.network(
                  txn.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                  ),
                )
                    : Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.name ?? 'Unknown Transaction',
                    style: const TextStyle(
                      fontFamily: 'MyBaseFont',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: txn.variant != null && txn.variant!.isNotEmpty
                          ? txn.variant!.map((variant) {
                        // Assuming each variant has 'name' and 'amount' properties
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                margin: const EdgeInsets.symmetric(vertical: 6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent, // Use vibrant colors for the gradient
                                      Colors.purpleAccent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Variant Name
                                    Text(
                                      variant.variantName ?? 'Unknown Variant',
                                      style: const TextStyle(
                                        fontFamily: 'MyBaseFont',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.white, // White text color for better contrast
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    // Price (Amount)
                                    Text(
                                      '${variant.price} ${txn.currencyType}' ?? 'Unknown',
                                      style: const TextStyle(
                                        fontFamily: 'MyBaseFont',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.yellowAccent, // Highlight the price with a contrasting color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                          : [
                        const Text(
                          'No Variants Available',
                          style: TextStyle(
                            fontFamily: 'MyBaseFont',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${txn.price} ${txn.currencyType}",
                    style: const TextStyle(
                      fontFamily: 'MyBaseEnFont',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Edit Button
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey[700]),
              tooltip: "Edit",
              onPressed: () {
                Get.to(() => CreateEditProductScreen(goalToEdit: txn));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Future<bool?> _showDeleteConfirmationDialog(BuildContext context, ProductController controller) async {
//   final themeController = Get.find<ThemeController>();
//   final theme = themeController.theme.value;
//   final isDark = Theme.of(context).brightness == Brightness.dark;
//
//   final backgroundColor =
//   isDark ? theme?.textColor ?? Colors.grey[900] : Colors.white;
//   final textColor =
//       theme?.textColor ?? (isDark ? Colors.white : Colors.black87);
//   final subtitleColor = isDark ? Colors.white70 : Colors.black54;
//   final gradientColors = [
//     theme?.firstControlColor ?? Colors.pinkAccent,
//     theme?.secondControlColor ?? Colors.deepPurpleAccent,
//   ];
//
//   String otp = '';
//   bool showOtpField = false;
//   final otpController = TextEditingController();
//
//   return showDialog<bool>(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return Dialog(
//           backgroundColor: backgroundColor,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20)),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.warning_amber_rounded,
//                     color: gradientColors.first, size: 48),
//                 const SizedBox(height: 16),
//
//                 ShaderMask(
//                   shaderCallback: (bounds) => LinearGradient(
//                     colors: gradientColors,
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
//                   blendMode: BlendMode.srcIn,
//                   child: Text(
//                     showOtpField
//                         ? "OTP Verification" : "Delete Goal?",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.3,
//                       fontFamily: 'MyBaseFont',
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//                 Text(
//                   showOtpField
//                       ? "Enter the OTP sent to your email reasmeysambath@gmail.com to confirm deletion."
//                       : "តើអ្នកប្រាកដថាចង់លុបគម្រោងនេះទេ? សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ។",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: subtitleColor,
//                     height: 1.4,
//                   ),
//                 ),
//
//                 if (showOtpField) ...[
//                   const SizedBox(height: 16),
//                   PinCodeTextField(
//                     appContext: context,
//                     length: 6, // number of digits
//                     controller: otpController,
//                     keyboardType: TextInputType.number,
//                     animationType: AnimationType.fade,
//                     enableActiveFill: true,
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(10),
//                       fieldHeight: 50,
//                       fieldWidth: 40,
//                       activeFillColor: Colors.white,
//                       selectedFillColor: Colors.grey.shade200,
//                       inactiveFillColor: Colors.grey.shade100,
//                       activeColor: Colors.blue,
//                       selectedColor: Colors.deepPurple,
//                       inactiveColor: Colors.grey,
//                     ),
//                     animationDuration: const Duration(milliseconds: 300),
//                     onChanged: (value) {
//                       if (value.trim().length == 6) {
//                         final capturedContext = context; // ✅ capture context safely
//
//                         // Defer async work to avoid async in onChanged directly
//                         Future.microtask(() async {
//                           final otp = value.trim();
//                           final isValid = await controller.verifyOTP(otp);
//
//                           if (!capturedContext.mounted) return; // ✅ safe check
//
//                           if (isValid) {
//                             Navigator.of(capturedContext).pop(true);
//                           } else {
//                             ScaffoldMessenger.of(capturedContext).showSnackBar(
//                               const SnackBar(
//                                 content: Text("❌ Invalid OTP"),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         });
//                       }
//                     },
//                   ),
//                 ],
//
//                 const SizedBox(height: 24),
//
//                 InkWell(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                   onTap: () {
//                     if (!showOtpField) {
//                       setState(() => showOtpField = true);
//                       controller.sendVerifyOTP();
//                     } else {
//                       otp = otpController.text.trim();
//                       if (otp.length == 6) {
//                         final capturedContext = context; // ✅ capture context safely
//
//                         // Defer async work to avoid async in onChanged directly
//                         Future.microtask(() async {
//                           final isValid = await controller.verifyOTP(otp);
//
//                           if (!capturedContext.mounted) return; // ✅ safe check
//
//                           if (isValid) {
//                             Navigator.of(capturedContext).pop(true);
//                           } else {
//                             ScaffoldMessenger.of(capturedContext).showSnackBar(
//                               const SnackBar(
//                                 content: Text("❌ Invalid OTP"),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         });
//                       }
//                     }
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.pink, Colors.red],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       showOtpField ? "Verify OTP" : "Delete",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'MyBaseFont',
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 InkWell(
//                   onTap: () => Navigator.of(context).pop(false),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: gradientColors,
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "Cancel",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'MyBaseFont',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
//     },
//   );
// }

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.grey,));
  }
}

String formatCurrency(double value, {String symbol = '\$ ', int decimalDigits = 2, String locale = 'en_US'}) {
  return NumberFormat.currency(
    symbol: symbol,
    decimalDigits: decimalDigits,
    locale: locale,
  ).format(value);
}