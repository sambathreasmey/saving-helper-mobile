import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

import 'package:saving_helper/constants/application_variable.dart';
import 'package:saving_helper/controllers/report_controller.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/app_color.dart' as app_colors;

/// Report Screen with:
/// - Pull-to-refresh
/// - Infinite scroll with guard
/// - Group-by-date section headers
/// - Dismiss-to-delete with confirm
/// - Material-wrapped tiles & buttons (fixes ripple assertion)
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController controller =
  Get.put(ReportController(ReportRepository(ApiProvider())));
  final ScrollController _scrollController = ScrollController();

  bool _pagingGuard = false;
  Timer? _pagingCooldown;
  static const double _pagingThreshold = 150.0;

  @override
  void initState() {
    super.initState();
    controller.fetchTransactions(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final nearBottom = position.pixels >= position.maxScrollExtent - _pagingThreshold;

    if (nearBottom &&
        controller.hasMore.value &&
        !controller.isLoading.value &&
        !_pagingGuard) {
      _pagingGuard = true;
      controller.fetchTransactions();
      _pagingCooldown?.cancel();
      _pagingCooldown = Timer(const Duration(milliseconds: 450), () {
        _pagingGuard = false;
      });
    }
  }

  @override
  void dispose() {
    _pagingCooldown?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    Get.delete<ReportController>();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await controller.fetchTransactions(refresh: true);
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
              const _TitleSection(),
              const SizedBox(height: 15),

              // Filter (transaction type)
              _TypeDropdown(controller: controller),
              const SizedBox(height: 15),

              // List + Pull-to-Refresh
              Expanded(
                child: RefreshIndicator.adaptive(
                  onRefresh: _handleRefresh,
                  child: Obx(() {
                    if (controller.reports.isEmpty && controller.isLoading.value) {
                      return const _LoadingList();
                    }

                    if (controller.reports.isEmpty) {
                      return const _EmptyList();
                    }

                    // Group by date
                    final grouped = <String, List<ReportModel>>{};
                    for (final txn in controller.reports) {
                      if (txn == null) continue;
                      final date = (txn.transactionDate ?? '').split(' ').first;
                      grouped.putIfAbsent(date.isEmpty ? 'Unknown' : date, () => <ReportModel>[]).add(txn);
                    }
                    final sortedDates = grouped.keys.toList()
                      ..sort((a, b) => b.compareTo(a)); // newest first

                    final totalItems = sortedDates.length + (controller.hasMore.value ? 1 : 0);

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: totalItems,
                      itemBuilder: (context, index) {
                        // Bottom loader (paging indicator)
                        if (index == sortedDates.length) {
                          if (controller.isLoading.value) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CupertinoActivityIndicator()),
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        final date = sortedDates[index];
                        final txns = grouped[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
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
                            ...txns.asMap().entries.map((entry) {
                              final txnIndex = entry.key;
                              final txn = entry.value;

                              // Stable key
                              final key = ValueKey('tx:${txn.transactionId ?? 'null'}:$date:$txnIndex');

                              return Dismissible(
                                key: key,
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
                                      content: const Text(
                                        "តើអ្នកប្រាកដជាចង់លុបប្រតិបត្តិការនេះមែនទេ?",
                                        style: TextStyle(fontFamily: 'MyBaseFont'),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("បោះបង់", style: TextStyle(fontFamily: 'MyBaseFont')),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("លុប",
                                              style: TextStyle(color: Colors.red, fontFamily: 'MyBaseFont')),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (direction) {
                                  final id = txn.transactionId;
                                  if (id != null) {
                                    controller.deleteTransaction(id);
                                  }
                                },
                                child: _buildTransactionTile(context, txn, controller),
                              );
                            }),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({required this.controller});

  final ReportController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            child: Obx(
                  () => DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  barrierColor: Colors.black.withOpacity(0.5),
                  barrierDismissible: false,
                  style: const TextStyle(fontSize: 14),
                  isExpanded: true,
                  value: controller.selectedTransactionType.value,
                  items: const [
                    DropdownMenuItem(value: "", child: _TypeText("ទាំងអស់")),
                    DropdownMenuItem(value: "loan", child: _TypeText("កម្ចី")),
                    DropdownMenuItem(value: "saving_deposit", child: _TypeText("សន្សំ")),
                    DropdownMenuItem(value: "saving_deposit_more", child: _TypeText("សន្សំបន្ថែម")),
                  ],
                  onChanged: (value) async {
                    ApplicationVariable.vibrate();
                    controller.selectedTransactionType.value = value ?? '';
                    await controller.fetchTransactions(refresh: true);
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeText extends StatelessWidget {
  const _TypeText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: ApplicationVariable.themeTextColor,
        fontFamily: 'MyBaseFont',
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 300, child: Center(child: CupertinoActivityIndicator())),
      ],
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'មិនមានប្រតិបត្តិការ',
              style: TextStyle(
                fontFamily: 'MyBaseFont',
                color: app_colors.subTitleText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== Item Tile & Detail Sheet =====================

Widget _buildTransactionTile(
    BuildContext context,
    ReportModel txn,
    ReportController controller,
    ) {
  final isLoan = txn.transactionType == "loan";
  final amountPrefix = isLoan ? "-" : "+";
  final amountColor = isLoan ? Colors.deepOrange : Colors.lightGreenAccent;

  return GlassContainer(
    margin: const EdgeInsets.symmetric(vertical: 4),
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
      stops: const [0.0, 0.39, 0.40, 1.0],
    ),
    blur: 20,
    borderRadius: BorderRadius.circular(24.0),
    borderWidth: 1.0,
    elevation: 4.0,
    shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
    // --- Fix ripple assertion: give ListTile a Material ancestor & clip ---
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () {
          ApplicationVariable.vibrate();
          _showTransactionDetailSheet(context, txn);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              isLoan ? Icons.currency_exchange_outlined : Icons.savings,
              color: ApplicationVariable.themeTextColor,
            ),
          ),
        ),
        title: Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "$amountPrefix${(txn.amount ?? 0).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontFamily: 'MyBaseEnFont',
                    color: amountColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  txn.currencyType ?? '',
                  style: TextStyle(
                    fontFamily: 'MyBaseEnFont',
                    color: amountColor,
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
            Expanded(
              child: Text(
                txn.transactionDesc ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'MyBaseFont',
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
            if ((txn.remainBalance ?? 0) != 0.0)
              Container(
                margin: const EdgeInsets.only(bottom: 8, left: 8),
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "-${(txn.remainBalance ?? 0).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: 'MyBaseEnFont',
                        color: ApplicationVariable.themeTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      txn.currencyType ?? '',
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
              const SizedBox.shrink(),
          ],
        ),
      ),
    ),
  );
}

void _showTransactionDetailSheet(BuildContext context, ReportModel txn) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      // Give a Material surface inside transparent sheet (fixes ink referenceBox)
      return Material(
        type: MaterialType.transparency,
        child: GlassContainer(
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
            stops: const [0.0, 0.39, 0.40, 1.0],
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
                // drag handle
                Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
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
                      stops: const [0.0, 0.39, 0.40, 1.0],
                    ),
                    blur: 20,
                    borderRadius: BorderRadius.circular(24.0),
                    borderWidth: 1.0,
                    elevation: 4.0,
                    shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header
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
                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    (txn.transactionType == "loan")
                                        ? Icons.currency_exchange_outlined
                                        : Icons.savings,
                                    color: ApplicationVariable.themeTextColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'ប្រតិបត្តិការលំអិត',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MyBaseFont',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '__________________________________________',
                          style: TextStyle(
                            fontFamily: 'MyBaseFont',
                            color: CupertinoColors.inactiveGray,
                          ),
                        ),
                        _buildDetailRow('ID', txn.transactionId ?? '-', false, true),
                        _buildDetailRow('Type', txn.transactionType ?? '-', false, false),
                        _buildDetailRow('Description', txn.transactionDesc ?? '-', true, false),
                        _buildDetailRow(
                          'Amount',
                          "${txn.transactionType == 'loan' ? '-' : '+'}${(txn.amount ?? 0).toStringAsFixed(2)} ${txn.currencyType ?? ''}",
                          false,
                          false,
                        ),
                        _buildDetailRow(
                          'Remain Balance',
                          "${(txn.remainBalance ?? 0).toStringAsFixed(2)} ${txn.currencyType ?? ''}",
                          false,
                          false,
                        ),
                        _buildDetailRow('Date', txn.transactionDate ?? '-', false, false),
                        _buildDetailRow('Created By', txn.createdBy ?? '-', false, false, color: Colors.green),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDetailRow(
    String label,
    String value,
    bool isKhmer,
    bool isCopy, {
      Color? color,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
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
              const SizedBox(width: 4),
              if (isCopy)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  // Material + InkWell + Ink so ripple paints over gradient properly
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: value));
                        Get.snackbar(
                          "ចម្លងរួចរាល់",
                          "\"$value\" ត្រូវបានចម្លង",
                          snackPosition: SnackPosition.BOTTOM,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundGradient: LinearGradient(
                            colors: [
                              ApplicationVariable.themeFirstGradientColor,
                              ApplicationVariable.themeSecondGradientColor
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: 12,
                          margin: const EdgeInsets.all(12),
                          boxShadows: [
                            BoxShadow(
                              color: ApplicationVariable.themeSecondGradientColor.withOpacity(0.8),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          colorText: ApplicationVariable.themeTextColor,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Ink(
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
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 24,
                        width: 32,
                        child: Icon(Icons.copy, size: 10, color: ApplicationVariable.themeTextColor),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}