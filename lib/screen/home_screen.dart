
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/home_screen_controller.dart';
import 'package:saving_helper/repository/home_repository.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';

import '../constants/app_color.dart' as app_colors;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final HomeController controller = Get.put(HomeController(HomeRepository(ApiProvider())));

  @override
  void initState() {
    Get.delete<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'), // Replace with your image path
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomHeader(),
                  SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Dashboard',  // Use null-aware operator to safely access userName
                            style: TextStyle(
                              color: app_colors.baseWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyBaseFont',
                            ),
                          ),
                        Row(
                          children: [
                            Text('Home /',
                              style: TextStyle(
                                color: app_colors.subTitleText,
                                fontSize: 9,
                              ),),
                            Text(' Dashboard',
                              style: TextStyle(
                                color: app_colors.baseWhiteColor,
                                fontSize: 9,
                                fontFamily: 'MyBaseFont',
                              ),),
                          ],
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20,),

                  // Saving Component Start
                  Center(
                    child: ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // ignore: deprecated_member_use
                          color: app_colors.baseWhiteColor.withOpacity(0.1),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: app_colors.baseWhiteColor.withOpacity(0.2), // Set the border color
                            width: 1.0, // Set the border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                ),
                                // ignore: deprecated_member_use
                                color: app_colors.baseColor.withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('សន្សំ ',
                                          style: TextStyle(
                                            color: app_colors.baseWhiteColor,
                                            fontSize: 12,
                                            fontFamily: 'MyBaseFont',
                                          ),),
                                        Text('| ទាំងអស់',
                                          style: TextStyle(
                                            color: app_colors.subTitleText,
                                            fontSize: 12,
                                            fontFamily: 'MyBaseFont',
                                          ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: app_colors.iconSavingColorBackground,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.savings_outlined, size: 25,
                                        color: app_colors.iconSavingColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Text('\$${controller.dashboard.value?.totalSavingDeposit ?? '0.0'}',
                                                style: TextStyle(
                                                  color: app_colors
                                                      .baseWhiteColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'MyBaseFont',
                                                ),);
                                            }),
                                            Row(
                                              children: [
                                                Text('12%',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                                SizedBox(width: 8,),
                                                Text('increase',
                                                  style: TextStyle(
                                                    color: app_colors.subTitleText,
                                                    fontSize: 10,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Obx(() {
                                                  return Text('+\$${controller.dashboard.value?.savingToday ?? ''}',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'MyBaseFont',
                                                    ),
                                                  );
                                                }),
                                                SizedBox(width: 8,),
                                                Text('ថ្ងៃនេះ',
                                                  style: TextStyle(
                                                    color: app_colors.subTitleText,
                                                    fontSize: 10,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Obx(() {
                                                  return Text('+\$${controller.dashboard.value?.savingYesterday ?? ''}',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'MyBaseFont',
                                                    ),
                                                  );
                                                }),
                                                SizedBox(width: 8,),
                                                Text('ម្សិលមិញ',
                                                  style: TextStyle(
                                                    color: app_colors.subTitleText,
                                                    fontSize: 10,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Obx(() {
                                                  return Text('+\$${controller.dashboard.value?.savingThisMonth ?? ''}',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'MyBaseFont',
                                                    ),
                                                  );
                                                }),
                                                SizedBox(width: 8,),
                                                Text('១ខែចុងក្រោយ',
                                                  style: TextStyle(
                                                    color: app_colors.subTitleText,
                                                    fontSize: 10,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Saving Component End

                  SizedBox(height: 20,),

                  // Load Component Start
                  Center(
                    child: ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // ignore: deprecated_member_use
                          color: app_colors.baseWhiteColor.withOpacity(0.1),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: app_colors.baseWhiteColor.withOpacity(0.2), // Set the border color
                            width: 1.0, // Set the border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                ),
                                // ignore: deprecated_member_use
                                color: app_colors.baseColor.withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('កម្ចី ',
                                          style: TextStyle(
                                            color: app_colors.baseWhiteColor,
                                            fontSize: 12,
                                            fontFamily: 'MyBaseFont',
                                          ),),
                                        Text('| ទាំងអស់',
                                          style: TextStyle(
                                            color: app_colors.subTitleText,
                                            fontSize: 12,
                                            fontFamily: 'MyBaseFont',
                                          ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: app_colors.iconCurrencyColorBackground,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.currency_exchange_sharp, size: 25,
                                        color: app_colors.iconCurrencyColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Text('\$${controller.dashboard.value?.loanBalance ?? '0.0'}',
                                                style: TextStyle(
                                                  color: app_colors
                                                      .baseWhiteColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'MyBaseFont',
                                                ),);
                                            }),
                                            Row(
                                              children: [
                                                Text('12%',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                                SizedBox(width: 8,),
                                                Text('increase',
                                                  style: TextStyle(
                                                    color: app_colors.subTitleText,
                                                    fontSize: 10,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Column(
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Row(
                                        //       children: [
                                        //         Text('+\$40',
                                        //           style: TextStyle(
                                        //             color: Colors.green,
                                        //             fontSize: 10,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //         SizedBox(width: 8,),
                                        //         Text('ថ្ងៃនេះ',
                                        //           style: TextStyle(
                                        //             color: app_colors.subTitleText,
                                        //             fontSize: 10,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //       ],
                                        //     ),
                                        //     Row(
                                        //       children: [
                                        //           Text('+\$20',
                                        //           style: TextStyle(
                                        //             color: Colors.green,
                                        //             fontSize: 10,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //         SizedBox(width: 8,),
                                        //         Text('ម្សិលមិញ',
                                        //           style: TextStyle(
                                        //             color: app_colors.subTitleText,
                                        //             fontSize: 10,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //       ],
                                        //     ),
                                        //     Row(
                                        //       children: [
                                        //         Text('+\$20',
                                        //           style: TextStyle(
                                        //             color: Colors.green,
                                        //             fontSize: 10,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //         SizedBox(width: 8,),
                                        //         Text('១ខែចុងក្រោយ',
                                        //           style: TextStyle(
                                        //             color: app_colors.subTitleText,
                                        //             fontSize: 10,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Load Component End

                  SizedBox(height: 20,),

                  // Balance Component Start
                  Center(
                    child: ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // ignore: deprecated_member_use
                          color: app_colors.baseWhiteColor.withOpacity(0.1),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: app_colors.baseWhiteColor.withOpacity(0.2), // Set the border color
                            width: 1.0, // Set the border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                ),
                                // ignore: deprecated_member_use
                                color: app_colors.baseColor.withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('សមតុល្យ ',
                                          style: TextStyle(
                                            color: app_colors.baseWhiteColor,
                                            fontSize: 12,
                                            fontFamily: 'MyBaseFont',
                                          ),),
                                        Text('| ទាំងអស់',
                                          style: TextStyle(
                                            color: app_colors.subTitleText,
                                            fontSize: 12,
                                            fontFamily: 'MyBaseFont',
                                          ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: app_colors.iconBalanceColorBackground,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.credit_card_rounded, size: 25,
                                        color: app_colors.iconBalanceColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Text('\$${controller.dashboard.value?.balance ?? '0.0'}',
                                                style: TextStyle(
                                                  color: app_colors
                                                      .baseWhiteColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'MyBaseFont',
                                                ),);
                                            }),
                                            Row(
                                              children: [
                                                Text('5%',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                                SizedBox(width: 8,),
                                                Text('increase',
                                                  style: TextStyle(
                                                    color: app_colors.subTitleText,
                                                    fontSize: 10,
                                                    fontFamily: 'MyBaseFont',
                                                  ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Column(
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Row(
                                        //       children: [
                                        //         Text('+\$40',
                                        //           style: TextStyle(
                                        //             color: Colors.green,
                                        //             fontSize: 10,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //         SizedBox(width: 8,),
                                        //         Text('ថ្ងៃនេះ',
                                        //           style: TextStyle(
                                        //             color: app_colors.subTitleText,
                                        //             fontSize: 10,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //       ],
                                        //     ),
                                        //     Row(
                                        //       children: [
                                        //         Text('+\$20',
                                        //           style: TextStyle(
                                        //             color: Colors.green,
                                        //             fontSize: 10,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //         SizedBox(width: 8,),
                                        //         Text('ម្សិលមិញ',
                                        //           style: TextStyle(
                                        //             color: app_colors.subTitleText,
                                        //             fontSize: 10,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //       ],
                                        //     ),
                                        //     Row(
                                        //       children: [
                                        //         Text('+\$20',
                                        //           style: TextStyle(
                                        //             color: Colors.green,
                                        //             fontSize: 10,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //         SizedBox(width: 8,),
                                        //         Text('១ខែចុងក្រោយ',
                                        //           style: TextStyle(
                                        //             color: app_colors.subTitleText,
                                        //             fontSize: 10,
                                        //             fontFamily: 'MyBaseFont',
                                        //           ),),
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Balance Component End
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}