import 'dart:async';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/controllers/report_repay_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/repository/report_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:get/get.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/app_color.dart' as app_colors;
import '../constants/application_variable.dart';
import '../models/repay_laon_model.dart';

class ReportRepayScreen extends StatefulWidget {
  const ReportRepayScreen({super.key});

  @override
  State<ReportRepayScreen> createState() => _ReportRepayScreenState();
}

class _ReportRepayScreenState extends State<ReportRepayScreen> {
  late final ReportRepayController controller;
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  bool _pagingGuard = false;
  Timer? _pagingCooldown;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReportRepayController(ReportRepository(ApiProvider())));
    controller.selectedTransactionType.value = 'loan';
    controller.fetchTransactions(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final nearBottom = pos.extentAfter < 80; // safe trigger

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
    Get.delete<ReportRepayController>();
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

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'របាយការណ៍',
                      style: TextStyle(
                        color: themeController.theme.value?.textColor ?? Colors.white,
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
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            fontSize: 10,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Text(
                          'កម្ចី',
                          style: TextStyle(
                            color: themeController.theme.value?.textColor ?? Colors.white,
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
              const SizedBox(height: 15),

              // List + Pull-to-refresh
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
                      final key = date.isEmpty ? 'Unknown' : date;
                      grouped.putIfAbsent(key, () => <ReportModel>[]).add(txn);
                    }

                    final sortedDates = grouped.keys.toList()
                      ..sort((a, b) => b.compareTo(a)); // newest first

                    // Filter out completed in each group
                    final visibleDates = <String>[];
                    for (final d in sortedDates) {
                      final list = grouped[d]!.where((t) => t.isCompleted != true).toList();
                      if (list.isNotEmpty) visibleDates.add(d);
                      grouped[d] = list;
                    }

                    final showBottomLoader = controller.isLoading.value &&
                        controller.hasMore.value &&
                        controller.reports.isNotEmpty;

                    final itemCount = visibleDates.length + (showBottomLoader ? 1 : 0);

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        // Bottom loader
                        if (showBottomLoader && index == visibleDates.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final date = visibleDates[index];
                        final txns = grouped[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(
                                date,
                                style: TextStyle(
                                  color: themeController.theme.value?.textColor ?? Colors.white,
                                  fontFamily: 'MyBaseEnFont',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            ...txns.asMap().entries.map((entry) {
                              final txnIndex = entry.key;
                              final txn = entry.value;

                              // Unique, position-scoped key
                              final key = ValueKey('repay:sec:$index:${txn.transactionId ?? 'null'}:$date:$txnIndex');

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
                                      content: const Text("តើអ្នកប្រាកដជាចង់លុបប្រតិបត្តិការនេះមែនទេ?",
                                          style: TextStyle(fontFamily: 'MyBaseFont')),
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
                                  // If you support deleting whole transactions here, call controller.deleteTransaction(...)
                                  if (txn.transactionId != null) {
                                    controller.deleteTransaction(txn.transactionId!);
                                  }
                                },
                                child: _buildTransactionTile(context, txn, controller, themeController),
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

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
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

// ===================== Tile & Detail Sheet =====================

Widget _buildTransactionTile(
    BuildContext context,
    ReportModel txn,
    ReportRepayController controller,
    ThemeController themeController,
    ) {
  final isLoan = txn.transactionType == 'loan';
  final amountPrefix = isLoan ? '-' : '+';
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
    borderWidth: 0.95,
    elevation: 4.0,
    shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => _showTransactionDetailSheet(context, txn, controller, themeController),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                themeController.theme.value?.firstControlColor ?? Colors.black,
                (themeController.theme.value?.secondControlColor ?? Colors.black).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                color: (themeController.theme.value?.secondControlColor ?? Colors.white).withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              isLoan ? Icons.currency_exchange_outlined : Icons.savings,
              color: themeController.theme.value?.textColor ?? Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeController.theme.value?.firstControlColor ?? Colors.black,
                      (themeController.theme.value?.secondControlColor ?? Colors.black).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      "-${(txn.remainBalance ?? 0).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: 'MyBaseEnFont',
                        color: themeController.theme.value?.textColor ?? Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      txn.currencyType ?? '',
                      style: TextStyle(
                        fontFamily: 'MyBaseEnFont',
                        color: themeController.theme.value?.textColor ?? Colors.white,
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

void _showTransactionDetailSheet(
    BuildContext context,
    ReportModel txn,
    ReportRepayController controller,
    ThemeController themeController,
    ) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final txnHistory = txn.repayLoanDetails ?? [];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return Material(
        type: MaterialType.transparency,
        child: GlassContainer(
          height: 600,
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
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              top: 16,
            ),
            child: GlassContainer(
              height: 468,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        themeController.theme.value?.firstControlColor ?? Colors.black,
                                        (themeController.theme.value?.secondControlColor ?? Colors.black).withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.currency_exchange_outlined, color: Colors.white),
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
                            _payAllButton(txn, controller),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      _darkInfo("ចំនួនកម្ចី", "\$${(txn.amount ?? 0).toStringAsFixed(2)}"),
                      _darkInfo("ទឹកប្រាក់ជំពាក់", "-\$${(txn.remainBalance ?? 0).toStringAsFixed(2)}", color: Colors.redAccent),
                      _darkInfo("ថ្ងៃខ្ចី", "${txn.transactionDate ?? '-'}"),
                      _darkInfo("មូលហេតុ", "${txn.transactionDesc ?? '-'}"),
                      _darkInfo("រយះពេល", "${txn.remainDate ?? '-'} ថ្ងៃ", color: Colors.redAccent),
                      _darkInfo("ដោយ", "${txn.createdBy ?? '-'}", color: Colors.green),

                      const Divider(color: Colors.white10, height: 30),

                      Text(
                        "ប្រវត្តិសងប្រាក់",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MyBaseFont',
                        ),
                      ),
                      const SizedBox(height: 8),
                      txnHistory.isEmpty
                          ? const Text("ពុំមានប្រតិបត្តិការសង់ប្រាក់",
                          style: TextStyle(color: Colors.grey, fontFamily: 'MyBaseFont'))
                          : SizedBox(
                        height: 3 * 72,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: txnHistory.length,
                          itemBuilder: (context, index) {
                            final h = txnHistory[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => _showRepayHistoryDialog(context, h, txn, themeController),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      themeController.theme.value?.firstControlColor ?? Colors.black,
                                      (themeController.theme.value?.secondControlColor ?? Colors.black).withOpacity(0.9),
                                    ],
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
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "\$${(h.repayAmount ?? 0).toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    fontFamily: 'MyBaseFont',
                                                  ),
                                                ),
                                                Text(
                                                  "${h.repayDate ?? '-'}",
                                                  style: const TextStyle(
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
                                            _confirmRemoveRepayment(context, () {
                                              // ❗ Do NOT mutate list here. Let the controller do it.
                                              if ((h.repayId ?? '').isNotEmpty &&
                                                  (txn.transactionId ?? '').isNotEmpty) {
                                                controller.deleteRepayLoan(h.repayId!, txn.transactionId!);
                                              } else {
                                                Get.snackbar(
                                                  "មិនត្រឹមត្រូវ",
                                                  "ទិន្នន័យសងប្រាក់មិនពេញលេញ",
                                                  colorText: Colors.white,
                                                );
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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

                      const Divider(color: Colors.white10, height: 30),

                      // Add Repay Button or Form
                      Obx(() => controller.isRepayFormVisible.value
                          ? const SizedBox.shrink()
                          : Row(
                        children: [
                          Expanded(
                            child: _primaryGradientButton(
                              icon: Icons.create,
                              label: "បន្ថែម",
                              onPressed: () => controller.isRepayFormVisible.value = true,
                            ),
                          ),
                        ],
                      )),

                      Obx(() => controller.isRepayFormVisible.value
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "សងប្រាក់",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'MyBaseFont',
                            ),
                          ),
                          const SizedBox(height: 10),
                          _darkInputField(controller: amountController, hint: "ចំនួនទឹកប្រាក់សង", icon: Icons.attach_money),
                          const SizedBox(height: 10),
                          _darkInputField(controller: reasonController, hint: "ចំណាំ", icon: Icons.edit_note),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => controller.isRepayFormVisible.value = false,
                                child: const Text("បោះបង់", style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 10),
                              _primaryGradientButton(
                                icon: Icons.save,
                                label: "បញ្ចូល",
                                onPressed: () {
                                  final amount = amountController.text.trim();
                                  final reason = reasonController.text.trim();
                                  if (amount.isEmpty || reason.isEmpty) {
                                    Get.snackbar(
                                      "មិនត្រឹមត្រូវ",
                                      "សូមបំពេញព័តិមានអោយបានត្រឹមត្រូវ",
                                      colorText: app_colors.baseWhiteColor,
                                      icon: Icon(Icons.warning_amber_sharp, color: app_colors.baseWhiteColor),
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }
                                  final parsedAmount = double.tryParse(amount) ?? 0;
                                  if (parsedAmount > (txn.remainBalance ?? 0)) {
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
                                  if ((txn.transactionId ?? '').isNotEmpty) {
                                    controller.repayLoan(txn.transactionId!);
                                  }
                                  controller.isRepayFormVisible.value = false;
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _payAllButton(ReportModel txn, ReportRepayController controller) {
  return Container(
    padding: const EdgeInsets.all(8),
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
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.dialog(
          Dialog(
            backgroundColor: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "បញ្ចាក់សងប្រាក់",
                        style: TextStyle(
                          fontFamily: 'MyBaseFont',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "តើអ្នកប្រាកដជាចង់សងសរុប \$${(txn.remainBalance ?? 0).toStringAsFixed(2)} មែនទេ ?",
                    style: const TextStyle(
                      fontFamily: 'MyBaseFont',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("ទេ", style: TextStyle(color: Colors.blueAccent)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.data_saver_off, color: Colors.white, size: 18),
                        label: const Text("បាទ/ច់ា", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                        onPressed: () {
                          controller.repayAmount.value = (txn.remainBalance ?? 0).toStringAsFixed(2);
                          controller.repayDesc.value = 'សងផ្ដាច់';
                          if ((txn.transactionId ?? '').isNotEmpty) {
                            controller.repayLoan(txn.transactionId!);
                          }
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      child: Row(
        children: [
          Icon(Icons.data_saver_off, color: ApplicationVariable.themeTextColor),
          const SizedBox(width: 5),
          Text('សងទាំងអស់', style: TextStyle(color: ApplicationVariable.themeTextColor)),
        ],
      ),
    ),
  );
}

void _showRepayHistoryDialog(
    BuildContext context,
    RepayLoanDetail h,
    ReportModel txn,
    ThemeController themeController,
    ) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeController.theme.value?.firstControlColor ?? Colors.black,
              (themeController.theme.value?.secondControlColor ?? Colors.black).withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
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
                          colors: [
                            themeController.theme.value?.firstControlColor ?? Colors.black,
                            (themeController.theme.value?.secondControlColor ?? Colors.black).withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        boxShadow: [
                          BoxShadow(
                            color: (themeController.theme.value?.secondControlColor ?? Colors.white).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.currency_exchange_outlined, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "សងដោយផ្នែកលំអិត",
                      style: TextStyle(
                        fontFamily: 'MyBaseFont',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeController.theme.value?.textColor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    _receiptRow("ចំនួន", "\$${(h.repayAmount ?? 0).toStringAsFixed(2)}", color: Colors.green),
                    const Divider(color: Colors.black26, thickness: 1, height: 24),
                    _receiptRow("ថ្ងៃសងប្រាក់", h.repayDate ?? "-"),
                    if ((h.repayDesc ?? '').isNotEmpty) ...[
                      const Divider(color: Colors.black26, thickness: 1, height: 24),
                      _receiptRow("ចំណាំ", h.repayDesc!),
                    ],
                    if ((h.repayId ?? '').isNotEmpty) ...[
                      const Divider(color: Colors.black26, thickness: 1, height: 24),
                      _receiptRow("លេខសំគាល់", h.repayId!, fontSize: 10),
                    ],
                    if ((txn.transactionId ?? '').isNotEmpty) ...[
                      _receiptRow("លេខសំគាល់ដើម", txn.transactionId!, fontSize: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: _primaryGradientButton(
                    icon: Icons.close,
                    label: "បិទ",
                    onPressed: () => Get.back(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

void _confirmRemoveRepayment(BuildContext context, VoidCallback onConfirm) {
  Get.dialog(
    Dialog(
      backgroundColor: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
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
            const SizedBox(height: 16),
            const Text(
              "Are you sure you want to remove this repayment entry?",
              style: TextStyle(
                fontFamily: 'MyBaseFont',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel", style: TextStyle(color: Colors.blueAccent)),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                  label: const Text("Remove", style: TextStyle(fontWeight: FontWeight.w600)),
                  onPressed: () {
                    onConfirm();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget _primaryGradientButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ApplicationVariable.themeFirstGradientColor,
          ApplicationVariable.themeSecondGradientColor
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: ApplicationVariable.themeTextColor),
      label: Text(label, style: TextStyle(color: ApplicationVariable.themeTextColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
  );
}

Widget _darkInfo(String label, String value, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'MyBaseFont',
              fontWeight: FontWeight.normal,
            )),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.white,
              fontFamily: 'MyBaseFont',
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _darkInputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
}) {
  return TextField(
    controller: controller,
    keyboardType: hint.contains("ចំនួន")
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
          fontSize: fontSize ?? 14,
          fontFamily: 'MyBaseFont',
          fontWeight: FontWeight.bold,
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color ?? Colors.black,
            fontSize: fontSize ?? 14,
            fontFamily: 'MyBaseFont',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
