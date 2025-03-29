import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/controllers/deposit_saving_controller.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:get/get.dart';

import '../constants/app_color.dart' as app_colors;

class DepositSavingScreen extends StatefulWidget {
  const DepositSavingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DepositSavingScreenState createState() => _DepositSavingScreenState();
}

class _DepositSavingScreenState extends State<DepositSavingScreen> {
  final DepositSavingController controller = Get.put(DepositSavingController(DepositSavingRepository(ApiProvider())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                  CustomHeader(),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'គ្រប់គ្រង',
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
                              'គ្រប់គ្រង /',
                              style: TextStyle(
                                color: app_colors.subTitleText,
                                fontSize: 9,
                                fontFamily: 'MyBaseFont',
                              ),
                            ),
                            Text(
                              'បញ្ចូលប្រាក់សន្សំ',
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        TextField(
                          controller: controller.amountController,
                          onChanged: (value) {
                            controller.amount.value = value;
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Allow numbers and up to 2 decimal places
                            // You can also use a custom formatter to format as currency
                          ],
                          decoration: InputDecoration(
                            labelText: 'ចំនួនទឹកប្រាក់',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.account_balance_wallet_outlined),
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return openSelectCategory();
                              },
                            );
                          },
                          child: Obx(() => TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              filled: true, // Enable filling
                              fillColor: Colors.white, // Set background color to white
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                              labelText: controller.selectedCurrency.value.isEmpty ? "សូមជ្រើសរើសប្រភេទសាច់ប្រាក់" : controller.selectedCurrency.value,
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set border radius
                                borderSide: BorderSide(color: Colors.grey), // Border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Same radius for enabled state
                                borderSide: BorderSide(color: Colors.grey), // Border color when enabled
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Same radius for focused state
                                borderSide: BorderSide(color: Colors.blue), // Border color when focused
                              ),
                            ),
                            style: Theme.of(context).textTheme.titleMedium?.apply(fontFamily: 'MyBaseFont', color: app_colors.baseWhiteColor),
                          )),
                        ),
                        SizedBox(height: 16.0),
                        Obx(() => GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              controller.selectedDate.value = formattedDate;
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: controller.selectedDate.value.isEmpty ? "ថ្ងៃខែឆ្នាំ" : controller.selectedDate.value,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        )),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: controller.transactionDescController,
                          onChanged: (value) {
                            controller.transactionDesc.value = value; // Update the reactive amount
                          },
                          decoration: InputDecoration(
                            labelText: 'កំណត់ចំណាំ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.note_alt_outlined),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Obx(() => CheckboxListTile(
                        title: Text('បន្ថែមលើប្រតិបត្តិចាស់ក្នុងថ្ងៃ', style: TextStyle(color: app_colors.baseWhiteColor, fontFamily: 'MyBaseFont'),),
                        value: controller.isSavingMore.value,
                        onChanged: (value) {
                        controller.isSavingMore.value = value ?? false; // Update the reactive variable
                        },
                        )),
                        SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: app_colors.loveColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () {
                              controller.saveDeposit();
                            },
                            child: Text('បញ្ចូល', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,)),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  openSelectCategory() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.3,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: app_colors.baseWhiteColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              color: app_colors.baseWhiteColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [app_colors.loveColor, app_colors.baseColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Text(
                "សូមជ្រើសរើសប្រភេទសាច់ប្រាក់",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text(
                          currency,
                          style: Theme.of(context).textTheme.titleMedium?.apply(fontFamily: 'MyBaseFont', color: app_colors.baseColor),
                        ),
                      ),
                      Divider(color: app_colors.baseWhiteColor),
                    ],
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