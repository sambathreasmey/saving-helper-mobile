import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/controllers/summary_report_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/repository/summary_report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';
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

    // Initial fetch
    controller.fetchSummaryReport(refresh: true);

    // Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150) {
        // Load next page when close to bottom
        controller.fetchSummaryReport();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
              const CustomHeader(),
              const SizedBox(height: 15),

              // Title section
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'របាយការណ៍',
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
                            fontFamily: 'MyBaseFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Dropdown with underline hidden
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeController.theme.value?.firstControlColor ?? Colors.black,
                            themeController.theme.value?.secondControlColor ?? Colors.black,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          barrierColor: Colors.black.withOpacity(0.5),
                          barrierDismissible: false,
                          style: const TextStyle(fontSize: 14),
                          isExpanded: true,
                          value: controller.selectedTransactionType.value,
                          items: [
                            DropdownMenuItem(
                              value: "",
                              child: Text(
                                "ទាំងអស់",
                                style: TextStyle(
                                  color: themeController.theme.value?.textColor ?? Colors.white,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "loan",
                              child: Text(
                                "កម្ចី",
                                style: TextStyle(
                                  color: themeController.theme.value?.textColor ?? Colors.white,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "saving_deposit",
                              child: Text(
                                "សន្សំ",
                                style: TextStyle(
                                  color: themeController.theme.value?.textColor ?? Colors.white,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "saving_deposit_more",
                              child: Text(
                                "សន្សំបន្ថែម",
                                style: TextStyle(
                                  color: themeController.theme.value?.textColor ?? Colors.white,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            controller.selectedTransactionType.value = value ?? '';
                            controller.fetchSummaryReport(refresh: true);
                          },
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor ?? Colors.black,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Transactions List with pagination
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

                  // Group transactions by date
                  final groupedTransactions = <String, List<GetSummaryReportResponse.Data>>{};
                  for (var txn in controller.summaryData) {
                    final date = txn?.month?.split(' ').first ?? 'Unknown';
                    groupedTransactions.putIfAbsent(date, () => []).add(txn!);
                  }

                  final sortedDates = groupedTransactions.keys.toList()
                    ..sort((a, b) => b.compareTo(a)); // Descending dates

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: sortedDates.length + (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == sortedDates.length) {
                        // loading indicator at bottom
                        if (controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }

                      final date = sortedDates[index];
                      final transactions = groupedTransactions[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Text(
                              date,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'MyBaseEnFont',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...transactions.asMap().entries.map((entry) {
                            final txnIndex = entry.key;
                            final txn = entry.value;
                            return Dismissible(
                              key: ValueKey('${date}_$txnIndex${txn.totalAmount ?? UniqueKey().toString()}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    title: const Text("បញ្ជាក់ការលុប", style: TextStyle(fontFamily: 'MyBaseFont')),
                                    content: const Text("តើអ្នកប្រាកដជាចង់លុបប្រតិបត្តិការនេះមែនទេ?", style: TextStyle(fontFamily: 'MyBaseFont')),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("បោះបង់", style: TextStyle(fontFamily: 'MyBaseFont')),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text("លុប", style: TextStyle(color: Colors.red, fontFamily: 'MyBaseFont')),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                // controller.deleteTransaction(txn.transactionId!);
                              },
                              child: _buildTransactionTile(context, txn, controller, themeController),
                            );
                          }).toList(),
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
    );
  }

}

Widget _buildTransactionTile(BuildContext context, GetSummaryReportResponse.Data txn, SummaryReportController controller, ThemeController themeController) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black,
          themeController.theme.value?.secondControlColor ?? Colors.black,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: ListTile(
      // onTap: () => _showTransactionDetailSheet(context, txn, themeController),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeController.theme.value?.firstControlColor ?? Colors.black,
              themeController.theme.value?.secondControlColor ?? Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(
              color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          // color: app_colors.menu3Color,
        ),
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.savings,
              color: themeController.theme.value?.textColor ?? Colors.white,
            )
        ),
      ),
      title: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic, // 👈 required for baseline alignment
            children: [
              Text(
                "+${txn.totalAmount?.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: 'MyBaseEnFont',
                  color: Colors.lightGreenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Text(
                "${txn.currencyType}",
                style: TextStyle(
                  fontFamily: 'MyBaseEnFont',
                  color: Colors.lightGreenAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${txn.currencyType}",
            style: TextStyle(
              fontFamily: 'MyBaseFont',
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    ),
  );
}

void _showTransactionDetailSheet(BuildContext context, ReportModel txn, ThemeController themeController) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black, themeController.theme.value?.secondControlColor ?? Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Paper-like header
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    themeController.theme.value?.firstControlColor ?? Colors.black,
                                    themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
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
                                    color: themeController.theme.value?.textColor ?? Colors.white,
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
                      Text('__________________________________________',
                        style: TextStyle(
                            fontFamily: 'MyBaseFont',
                            color: CupertinoColors.inactiveGray
                        ),
                      ),
                      _buildDetailRow('ID', txn.transactionId ?? '-', false, true, themeController),
                      _buildDetailRow('Type', txn.transactionType ?? '-', false, false, themeController),
                      _buildDetailRow('Description', txn.transactionDesc ?? '-', true, false, themeController),
                      _buildDetailRow('Amount',
                        "${txn.transactionType == 'loan' ? '-' : '+'}${txn.amount?.toStringAsFixed(2)} ${txn.currencyType}", false, false, themeController,),
                      _buildDetailRow('Remain Balance',
                        "${txn.remainBalance?.toStringAsFixed(2) ?? '0.00'} ${txn.currencyType}", false, false, themeController,),
                      _buildDetailRow('Date', txn.transactionDate ?? '-', false, false, themeController),
                      _buildDetailRow('Created By', txn.createdBy ?? '-', false, false, themeController, color: Colors.green),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDetailRow(String label, String value, bool isKhmer, bool isCopy, ThemeController themeController, {Color? color}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'MyBaseEnFont',
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: isKhmer ? 'MyBaseFont' : 'MyBaseEnFont',
                  color: color ?? Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 4),
            isCopy ?
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      themeController.theme.value?.firstControlColor ?? Colors.black,
                      themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.theme.value?.secondControlColor?.withOpacity(0.8) ?? Colors.white.withOpacity(0.8),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                height: 24,
                width: 32,
                child: IconButton(
                  icon: Icon(Icons.copy, size: 10, color: themeController.theme.value?.textColor ?? Colors.white,),
                  tooltip: 'Copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      "ចម្លងរួចរាល់",
                      "\"$value\" ត្រូវបានចម្លង",
                      snackPosition: SnackPosition.BOTTOM,
                      snackStyle: SnackStyle.FLOATING, // Important to allow rounded corners and shadow
                      backgroundGradient: LinearGradient(
                        colors: [
                          themeController.theme.value?.firstControlColor ?? Colors.black,
                          themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: 12,
                      margin: EdgeInsets.all(12),
                      boxShadows: [
                        BoxShadow(
                          color: themeController.theme.value?.secondControlColor?.withOpacity(0.8) ?? Colors.white.withOpacity(0.8),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                      colorText: themeController.theme.value?.textColor ?? Colors.white,
                      duration: Duration(seconds: 2),
                    );

                  },
                ),
              ),
            )
                :
            SizedBox.shrink(),
          ],
        ),
      ),
    ],
  );
}
