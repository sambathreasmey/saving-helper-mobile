import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
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
                        child: Obx(
                              () => DropdownButton<String>(
                            value: controller.selectedTransactionType.value
                                .isEmpty
                                ? null
                                : controller.selectedTransactionType.value,
                            hint: Text('សូមជ្រើសរើសប្រតិបត្តិការ', style: TextStyle(fontFamily: 'MyBaseFont', color: app_colors.baseWhiteColor,),),
                            isExpanded: true,
                            onChanged: (value) {
                              controller.selectedTransactionType.value =
                              (value ?? ''); // Set selected type
                              controller.fetchTransactions(); // Fetch filtered data
                            },
                            items: [
                              DropdownMenuItem(child: Text("ទាំងអស់"), value: ""),
                              DropdownMenuItem(child: Text("កម្ចី"), value: "loan"),
                              // DropdownMenuItem(
                              //     child: Text("សងប្រាក់កម្ចី"), value: "loan_repay"),
                              DropdownMenuItem(
                                  child: Text("សន្សំ"),
                                  value: "saving_deposit"),
                              DropdownMenuItem(
                                  child: Text("សន្សំបន្ថែម"),
                                  value: "saving_deposit_more"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),

                      // Loading Indicator
                      Obx(
                            () => controller.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Transaction Table
                  Obx(
                        () {
                      if (controller.reports.isEmpty) {
                        return Center(child: Text('មិនមានប្រតិបត្តិការ', style: TextStyle(fontFamily: 'MyBaseFont', color: app_colors.subTitleText,),),);
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: controller.reports.length,
                          itemBuilder: (context, index) {
                            final txn = controller.reports[index];
                            if (txn != null) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                color: app_colors.baseWhiteColor.withOpacity(0.2),
                                child: ListTile(
                                  title: Text("\$${txn.amount}", style: TextStyle(fontFamily: 'MyBaseFont', color: app_colors.baseWhiteColor, fontWeight: FontWeight.bold,)),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${txn.transactionDesc} - ${txn.transactionType}",
                                        style: TextStyle(fontFamily: 'MyBaseFont', color: app_colors.baseWhiteColor, fontSize: 10,)
                                      ),
                                      Text(
                                          "${txn.transactionDate} - ${txn.remainBalance ?? 0.0}",
                                          style: TextStyle(fontFamily: 'MyBaseFont', color: app_colors.baseWhiteColor, fontSize: 10,)
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Implement your navigation or detail view logic here
                                  },
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      );
                    },
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
