import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:get/get.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/app_color.dart' as app_colors;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController controller = Get.put(
      ReportController(ReportRepository(ApiProvider())));

  @override
  void dispose() {
    Get.delete<ReportController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Custom Header
              CustomHeader(),
              SizedBox(height: 15),

              // Title Section
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'របាយការណ៍',
                      style: TextStyle(
                        color: app_colors.baseWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MyBaseFont',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'របាយការណ៍ /',
                          style: TextStyle(
                            color: app_colors.subTitleText,
                            fontSize: 9,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Text(
                          'របាយការណ៍ទូទៅ',
                          style: TextStyle(
                            color: app_colors.baseWhiteColor,
                            fontSize: 9,
                            fontFamily: 'MyBaseFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // Filter Section
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pinkAccent, Colors.orangeAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orangeAccent.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(
                            () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true, // ✅ Important for full-width dropdown
                            value: controller.selectedTransactionType.value.isEmpty
                                ? null
                                : controller.selectedTransactionType.value,
                            hint: Text(
                              'សូមជ្រើសរើសប្រតិបត្តិការ',
                              style: TextStyle(
                                fontFamily: 'MyBaseFont',
                                color: Colors.white,
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: "",
                                child: Text("ទាំងអស់", style: TextStyle(color: Colors.white, fontFamily: 'MyBaseFont')),
                              ),
                              DropdownMenuItem(
                                value: "loan",
                                child: Text("កម្ចី", style: TextStyle(color: Colors.white, fontFamily: 'MyBaseFont')),
                              ),
                              DropdownMenuItem(
                                value: "saving_deposit",
                                child: Text("សន្សំ", style: TextStyle(color: Colors.white, fontFamily: 'MyBaseFont')),
                              ),
                              DropdownMenuItem(
                                value: "saving_deposit_more",
                                child: Text("សន្សំបន្ថែម", style: TextStyle(color: Colors.white, fontFamily: 'MyBaseFont')),
                              ),
                            ],
                            onChanged: (value) {
                              controller.selectedTransactionType.value = value ?? '';
                              controller.fetchTransactions();
                            },
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.pinkAccent, Colors.orangeAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              // Transaction Table
              Obx(() {
                  if (controller.reports.isEmpty) {
                    return Center(child: Text('មិនមានប្រតិបត្តិការ', style: TextStyle(fontFamily: 'MyBaseFont', color: app_colors.subTitleText,),),);
                  }
                  return Expanded(
                    child: Obx(
                          () => ListView.builder(
                        itemCount: controller.reports.length,
                        itemBuilder: (context, index) {
                          final txn = controller.reports[index];
                          if (txn != null) {
                            return Dismissible(
                              key: ValueKey(txn.transactionId ?? index), // Ensure unique key
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    title: Text("បញ្ជាក់ការលុប", style: TextStyle(fontFamily: 'MyBaseFont')),
                                    content: Text("តើអ្នកប្រាកដជាចង់លុបប្រតិបត្តិការនេះមែនទេ?", style: TextStyle(fontFamily: 'MyBaseFont')),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: Text("បោះបង់", style: TextStyle(fontFamily: 'MyBaseFont')),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: Text("លុប", style: TextStyle(color: Colors.red, fontFamily: 'MyBaseFont')),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                controller.deleteTransaction(txn.transactionId!); // 👈 your deletion logic
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.greenAccent, Colors.blueAccent],
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
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  title: Text(
                                    "\$${txn.amount}",
                                    style: TextStyle(
                                      fontFamily: 'MyBaseFont',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${txn.transactionDesc} - ${txn.transactionType}",
                                        style: TextStyle(
                                          fontFamily: 'MyBaseFont',
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        "${txn.transactionDate} - ${txn.remainBalance ?? 0.0}",
                                        style: TextStyle(
                                          fontFamily: 'MyBaseFont',
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Optionally show transaction detail
                                  },
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  );
              },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
