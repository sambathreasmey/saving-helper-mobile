import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/constants/application_variable.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';
import '../constants/app_color.dart' as app_colors;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController controller =
  Get.put(ReportController(ReportRepository(ApiProvider())));
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initial fetch
    controller.fetchTransactions(refresh: true);

    // Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150) {
        // Load next page when close to bottom
        controller.fetchTransactions();
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
                      'របាយការណ៍ទូទៅ',
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
                          'របាយការណ៍ទូទៅ',
                          style: TextStyle(
                            color: ApplicationVariable.themeTextColor,
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
                            ApplicationVariable.themeFirstGradientColor,
                            ApplicationVariable.themeSecondGradientColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.3),
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
                                  color: ApplicationVariable.themeTextColor,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "loan",
                              child: Text(
                                "កម្ចី",
                                style: TextStyle(
                                  color: ApplicationVariable.themeTextColor,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "saving_deposit",
                              child: Text(
                                "សន្សំ",
                                style: TextStyle(
                                  color: ApplicationVariable.themeTextColor,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "saving_deposit_more",
                              child: Text(
                                "សន្សំបន្ថែម",
                                style: TextStyle(
                                  color: ApplicationVariable.themeTextColor,
                                  fontFamily: 'MyBaseFont',
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            ApplicationVariable.vibrate();
                            controller.selectedTransactionType.value = value ?? '';
                            controller.fetchTransactions(refresh: true);
                          },
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: ApplicationVariable.themeSecondGradientColor,
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
                  if (controller.reports.isEmpty && controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
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

                  // Group transactions by date
                  final groupedTransactions = <String, List<ReportModel>>{};
                  for (var txn in controller.reports) {
                    final date = txn?.transactionDate?.split(' ').first ?? 'Unknown';
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
                              key: ValueKey('${date}_$txnIndex${txn.transactionId ?? UniqueKey().toString()}'),
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
                                controller.deleteTransaction(txn.transactionId!);
                              },
                              child: _buildTransactionTile(context, txn, controller),
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

Widget _buildTransactionTile(BuildContext context, ReportModel txn, ReportController controller) {
  return GlassContainer(
    margin: EdgeInsets.symmetric(vertical: 4),
    height: 72,
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
    child: ListTile(
      onTap: () => {
          ApplicationVariable.vibrate(),
          _showTransactionDetailSheet(context, txn)
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ApplicationVariable.themeFirstGradientColor,
              ApplicationVariable.themeSecondGradientColor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(
              color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.3),
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
              color: ApplicationVariable.themeTextColor,
            )
        ),
      ),
      title: Row(
        children: [
          if (txn.transactionType == 'loan') ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic, // 👈 required for baseline alignment
              children: [
                Text(
                  "-${txn.amount?.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontFamily: 'MyBaseEnFont',
                    color: Colors.deepOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  "${txn.currencyType}",
                  style: TextStyle(
                    fontFamily: 'MyBaseEnFont',
                    color: Colors.deepOrange,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic, // 👈 required for baseline alignment
              children: [
                Text(
                  "+${txn.amount?.toStringAsFixed(2)}",
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
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${txn.transactionDesc}",
            style: TextStyle(
              fontFamily: 'MyBaseFont',
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          if (txn.remainBalance != 0.0)
            Container(
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ApplicationVariable.themeFirstGradientColor,
                    ApplicationVariable.themeSecondGradientColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                spacing: 3,
                children: [
                  Text(
                    "-${txn.remainBalance?.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontFamily: 'MyBaseEnFont',
                      color: ApplicationVariable.themeTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${txn.currencyType}",
                    style: TextStyle(
                      fontFamily: 'MyBaseEnFont',
                      color: ApplicationVariable.themeTextColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink()
        ],
      ),
    ),
  );
}

void _showTransactionDetailSheet(BuildContext context, ReportModel txn) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return GlassContainer(
        height: 360,
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
        borderWidth: 0.0,
        elevation: 4.0,
        shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
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
                child: GlassContainer(
                  padding: EdgeInsets.all(16),
                  height: 275,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ApplicationVariable.themeFirstGradientColor,
                                    ApplicationVariable.themeSecondGradientColor
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.3),
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
                                    color: ApplicationVariable.themeTextColor,
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
                                  color: Colors.white,
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
                      _buildDetailRow('ID', txn.transactionId ?? '-', false, true),
                      _buildDetailRow('Type', txn.transactionType ?? '-', false, false),
                      _buildDetailRow('Description', txn.transactionDesc ?? '-', true, false),
                      _buildDetailRow('Amount',
                          "${txn.transactionType == 'loan' ? '-' : '+'}${txn.amount?.toStringAsFixed(2)} ${txn.currencyType}", false, false),
                      _buildDetailRow('Remain Balance',
                          "${txn.remainBalance?.toStringAsFixed(2) ?? '0.00'} ${txn.currencyType}", false, false,),
                      _buildDetailRow('Date', txn.transactionDate ?? '-', false, false),
                      _buildDetailRow('Created By', txn.createdBy ?? '-', false, false, color: Colors.green),
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

Widget _buildDetailRow(String label, String value, bool isKhmer, bool isCopy, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'MyBaseEnFont',
            fontWeight: FontWeight.normal,
            color: Colors.white,
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
                    color: color ?? Colors.white,
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
                        ApplicationVariable.themeFirstGradientColor,
                        ApplicationVariable.themeSecondGradientColor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.8),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  height: 24,
                  width: 32,
                  child: IconButton(
                    icon: Icon(Icons.copy, size: 10, color: ApplicationVariable.themeTextColor,),
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
                            ApplicationVariable.themeFirstGradientColor,
                            ApplicationVariable.themeSecondGradientColor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: 12,
                        margin: EdgeInsets.all(12),
                        boxShadows: [
                          BoxShadow(
                            color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.8),
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                        colorText: ApplicationVariable.themeTextColor,
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
    ),
  );
}
