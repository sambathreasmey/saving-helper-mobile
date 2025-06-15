import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      onRefresh: _onRefresh,  // Trigger refresh when the user pulls down
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: data.length + (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return _buildTransactionTile(context, controller, item, themeController);
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
          color: themeController.theme.value?.textColor?.withOpacity(0.9) ?? Colors.white.withOpacity(0.9),
        ),
        color: themeController.theme.value?.textColor?.withOpacity(0.2) ?? Colors.white.withOpacity(0.5),
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
}

Widget _buildTransactionTile(BuildContext context, controller, GetGoalResponse.Data txn, ThemeController themeController) {
  return Dismissible(
    key: ValueKey(txn.groupId ?? UniqueKey().toString()),
    direction: DismissDirection.endToStart,
    onDismissed: (direction) async {
      // Show a confirmation dialog before deleting
      bool? confirmed = await _showDeleteConfirmationDialog(context);
      if (confirmed ?? false) {
        // Call the controller to delete the goal
        controller.deleteGoal(txn.groupId!);
      }
    },
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  themeController.theme.value?.firstControlColor ?? Colors.black,
                  themeController.theme.value?.secondControlColor ?? Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.grass_outlined, // Icon for transaction (you can change it based on the content)
              color: themeController.theme.value?.textColor ?? Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.groupName ?? 'Unknown Transaction',
                  style: TextStyle(
                    fontFamily: 'MyBaseFont',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  txn.goalAmount.toString(),
                  style: TextStyle(
                    fontFamily: 'MyBaseEnFont',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Are you sure you want to delete this goal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
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