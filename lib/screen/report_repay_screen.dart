import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/controllers/report_repay_controller.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:get/get.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/app_color.dart' as app_colors;

class ReportRepayScreen extends StatefulWidget {
  const ReportRepayScreen({super.key});

  @override
  _ReportRepayScreenState createState() => _ReportRepayScreenState();
}

class _ReportRepayScreenState extends State<ReportRepayScreen> {
  late final ReportRepayController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReportRepayController(ReportRepository(ApiProvider())));
    controller.selectedTransactionType.value = 'loan';
    controller.fetchTransactions();
  }

  @override
  void dispose() {
    Get.delete<ReportController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Custom Header
                  CustomHeader(),
                  SizedBox(height: 20),

                  // Title Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'របាយការណ៍',
                          style: TextStyle(
                            color: app_colors.baseWhiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'របាយការណ៍ / ',
                              style: TextStyle(
                                color: app_colors.subTitleText,
                                fontSize: 10,
                                fontFamily: 'MyBaseFont',
                              ),
                            ),
                            Text(
                              'កម្ចី',
                              style: TextStyle(
                                color: app_colors.baseWhiteColor,
                                fontSize: 10,
                                fontFamily: 'MyBaseFont',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Loading Indicator
                  Obx(() => controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink()),

                  // Transaction Table or Message
                  Expanded(
                    child: Obx(() {
                      if (controller.reports.isEmpty) {
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
                      return ListView.builder(
                        itemCount: controller.reports.length,
                        itemBuilder: (context, index) {
                          final txn = controller.reports[index];
                          if (txn == null || txn.isCompleted!) return SizedBox.shrink();

                          return Container(
                            margin: EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              border: Border.all(color: Colors.white10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${txn.amount}",
                                        style: TextStyle(
                                          fontFamily: 'MyBaseFont',
                                          fontSize: 18,
                                          color: app_colors.baseWhiteColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: app_colors.background.withOpacity(0.1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "-${txn.remainDate} ថ្ងៃ",
                                            style: TextStyle(
                                              fontFamily: 'MyBaseFont',
                                              fontSize: 10,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${txn.transactionDesc} - ${txn.transactionType}",
                                        style: TextStyle(
                                          fontFamily: 'MyBaseFont',
                                          fontSize: 11,
                                          color: app_colors.baseWhiteColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "${txn.transactionDate}",
                                      style: TextStyle(
                                        fontFamily: 'MyBaseFont',
                                        fontSize: 11,
                                        color: app_colors.subTitleText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                onTap: () {
                                  final TextEditingController amountController = TextEditingController();
                                  final TextEditingController reasonController = TextEditingController();
                                  final txnHistory = txn.repayLoanDetails ?? [];

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Color(0xFF1E1E2E), // Dark base
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "សងប្រាក់លំអិត",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'MyBaseFont',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      icon: Icon(Icons.close_rounded, size: 28,),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 16),

                                                _darkInfo("ចំនួនកម្ចី", "\$${txn.amount}"),
                                                _darkInfo("ទឹកប្រាក់ជំពាក់", "-\$${txn.remainBalance ?? 0.0}", color: Colors.redAccent),
                                                _darkInfo("ថ្ងៃខ្ចី", "${txn.transactionDate}"),
                                                _darkInfo("មូលហេតុ", "${txn.transactionDesc}"),
                                                _darkInfo("រយះពេល", "${txn.remainDate} ថ្ងៃ", color: Colors.redAccent),

                                                Divider(color: Colors.white10, height: 30),

                                                Text(
                                                  "ប្រវត្តិសងប្រាក់",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily: 'MyBaseFont',
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                txnHistory.isEmpty
                                                    ? Text("ពុំមានប្រតិបត្តិការសង់ប្រាក់",
                                                    style: TextStyle(color: Colors.grey, fontFamily: 'MyBaseFont'))
                                                    : SizedBox(
                                                  height: 3 * 72, // Estimated height for 5 rows (each row about 72px including margin+padding)
                                                  child: ListView.builder(
                                                    physics: BouncingScrollPhysics(), // Make it scrollable
                                                    itemCount: txnHistory.length,
                                                    itemBuilder: (context, index) {
                                                      final h = txnHistory[index];
                                                      return InkWell(
                                                        borderRadius: BorderRadius.circular(8),
                                                        onTap: () {
                                                          // Show h detail dialog
                                                          Get.dialog(
                                                              Dialog(
                                                                backgroundColor: Colors.transparent, // <-- transparent background
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xFF1E1E2E),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.black26,
                                                                        blurRadius: 20,
                                                                        offset: Offset(0, 10),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(24),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Center(
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(Icons.receipt_long_outlined, color: Colors.blueAccent, size: 40),
                                                                              SizedBox(height: 10),
                                                                              Text(
                                                                                "សងដោយផ្នែកលំអិត",
                                                                                style: TextStyle(
                                                                                  fontFamily: 'MyBaseFont',
                                                                                  fontSize: 22,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 20),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Color(0xFF1E1E2E),
                                                                            borderRadius: BorderRadius.circular(16),
                                                                          ),
                                                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                                                          child: Column(
                                                                            children: [
                                                                              _receiptRow("ចំនួន", "\$${h.repayAmount}", color:Colors.green),
                                                                              Divider(color: Colors.white10, thickness: 1, height: 24),
                                                                              _receiptRow("ថ្ងៃសងប្រាក់", h.repayDate ?? "-"),
                                                                              if (h.repayDesc != null && h.repayDesc!.isNotEmpty) ...[
                                                                                Divider(color: Colors.white10, thickness: 1, height: 24),
                                                                                _receiptRow("ចំណាំ", h.repayDesc ?? "-"),
                                                                              ],
                                                                              if (h.repayId != null && h.repayId!.isNotEmpty) ...[
                                                                                Divider(color: Colors.white10, thickness: 1, height: 24),
                                                                                _receiptRow("លេខសំគាល់", h.repayId ?? "-", fontSize: 10),
                                                                              ],
                                                                              if (txn.transactionId != null && txn.transactionId!.isNotEmpty) ...[
                                                                                _receiptRow("លេខសំគាល់ដើម", txn.transactionId ?? "-", fontSize: 10),
                                                                              ],
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 24),
                                                                        Align(
                                                                          alignment: Alignment.center,
                                                                          child: SizedBox(
                                                                            width: double.infinity, // Make it 100% width
                                                                            child: ElevatedButton.icon(
                                                                              onPressed: () => Get.back(),
                                                                              icon: Icon(Icons.close, size: 18, color: Colors.white),
                                                                              label: Text("បិទ", style: TextStyle(color: Colors.white)),
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.blueAccent,
                                                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(16),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                          );
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.symmetric(vertical: 4),
                                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white10,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "${index + 1}",
                                                                      style: TextStyle(
                                                                        color: Colors.white.withOpacity(0.5),
                                                                        fontSize: 12,
                                                                        fontFamily: 'MyBaseFont',
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "\$${h.repayAmount}",
                                                                            style: TextStyle(
                                                                              color: Colors.greenAccent,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 13,
                                                                              fontFamily: 'MyBaseFont',
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "${h.repayDate}",
                                                                            style: TextStyle(
                                                                              color: Colors.white70,
                                                                              fontSize: 11,
                                                                              fontFamily: 'MyBaseFont',
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      Get.dialog(
                                                                        Dialog(
                                                                          backgroundColor: Color(0xFF1E1E2E),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(20),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
                                                                                    SizedBox(width: 10),
                                                                                    Text(
                                                                                      "Confirm Delete",
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'MyBaseFont',
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 16),
                                                                                Text(
                                                                                  "Are you sure you want to remove this repayment entry?",
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'MyBaseFont',
                                                                                    fontSize: 14,
                                                                                    color: Colors.white70,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 24),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () => Get.back(),
                                                                                      child: Text("Cancel", style: TextStyle(color: Colors.blueAccent)),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    ElevatedButton.icon(
                                                                                      icon: Icon(Icons.delete_outline, color: Colors.white, size: 18),
                                                                                      label: Text("Remove", style: TextStyle(fontWeight: FontWeight.w600)),
                                                                                      onPressed: () {
                                                                                        txn.repayLoanDetails?.removeAt(index);
                                                                                        controller.deleteRepayLoan(h.repayId!, txn.transactionId!);
                                                                                        Get.back();
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.redAccent,
                                                                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(12),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                                                                    tooltip: "Remove",
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );

                                                    },
                                                  ),
                                                ),


                                                Divider(color: Colors.white10, height: 30),

                                                Obx(() => controller.isRepayFormVisible.value
                                                    ? SizedBox.shrink() // Hide button when form is visible
                                                    : Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        onPressed: () {
                                                          controller.isRepayFormVisible.value = true; // Just open form
                                                        },
                                                        icon: Icon(Icons.create, color: app_colors.baseWhiteColor),
                                                        label: Text(
                                                          "បន្ថែម",
                                                          style: TextStyle(color: app_colors.baseWhiteColor),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.green,
                                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ),

                                                Obx(() => controller.isRepayFormVisible.value
                                                    ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "សងប្រាក់",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontFamily: 'MyBaseFont',
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    _darkInputField(controller: amountController, hint: "ចំនួនទឹកប្រាក់សង", icon: Icons.attach_money),
                                                    SizedBox(height: 10),
                                                    _darkInputField(controller: reasonController, hint: "ចំណាំ", icon: Icons.edit_note),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () => controller.isRepayFormVisible.value = false,
                                                          child: Text("បោះបង់", style: TextStyle(color: Colors.white)),
                                                        ),
                                                        SizedBox(width: 10),
                                                        ElevatedButton.icon(
                                                          icon: Icon(Icons.save, color: app_colors.baseWhiteColor),
                                                          label: Text("បញ្ចូល", style: TextStyle(color: Colors.white)),
                                                          onPressed: () {
                                                            final amount = amountController.text.trim();
                                                            final reason = reasonController.text.trim();
                                                            if (amount.isEmpty || reason.isEmpty) {
                                                              Get.snackbar(
                                                                  "មិនត្រឹមត្រូវ",
                                                                  "សូមបំពេញព័តិមានអោយបានត្រឹមត្រូវ",
                                                                  colorText: app_colors.baseWhiteColor,
                                                                  icon: Icon(Icons.warning_amber_sharp, color: app_colors.baseWhiteColor),
                                                                  snackPosition: SnackPosition.TOP);
                                                              return;
                                                            }

                                                            double parsedAmount = double.tryParse(amount) ?? 0;
                                                            if (parsedAmount > txn.remainBalance!) {
                                                              Get.snackbar(
                                                                "មិនត្រឹមត្រូវ",
                                                                "ចំនួនប្រាក់សងលើសកម្ចីដែលនៅសល់",
                                                                colorText: app_colors.baseWhiteColor,
                                                                icon: Icon(Icons.warning_amber_sharp, color: app_colors.baseWhiteColor),
                                                                snackPosition: SnackPosition.TOP,
                                                              );
                                                              return;
                                                            }

                                                            controller.repayAmount.value = amount;
                                                            controller.repayDesc.value = reason;
                                                            controller.repayLoan(txn.transactionId!);

                                                            controller.isRepayFormVisible.value = false; // Hide after submit
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: app_colors.baseColor,
                                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                                    : SizedBox.shrink()
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }

                            ),
                          );
                        },
                      );

                    }),
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

Widget _darkInfo(String label, String value, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'MyBaseFont')),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.white,
            fontFamily: 'MyBaseFont',
          ),
        ),
      ],
    ),
  );
}

Widget _darkInputField({required TextEditingController controller, required String hint, required IconData icon}) {
  return TextField(
    controller: controller,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

Widget _receiptRow(String label, String value, {Color? color, double? fontSize}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white60,
          fontSize: fontSize ?? 14, // <-- apply fontSize here
          fontFamily: 'MyBaseFont',
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: fontSize ?? 14, // <-- apply fontSize here
            fontFamily: 'MyBaseFont',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}


