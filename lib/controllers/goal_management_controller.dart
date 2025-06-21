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

  Future<void> sendVerifyOTP() async {
    isLoading.value = true;
    try {
      final ShareStorage shareStorage = ShareStorage();
      final user = await shareStorage.getUser();
      final String? email = user!.email;
      final String subject = "[Helper Mobile] Verification Code";
      final String body = '''
                          <html>
                            <body style="margin:0; padding:0; background-color:#f4f8fb; font-family:Arial,sans-serif;">
                              <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td align="center" style="padding:40px 0;">
                                    <table width="480" cellpadding="0" cellspacing="0" style="background:#ffffff; border-radius:12px; box-shadow:0 4px 16px rgba(0,0,0,0.05); overflow:hidden;">
                                      <tr>
                                        <td style="background-color:#00b894; padding:20px; text-align:center; color:white;">
                                          <h2 style="margin:0; font-size:20px;">🔐 Verification Code</h2>
                                          <p style="margin:5px 0 0; font-size:14px; opacity:0.85;">Saving Helper Security</p>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td style="padding:30px; text-align:left;">
                                          <p style="margin-top:0;">Dear Sambath Reasmey,</p>
                                          <p>
                                            We received a request to verify your <strong>Saving Helper</strong> account associated with
                                            <a href="mailto:reasmeysambath@gmail.com">reasmeysambath@gmail.com</a>.
                                          </p>
                                          <div style="margin:30px 0; text-align:center;">
                                            <span style="display:inline-block; padding:16px 32px; background-color:#ecfdf5; color:#00b894; font-size:28px; font-weight:bold; border:2px dashed #00b894; border-radius:8px; letter-spacing:4px;">
                                              049332
                                            </span>
                                          </div>
                                          <p>
                                            If you did not request this code, someone else may be trying to access your account.
                                            Do <strong>not share this code</strong> with anyone.
                                          </p>
                                          <p style="margin-top:40px;">
                                            Stay safe,<br>
                                            <strong>The Saving Helper Team</strong>
                                          </p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </body>
                          </html>
                          ''';
      final response = await goalManagementRepository.sendVerifyOTP(email, subject, body );

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