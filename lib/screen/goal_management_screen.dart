import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/controllers/goal_management_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/goal_management_repository.dart';
import 'package:saving_helper/screen/animated_Invite_banner.dart';
import 'package:saving_helper/screen/create_goal_screen.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/widgets/button/base_button.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/widgets/progress/CircleProgressCompament.dart';
import 'package:saving_helper/screen/widgets/progress/LineProgressComponent.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/app_color.dart' as app_colors;
import '../models/responses/get_goal_response.dart' as GetGoalResponse;

class GoalManagementScreen extends StatefulWidget {
  const GoalManagementScreen({super.key});

  @override
  _GoalManagementScreenState createState() => _GoalManagementScreenState();
}

class _GoalManagementScreenState extends State<GoalManagementScreen> {
  final GoalManagementController controller = Get.put(GoalManagementController(GoalManagementRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchGoals(refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 150) {
        controller.fetchGoals();
      }
    });
  }

  Future<void> _onRefresh() async {
    // Call the refresh method to reload the data
    controller.fetchGoals(refresh: true);
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
                      title: 'គម្រោងសន្សំប្រាក់',
                      subTitle: 'គ្រប់គ្រង',
                      path: 'គម្រោងសន្សំប្រាក់',
                      textColor: themeController.theme.value?.textColor ?? Colors.white,
                    ),
                    const SizedBox(height: 16),
                    totalGroupComponent(context),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,  // Set the scroll direction to horizontal
                      child: Row(
                        spacing: 8,
                        children: [
                          BaseButtonWidget(
                            backgroundColors: [
                              themeController.theme.value?.firstControlColor ?? Colors.white,
                              themeController.theme.value?.secondControlColor ?? Colors.white
                            ],
                            label: 'បន្ថែម',
                            icon: Icons.add,
                            height: 10,
                            weight: 20,
                            fontSize: 14,
                            onPressed: () {
                              Get.to(() => CreateGoalScreen());
                            },
                          ),
                          BaseButtonWidget(
                            backgroundColors: [
                              themeController.theme.value?.firstControlColor ?? Colors.white,
                              themeController.theme.value?.secondControlColor ?? Colors.white
                            ],
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
                            backgroundColors: [
                              themeController.theme.value?.firstControlColor ?? Colors.white,
                              themeController.theme.value?.secondControlColor ?? Colors.white
                            ],
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
                            backgroundColors: [
                              themeController.theme.value?.firstControlColor ?? Colors.white,
                              themeController.theme.value?.secondControlColor ?? Colors.white
                            ],
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
                      return EmptyState();
                    }

                    final data = controller.data;

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

  Widget totalGroupComponent(BuildContext context) {
    final totalGoal = 1000.0;
    final currentProgress = 700.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeController.theme.value?.textColor ?? Colors.white.withOpacity(0.9),
        ),
        color: themeController.theme.value?.textColor?.withOpacity(0.1) ?? Colors.white.withOpacity(0.5),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    themeController.theme.value?.firstControlColor ?? Colors.white,
                    themeController.theme.value?.secondControlColor ?? Colors.white
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'Goal Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MyBaseEnFont',
                    foreground: Paint(),
                  ),
                ),
              ),
              LineProgressComponent(
                totalGoal: totalGoal,
                currentProgress: currentProgress,
                progressColors: [
                  themeController.theme.value?.firstControlColor ?? Colors.black,
                  themeController.theme.value?.secondControlColor ?? Colors.black,
                ],
                backgroundColor: Colors.white,
                width: 220,
                progressTitleColor: Colors.white,
              ),
              LineProgressComponent(
                totalGoal: totalGoal + 1100,
                currentProgress: currentProgress,
                progressColors: [
                  Colors.pinkAccent,
                  Colors.orangeAccent,
                ],
                backgroundColor: Colors.white,
                width: 220,
                progressTitleColor: Colors.white,
              ),
            ],
          ),
          CircleProgressComponent(
            progressTitleColor: Colors.white,
            totalGoal: totalGoal + 1100,
            currentProgress: currentProgress,
            progressColors: [
              themeController.theme.value?.firstControlColor ?? Colors.black,
              themeController.theme.value?.secondControlColor ?? Colors.black,
            ],
            size: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
      BuildContext context,
      GoalManagementController controller,
      GetGoalResponse.Data txn,
      ThemeController themeController,
      int index,
      ) {
    return Dismissible(
      key: ValueKey(txn.groupId ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,

      // ✅ Show OTP confirmation, and remove immediately if confirmed
      confirmDismiss: (direction) async {
        final confirmed = await _showDeleteConfirmationDialog(context);
        if (confirmed == true) {
          controller.deleteGoal(txn.groupId!);
          controller.data.removeAt(index);
          controller.data.refresh();
          return true;
        }
        return false;
      },

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
            Container(
              height: 60,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    themeController.theme.value?.firstControlColor ?? Colors.black,
                    themeController.theme.value?.secondControlColor ?? Colors.black,
                  ],
                ),
              ),
              child: Icon(
                Icons.grass_outlined,
                color: themeController.theme.value?.textColor ?? Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.groupName ?? 'Unknown Transaction',
                    style: const TextStyle(
                      fontFamily: 'MyBaseFont',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    txn.goalAmount.toString(),
                    style: const TextStyle(
                      fontFamily: 'MyBaseEnFont',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
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
                Get.to(() => CreateGoalScreen(goalToEdit: txn));
              },
            ),
          ],
        ),
      ),
    );
  }

}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
  final themeController = Get.find<ThemeController>();
  final theme = themeController.theme.value;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final backgroundColor =
  isDark ? theme?.textColor ?? Colors.grey[900] : Colors.white;
  final textColor =
      theme?.textColor ?? (isDark ? Colors.white : Colors.black87);
  final subtitleColor = isDark ? Colors.white70 : Colors.black54;
  final gradientColors = [
    theme?.firstControlColor ?? Colors.pinkAccent,
    theme?.secondControlColor ?? Colors.deepPurpleAccent,
  ];

  String otp = '';
  bool showOtpField = false;
  final otpController = TextEditingController();

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: gradientColors.first, size: 48),
                const SizedBox(height: 16),

                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    "Delete Goal?",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      fontFamily: 'MyBaseFont',
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  showOtpField
                      ? "Enter the OTP sent to your number to confirm deletion."
                      : "តើអ្នកប្រាកដថាចង់លុបគម្រោងនេះទេ? សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ។",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),

                if (showOtpField) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "OTP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                InkWell(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  onTap: () {
                    if (!showOtpField) {
                      setState(() => showOtpField = true);
                      // Optional: trigger OTP send here
                    } else {
                      otp = otpController.text.trim();
                      if (otp == "123456") {
                        Navigator.of(context).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid OTP")),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      showOtpField ? "Verify OTP" : "Delete",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MyBaseFont',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'MyBaseFont',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.grey,));
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'មិនមានប្រតិបត្តិការ',
        style: TextStyle(
          fontFamily: 'MyBaseFont',
          color: app_colors.subTitleText,
        ),
      ),
    );
  }
}

String formatCurrency(double value, {String symbol = '\$ ', int decimalDigits = 2, String locale = 'en_US'}) {
  return NumberFormat.currency(
    symbol: symbol,
    decimalDigits: decimalDigits,
    locale: locale,
  ).format(value);
}