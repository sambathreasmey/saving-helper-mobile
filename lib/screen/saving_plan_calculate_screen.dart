import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/controllers/saving_plan_calculate_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/saving_plan_calculate_repository.dart';
import 'package:saving_helper/screen/widgets/input_field/DatePickerWidget.dart';
import 'package:saving_helper/services/api_provider.dart';

class SavingPlanCalculateScreen extends StatefulWidget {
  const SavingPlanCalculateScreen({super.key});

  @override
  State<SavingPlanCalculateScreen> createState() => _SavingPlanCalculateScreenState();
}

class _SavingPlanCalculateScreenState extends State<SavingPlanCalculateScreen> with SingleTickerProviderStateMixin {
  final SavingPlanCalculateController controller = Get.put(SavingPlanCalculateController(SavingPlanCalculateRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());

  final List<List<Color>> _gradientPairs = [
    [Colors.deepPurpleAccent, Colors.purpleAccent],
    [Colors.pinkAccent, Colors.orangeAccent],
    [Colors.indigoAccent, Colors.deepPurple],
  ];

  late List<Color> _currentColors;
  late Timer _timer;

  late AnimationController _textAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ** Moved these fields here for state persistence **
  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController currentAmountController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  void _changeGradient() {
    final random = Random();
    setState(() {
      _currentColors = _gradientPairs[random.nextInt(_gradientPairs.length)];
    });

    _textAnimationController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _currentColors = _gradientPairs.first;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _changeGradient());

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );

    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _textAnimationController.dispose();
    goalAmountController.dispose();
    currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    themeController.theme.value?.firstControlColor ?? Colors.black,
                    themeController.theme.value?.secondControlColor ?? Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeController.theme.value?.secondControlColor?.withOpacity(0.5) ?? Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Banner image stays at top as you wanted
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            'assets/images/calculate_banner.png',
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'គណនាផែនការសន្សំប្រាក់',
                                style: TextStyle(
                                  fontFamily: 'MyBaseFont',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: themeController.theme.value?.textColor ?? Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'សូមបញ្ចូលព័ត៏មានខាងក្រោម ដើម្បីគណនាប្រាក់សន្សំ។',
                                style: TextStyle(
                                  fontFamily: 'MyBaseFont',
                                  fontSize: 14,
                                  color: themeController.theme.value?.textColor ?? Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              _buildGoalAmountField(),
                              const SizedBox(height: 12),
                              _buildCurrentAmountField(required: false),
                              const SizedBox(height: 12),
                              DatePickerWidget(
                                label: 'ចាប់ពីថ្ងៃ',
                                selectedDate: controller.selectedStartDate,
                                firstControlColor: themeController.theme.value?.firstControlColor ?? Colors.black,
                                secondControlColor: themeController.theme.value?.secondControlColor ?? Colors.black,
                                textColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                              const SizedBox(height: 12),
                              DatePickerWidget(
                                label: 'ដល់ថ្ងៃ',
                                selectedDate: controller.selectedEndDate,
                                firstControlColor: themeController.theme.value?.firstControlColor ?? Colors.black,
                                secondControlColor: themeController.theme.value?.secondControlColor ?? Colors.black,
                                textColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                              const SizedBox(height: 24),

                              Obx(() {
                                if (controller.isLoading.value) {
                                  return const Center(child: CircularProgressIndicator());
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      controller.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'បិទ',
                                      style: TextStyle(
                                        fontFamily: 'MyBaseFont',
                                        fontWeight: FontWeight.bold,
                                        color: themeController.theme.value?.textColor ?? Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          themeController.theme.value?.firstControlColor ?? Colors.black,
                                          themeController.theme.value?.secondControlColor ?? Colors.black,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                                          blurRadius: 3,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        controller.calculate(); // wait for calculation to complete
                                        showResultDialog(context, controller, themeController);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                                        child: Text(
                                          'គណនា',
                                          style: TextStyle(
                                            fontFamily: 'MyBaseFont',
                                            fontWeight: FontWeight.bold,
                                            color: themeController.theme.value?.textColor ?? Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _currentColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(21),
                boxShadow: [
                  BoxShadow(
                    color: _currentColors.first.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const Icon(
                      Icons.calculate,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const SizedBox(
            width: 60,
            child: Text(
              'គណនាផែនការប្រាក់សន្សំ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'MyBaseFont',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalAmountField({bool required = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.goalAmountController,
        onChanged: (value) {
          final parsed = double.tryParse(value);
          controller.goalAmount.value = parsed ?? 0.0;
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: required ? 'គម្រោងប្រាក់សន្សំ *' : 'គម្រោងប្រាក់សន្សំ (optional)',
          prefixIcon: const Icon(Icons.monetization_on_outlined),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontFamily: 'MyBaseFont', color: Colors.black87),
      ),
    );
  }

  Widget _buildCurrentAmountField({bool required = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.currentAmountController,
        onChanged: (value) {
          final parsed = double.tryParse(value);
          controller.currentAmount.value = parsed ?? 0.0;
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: required ? 'ប្រាក់សន្សំបច្ចុប្បន្ន *' : 'ប្រាក់សន្សំបច្ចុប្បន្ន (optional)',
          prefixIcon: const Icon(Icons.savings_outlined),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontFamily: 'MyBaseFont', color: Colors.black87),
      ),
    );
  }

  Widget _buildStartDatePicker() {
    return Obx(() => GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: controller.selectedStartDate.value.isNotEmpty
              ? DateTime.parse(controller.selectedStartDate.value)
              : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.selectedStartDate.value =
              DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(
              text: controller.selectedStartDate.value.isEmpty
                  ? ''
                  : controller.selectedStartDate.value,
            ),
            decoration: InputDecoration(
              labelText: "ថ្ងៃចាប់ផ្ដើម",
              prefixIcon: const Icon(Icons.calendar_month),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: const TextStyle(fontFamily: 'MyBaseFont', color: Colors.black87),
          ),
        ),
      ),
    ));
  }

  Widget _buildEndDatePicker() {
    return Obx(() => GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: controller.selectedEndDate.value.isNotEmpty
              ? DateTime.parse(controller.selectedEndDate.value)
              : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.selectedEndDate.value =
              DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(
              text: controller.selectedEndDate.value.isEmpty
                  ? ''
                  : controller.selectedEndDate.value,
            ),
            decoration: InputDecoration(
              labelText: "ថ្ងៃបញ្ចប់",
              prefixIcon: const Icon(Icons.calendar_month),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: const TextStyle(fontFamily: 'MyBaseFont', color: Colors.black87),
          ),
        ),
      ),
    ));
  }

}

void showResultDialog(BuildContext context, SavingPlanCalculateController controller, ThemeController themeController) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeController.theme.value?.firstControlColor ?? Colors.black,
              themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                          colors: [
                            themeController.theme.value?.firstControlColor ?? Colors.black,
                            themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        boxShadow: [
                          BoxShadow(
                            color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.currency_exchange_outlined,
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "លទ្ធផលការគណនា",
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

              // Result container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Obx(() {
                  final data = controller.data.value;
                  if (data == null) {
                    return Text(
                      "មិនមានទិន្នន័យ",
                      style: TextStyle(
                        fontFamily: 'MyBaseFont',
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      _resultRow("ប្រចាំថ្ងៃ", data.daily ?? 0.0, themeController),
                      const Divider(color: Colors.black26, thickness: 1, height: 24),
                      _resultRow("ប្រចាំអាទិត្យ", data.weekly ?? 0.0, themeController),
                      const Divider(color: Colors.black26, thickness: 1, height: 24),
                      _resultRow("ប្រចាំខែ", data.monthly ?? 0.0, themeController),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          themeController.theme.value?.firstControlColor ?? Colors.black,
                          themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: themeController.theme.value?.textColor ?? Colors.white,
                      ),
                      label: Text(
                        "បិទ",
                        style: TextStyle(
                          color: themeController.theme.value?.textColor ?? Colors.white,
                          fontFamily: 'MyBaseFont',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
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

final _numberFormatter = NumberFormat('#,##0.00');

Widget _resultRow(String label, double value, ThemeController themeController) {
  final color = Colors.green.withOpacity(0.9);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'MyBaseFont',
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "+${_numberFormatter.format(value)}",
              style: TextStyle(
                fontFamily: 'MyBaseEnFont',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            TextSpan(
              text: ' USD',
              style: TextStyle(
                fontFamily: 'MyBaseEnFont',
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}