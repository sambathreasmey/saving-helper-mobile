import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/constants/app_color.dart' as app_colors;
import 'package:saving_helper/controllers/member_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/member_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late MemberController controller;

  final ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    controller = Get.put(MemberController(MemberRepository(ApiProvider())));
    controller.getMember();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomHeader(),
              const SizedBox(height: 15),

              // Title
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'សមាជិក',
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
                          'គ្រប់គ្រង /',
                          style: TextStyle(
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            fontSize: 9,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Text(
                          'សមាជិក',
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

              const SizedBox(height: 24),

              // Member List (API loaded only)
              Obx(() {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final members = controller.groupMembers.value ?? [];

                if (members.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'មិនមានសមាជិក',
                        style: TextStyle(color: app_colors.subTitleText),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final role = member.role ?? member.userDetail?.role ?? 'Unknown';
                      final roleColor = _roleColor(role);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                              color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                getInitials(member.userDetail?.fullName ?? ''),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15,),
                              ),
                            ),
                          ),
                          title: Text(
                            member.userDetail?.fullName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyBaseFont',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            member.userDetail?.emailAddress ?? '',
                            style: const TextStyle(fontSize: 13, fontFamily: 'MyBaseFont', color: Colors.white70),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: roleColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              formatRole(role),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
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

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return Colors.deepPurpleAccent.shade700;
      case 'reporter':
        return Colors.pinkAccent;
      case 'user':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String formatRole(String role) {
    if (role.isEmpty) return role;
    return role[0].toUpperCase() + role.substring(1).toLowerCase();
  }
}

String getInitials(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) return '';
  final parts = fullName.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts[0][0].toUpperCase();
  }
  final first = parts.first[0];
  final last = parts.last[0];
  return (first + last).toUpperCase();
}
