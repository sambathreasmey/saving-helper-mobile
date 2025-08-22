import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/constants/application_variable.dart';
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
                        color: ApplicationVariable.themeTextColor,
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
                            color: ApplicationVariable.themeTextColor,
                            fontSize: 9,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Text(
                          'របាយការណ៍សង្ខេបប្រចាំខែ',
                          style: TextStyle(
                            color: ApplicationVariable.themeTextColor,
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

                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        height: 120,
                        alignment: Alignment.center,
                        gradient: LinearGradient(
                          colors: [
                            ApplicationVariable.themeFirstGradientColor.withOpacity(0.40),
                            ApplicationVariable.themeSecondGradientColor.withOpacity(0.10),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            ApplicationVariable.themeFirstBorderColor.withOpacity(0.60),
                            ApplicationVariable.themeFirstBorderColor.withOpacity(0.10),
                            ApplicationVariable.themeSecondBorderColor.withOpacity(0.05),
                            ApplicationVariable.themeSecondBorderColor.withOpacity(0.60),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.39, 0.40, 1.0],
                        ),
                        blur: 20,
                        borderRadius: BorderRadius.circular(24.0),
                        borderWidth: 1.0,
                        elevation: 4.0,
                        shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ApplicationVariable.themeTextColor,
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
                                    const Icon(Icons.monetization_on, color: Colors.amber, size: 26),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        txn.currencyType ?? '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: ApplicationVariable.themeTextColor,
                                          fontFamily: 'MyBaseEnFont',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "+${txn.totalAmount?.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.lightGreenAccent,
                                        fontFamily: 'MyBaseEnFont',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
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
