import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/controllers/loan_controller.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';
import '../constants/app_color.dart' as app_colors;

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final LoanController controller = Get.put(
    LoanController(DepositSavingRepository(ApiProvider())),
  );

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomHeader(),
                    const SizedBox(height: 16),
                    _buildBreadcrumb(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildAmountField(),
                      const SizedBox(height: 16),
                      _buildCurrencyPicker(),
                      const SizedBox(height: 16),
                      _buildDatePicker(),
                      const SizedBox(height: 16),
                      _buildNoteField(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: controller.saveLoan,
                child: Text('បញ្ចូល', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('គ្រប់គ្រង',
              style: TextStyle(
                  color: app_colors.baseWhiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyBaseFont')),
          Row(
            children: [
              Text('គ្រប់គ្រង /',
                  style: TextStyle(
                      color: app_colors.subTitleText,
                      fontSize: 9,
                      fontFamily: 'MyBaseFont')),
              Text('បញ្ចូលប្រាក់កម្ចី',
                  style: TextStyle(
                      color: app_colors.baseWhiteColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyBaseFont')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: controller.amountController,
      onChanged: (v) => controller.amount.value = v,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: _inputDecoration('ទំហំសាច់ប្រាក់', Icons.account_balance_wallet_outlined),
    );
  }

  Widget _buildCurrencyPicker() {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => openSelectCategory(),
      ),
      child: Obx(() => TextField(
        enabled: false,
        decoration: _inputDecoration(
          controller.selectedCurrency.value.isEmpty
              ? "សូមជ្រើសរើសប្រភេទសាច់ប្រាក់"
              : controller.selectedCurrency.value,
          Icons.arrow_drop_down,
        ),
        style: Theme.of(context).textTheme.titleMedium?.apply(
            fontFamily: 'MyBaseFont',
            color: app_colors.baseWhiteColor),
      )),
    );
  }

  Widget _buildDatePicker() {
    return Obx(() => GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.selectedDate.value =
              DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: _inputDecoration(
            controller.selectedDate.value.isEmpty
                ? "ថ្ងៃខែឆ្នាំ"
                : controller.selectedDate.value,
            Icons.calendar_today,
          ),
        ),
      ),
    ));
  }

  Widget _buildNoteField() {
    return TextField(
      controller: controller.transactionDescController,
      onChanged: (v) => controller.transactionDesc.value = v,
      decoration: _inputDecoration('មូលហេតុ', Icons.note_alt_outlined),
    );
  }

  // Widget _buildImageUploader() {
  //   return Obx(() => Column(
  //     children: [
  //       controller.selectedImage.value != null
  //           ? ClipRRect(
  //         borderRadius: BorderRadius.circular(10),
  //         child: Image.file(
  //           File(controller.selectedImage.value!.path),
  //           height: 150,
  //           width: double.infinity,
  //           fit: BoxFit.cover,
  //         ),
  //       )
  //           : Container(
  //         height: 150,
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: Colors.grey.shade300,
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(color: Colors.grey),
  //         ),
  //         child: Icon(Icons.image_outlined,
  //             size: 40, color: Colors.grey[600]),
  //       ),
  //       const SizedBox(height: 8),
  //       SizedBox(
  //         width: double.infinity,
  //         child: OutlinedButton.icon(
  //           icon: const Icon(Icons.upload),
  //           label: const Text('បញ្ចូលរូបភាព'),
  //           onPressed: controller.pickImage,
  //           style: OutlinedButton.styleFrom(
  //             foregroundColor: app_colors.baseColor,
  //             side: BorderSide(color: app_colors.baseColor),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ));
  // }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: Icon(icon),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue)),
    );
  }

  Widget openSelectCategory() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.1,
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      decoration: BoxDecoration(
        color: app_colors.baseWhiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(child: Text("សូមជ្រើសរើសប្រភេទសាច់ប្រាក់",style: TextStyle(
              color: Colors.white,
              fontFamily: 'MyBaseFont',
              fontSize: 14,
            ),),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.currencyList.length,
              itemBuilder: (context, index) {
                final currency = controller.currencyList[index];
                return InkWell(
                  onTap: () {
                    controller.selectedCurrency.value = currency;
                    Get.back();
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Text(currency,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.apply(
                            fontFamily: 'MyBaseFont',
                            color: app_colors.baseColor)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}