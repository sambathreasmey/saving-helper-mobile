import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/report_controller.dart';
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
              CustomHeader(),
              SizedBox(height: 15),

              // Title
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
                          'របាយការណ៍ / ',
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

              // Dropdown
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pinkAccent,
                            Colors.blueAccent.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(
                            () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            barrierColor: Colors.black.withOpacity(0.5),
                            barrierDismissible: false,
                            style: TextStyle(fontSize: 14),
                            isExpanded: true,
                            value: controller.selectedTransactionType.value,
                            items: [
                              DropdownMenuItem(
                                value: "",
                                child: Text("ទាំងអស់",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MyBaseFont')),
                              ),
                              DropdownMenuItem(
                                value: "loan",
                                child: Text("កម្ចី",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MyBaseFont')),
                              ),
                              DropdownMenuItem(
                                value: "saving_deposit",
                                child: Text("សន្សំ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MyBaseFont')),
                              ),
                              DropdownMenuItem(
                                value: "saving_deposit_more",
                                child: Text("សន្សំបន្ថែម",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MyBaseFont')),
                              ),
                            ],
                            onChanged: (value) {
                              controller.selectedTransactionType.value =
                                  value ?? '';
                              controller.fetchTransactions();
                            },
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent,
                                    Colors.blueAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.orangeAccent.withOpacity(0.3),
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

              // Transaction List
              Obx(() {
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

                return Expanded(
                  child: ListView.builder(
                    itemCount: sortedDates.length,
                    itemBuilder: (context, dateIndex) {
                      final date = sortedDates[dateIndex];
                      final transactions = groupedTransactions[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 18,),
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
                          ),
                          ...transactions.map((txn) => Dismissible(
                            key: ValueKey(txn.transactionId ??
                                "${dateIndex}_${transactions.indexOf(txn)}"),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding:
                              EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                              Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                  title: Text("បញ្ជាក់ការលុប",
                                      style: TextStyle(
                                          fontFamily: 'MyBaseFont')),
                                  content: Text(
                                      "តើអ្នកប្រាកដជាចង់លុបប្រតិបត្តិការនេះមែនទេ?",
                                      style: TextStyle(
                                          fontFamily: 'MyBaseFont')),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("បោះបង់",
                                          style: TextStyle(
                                              fontFamily: 'MyBaseFont')),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("លុប",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'MyBaseFont')),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              controller
                                  .deleteTransaction(txn.transactionId!);
                            },
                            child: _buildTransactionTile(context, txn, controller),
                          ))
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTransactionTile(BuildContext context, ReportModel txn, ReportController controller) {
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
          color: Colors.orangeAccent
              .withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: ListTile(
      onTap: () => _showTransactionDetailSheet(context, txn),
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
              txn.transactionType == "loan" ? Icons.currency_exchange_outlined : Icons.savings,
              color: Colors.white,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${txn.currencyType}",
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
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: [Colors.black, Colors.blueAccent],
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
                          "${txn.remainBalance?.toStringAsFixed(2) ?? '0.00'} ${txn.currencyType}", false, false),
                      _buildDetailRow('Date', txn.transactionDate ?? '-', false, false),
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

Widget _buildDetailRow(String label, String value, bool isKhmer, bool isCopy) {
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
                  color: Colors.black54,
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
                    colors: [Colors.pinkAccent, Colors.blueAccent.withOpacity(0.9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                height: 24,
                width: 32,
                child: IconButton(
                  icon: Icon(Icons.copy, size: 10, color: Colors.white,),
                  tooltip: 'Copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      "ចម្លងរួចរាល់",
                      "\"$value\" ត្រូវបានចម្លង",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
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
