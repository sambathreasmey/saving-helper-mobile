import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/requests/create_goal_request.dart';
import 'package:saving_helper/models/requests/get_goal_request.dart';
import 'package:saving_helper/models/requests/update_goal_request.dart';
import 'package:saving_helper/repository/goal_management_repository.dart';
import 'package:saving_helper/screen/goal_management_screen.dart';
import 'package:saving_helper/screen/home_screen.dart';
import '../constants/app_color.dart' as app_color;
import '../models/responses/get_goal_response.dart' as GetSummaryReportResponse;
import '../services/share_storage.dart';

class GoalManagementController extends GetxController {
  final GoalManagementRepository goalManagementRepository;
  GoalManagementController(this.goalManagementRepository);

  RxList<GetSummaryReportResponse.Data> data = RxList<GetSummaryReportResponse.Data>([]);
  RxString selectedTransactionType = "".obs;
  var isLoading = false.obs;
  RxBool hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 10;

  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController goalNameController = TextEditingController();
  bool isEditMode = false;
  String? editingGoalId;

  @override
  void onInit() {
    super.onInit();
    fetchGoals();
  }

  void clear() {
    goalAmountController.clear();
    goalNameController.clear();
    editingGoalId = null;
    isEditMode = false;
  }

  Future<void> fetchGoals({bool refresh = false}) async {
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

      var request = GetGoalRequest(
        userId: userId!,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      final response = await goalManagementRepository.getGoals(request);

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

  void initializeWithGoal(GetSummaryReportResponse.Data goal) {
    goalNameController.text = goal.groupName ?? '';
    goalAmountController.text = goal.goalAmount?.toString() ?? '';
    isEditMode = true;
    editingGoalId = goal.groupId.toString() ?? "";
  }

  void submitGoal() {
    if (isEditMode && editingGoalId != null) {
      updateGoal();
    } else {
      createGoal();
    }
  }

  Future<void> createGoal() async {
    isLoading.value = true;
    try {
      final ShareStorage shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();
      final parsed = double.tryParse(goalAmountController.text);
      var request = CreateGoalRequest(
        userId: userId!,
        goalAmount: parsed ?? 0.0,
        goalName: goalNameController.text
      );
      final response = await goalManagementRepository.createGoal(request);

      if (response.status == 0) {
        Get.snackbar(
          "ជោគជ័យ",
          response.message ?? "បានគណនារួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
        clear();
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "បរាជ័យក្នុងការគណនា",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "មានបញ្ហា",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGoal() async {
    isLoading.value = true;
    try {
      final ShareStorage shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();
      final parsed = double.tryParse(goalAmountController.text);
      var request = UpdateGoalRequest(
          userId: userId!,
          groupId: editingGoalId,
          goalAmount: parsed ?? 0.0,
          goalName: goalNameController.text
      );
      final response = await goalManagementRepository.updateGoal(request);

      if (response.status == 0) {
        Get.snackbar(
          "ជោគជ័យ",
          response.message ?? "បានគណនារួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
        clear();
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "បរាជ័យក្នុងការគណនា",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "មានបញ្ហា",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGoal(int groupId) async {
    isLoading.value = true;
    try {
      final ShareStorage shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();
      final response = await goalManagementRepository.deleteGoal(groupId, userId!);

      if (response.status == 0) {
        Get.snackbar(
          "ជោគជ័យ",
          response.message ?? "បានគណនារួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "បរាជ័យក្នុងការគណនា",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "មានបញ្ហា",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

}