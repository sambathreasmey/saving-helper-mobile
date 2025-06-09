import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/summary_report_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/summary_report_repository.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';
import 'package:saving_helper/screen/header.dart';
import '../constants/app_color.dart' as app_colors;
import '../models/responses/get_summary_report_response.dart' as GetSummaryReportResponse;

class SummaryReportScreen extends StatefulWidget {
  const SummaryReportScreen({super.key});

  @override
  _SummaryReportScreenState createState() => _SummaryReportScreenState();
}

class _SummaryReportScreenState extends State<SummaryReportScreen> {
  final SummaryReportController controller =
  Get.put(SummaryReportController(SummaryReportRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchSummaryReport(refresh: true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150) {
        controller.fetchSummaryReport();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
              const CustomHeader(),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'របាយការណ៍សង្ខេបប្រចាំខែ',
                      style: TextStyle(
                        color: themeController.theme.value?.textColor ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MyBaseFont',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'របាយការណ៍ / ',
                          style: TextStyle(
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            fontSize: 9,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Text(
                          'របាយការណ៍សង្ខេបប្រចាំខែ',
                          style: TextStyle(
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() {
                  if (controller.summaryData.isEmpty && controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.summaryData.isEmpty) {
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

                  final groupedTransactions = <String, List<GetSummaryReportResponse.Data>>{};
                  for (var txn in controller.summaryData) {
                    final date = txn?.month?.split(' ').first ?? 'Unknown';
                    groupedTransactions.putIfAbsent(date, () => []).add(txn!);
                  }

                  final dateKeys = groupedTransactions.keys.toList();

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: dateKeys.length + (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == dateKeys.length) {
                        if (controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }

                      final date = dateKeys[index];
                      final transactions = groupedTransactions[date]!;
                      final totalAmount = transactions.fold<double>(0, (sum, txn) => sum + (txn.totalAmount ?? 0));

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              themeController.theme.value?.secondControlColor ?? Colors.black,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeController.theme.value?.textColor ?? Colors.white,
                                fontFamily: 'MyBaseEnFont',
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...transactions.asMap().entries.map((entry) {
                              final txn = entry.value;
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        txn.currencyType ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: themeController.theme.value?.textColor ?? Colors.white,
                                          fontFamily: 'MyBaseEnFont',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "+${txn.totalAmount?.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.lightGreenAccent,
                                        fontFamily: 'MyBaseEnFont',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
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
    );
  }
}
