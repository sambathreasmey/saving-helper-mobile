import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/controllers/report_repay_controller.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
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

                      // Group by date
                      final groupedTransactions = <String, List<ReportModel>>{};
                      for (var txn in controller.reports) {
                        final date = txn?.transactionDate?.split(' ').first ?? 'Unknown';
                        groupedTransactions.putIfAbsent(date, () => []).add(txn!);
                      }

                      final sortedDates = groupedTransactions.keys.toList()
                        ..sort((a, b) => b.compareTo(a)); // Descending by date

                      return ListView.builder(
                        itemCount: sortedDates.length,
                        itemBuilder: (context, index) {
                          final date = sortedDates[index];
                          final transactions = groupedTransactions[date]!
                              .where((txn) => txn.isCompleted != true)
                              .toList();

                          if (transactions.isEmpty) return SizedBox.shrink();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'MyBaseEnFont',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              ...transactions.map((txn) => Dismissible(
                                key: ValueKey(txn.transactionId ?? "$date-${txn.hashCode}"),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16)),
                                      title: Text("បញ្ជាក់ការលុប",
                                          style: TextStyle(fontFamily: 'MyBaseFont')),
                                      content: Text("តើអ្នកប្រាកដជាចង់លុបប្រតិបត្តិការនេះមែនទេ?",
                                          style: TextStyle(fontFamily: 'MyBaseFont')),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text("បោះបង់",
                                              style: TextStyle(fontFamily: 'MyBaseFont')),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text("លុប",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'MyBaseFont')),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: _buildTransactionTile(context, txn, controller),
                              ))
                            ],
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

Widget _buildTransactionTile(BuildContext context, ReportModel txn, ReportRepayController controller) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.9),
          Colors.blueAccent.withOpacity(0.9)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.orangeAccent.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: ListTile(
      onTap: () => _showTransactionDetailSheet(context, txn, controller,),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.blueAccent.withOpacity(0.9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          // color: app_colors.menu3Color,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            txn.transactionType == "loan"
                ? Icons.currency_exchange_outlined
                : Icons.savings,
            color: Colors.white,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            txn.transactionType == 'loan'
                ? "-${txn.amount?.toStringAsFixed(2)}"
                : "+${txn.amount?.toStringAsFixed(2)}",
            style: TextStyle(
              fontFamily: 'MyBaseEnFont',
              color: txn.transactionType == 'loan'
                  ? Colors.deepOrange
                  : Colors.lightGreenAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Text(
            txn.currencyType ?? '',
            style: TextStyle(
              fontFamily: 'MyBaseEnFont',
              color: txn.transactionType == 'loan'
                  ? Colors.deepOrange
                  : Colors.lightGreenAccent,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txn.transactionDesc ?? '',
            style: TextStyle(
              fontFamily: 'MyBaseFont',
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          if (txn.remainBalance != 0.0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    "-${txn.remainBalance?.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontFamily: 'MyBaseEnFont',
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    txn.currencyType ?? '',
                    style: TextStyle(
                      fontFamily: 'MyBaseEnFont',
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink(),
        ],
      ),
    ),
  );
}

void _showTransactionDetailSheet(BuildContext context, ReportModel txn, ReportRepayController controller,) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final txnHistory = txn.repayLoanDetails ?? [];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.pinkAccent, Colors.blueAccent.withOpacity(0.9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              // color: app_colors.menu3Color,
                            ),
                            child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  txn.transactionType == "loan" ? Icons.currency_exchange_outlined : Icons.savings,
                                  color: Colors.white,
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'ប្រតិបត្តិការលំអិត',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyBaseFont',
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        color: Colors.black,
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
                                        gradient: LinearGradient(colors: [Colors.black, Colors.blueAccent]),
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
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.pinkAccent, Colors.blueAccent.withOpacity(0.9)],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.blueAccent.withOpacity(0.3),
                                                          blurRadius: 6,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                      // color: app_colors.menu3Color,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CircleAvatar(
                                                          backgroundColor: Colors.transparent,
                                                          child: Icon(
                                                            Icons.currency_exchange_outlined,
                                                            color: Colors.white,
                                                            size: 30,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "សងដោយផ្នែកលំអិត",
                                                    style: TextStyle(
                                                      fontFamily: 'MyBaseFont',
                                                      fontSize: 18,
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
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                              child: Column(
                                                children: [
                                                  _receiptRow("ចំនួន", "\$${h.repayAmount}", color:Colors.green),
                                                  Divider(color: Colors.black26, thickness: 1, height: 24),
                                                  _receiptRow("ថ្ងៃសងប្រាក់", h.repayDate ?? "-"),
                                                  if (h.repayDesc != null && h.repayDesc!.isNotEmpty) ...[
                                                    Divider(color: Colors.black26, thickness: 1, height: 24),
                                                    _receiptRow("ចំណាំ", h.repayDesc ?? "-"),
                                                  ],
                                                  if (h.repayId != null && h.repayId!.isNotEmpty) ...[
                                                    Divider(color: Colors.black26, thickness: 1, height: 24),
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
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Colors.pinkAccent, Colors.blueAccent],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.orangeAccent.withOpacity(0.1),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ElevatedButton.icon(
                                                    onPressed: () => Get.back(),
                                                    icon: Icon(Icons.close, size: 18, color: Colors.white),
                                                    label: Text("បិទ", style: TextStyle(color: Colors.white)),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.transparent,
                                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
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
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.black, Colors.blueAccent],
                                ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [Colors.pinkAccent, Colors.blueAccent],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
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
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                            color: Colors.black,
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
                              child: Text("បោះបង់", style: TextStyle(color: Colors.black)),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.pinkAccent, Colors.blueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
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
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
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
          ),
        ),
      );
    },
  );
}

Widget _darkInfo(String label, String value, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.black54, fontFamily: 'MyBaseFont')),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black,
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
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.black),
      filled: true,
      fillColor: Colors.grey,
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
          color: Colors.black54,
          fontSize: fontSize ?? 14, // <-- apply fontSize here
          fontFamily: 'MyBaseFont',
          fontWeight: FontWeight.bold,
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color ?? Colors.black,
            fontSize: fontSize ?? 14, // <-- apply fontSize here
            fontFamily: 'MyBaseFont',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}


