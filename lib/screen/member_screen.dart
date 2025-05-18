import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/constants/app_color.dart' as app_colors;
import 'package:saving_helper/controllers/member_controller.dart';
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MemberController(MemberRepository(ApiProvider())));
    controller.getMember();
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _editingIndex = null;
  }

  // Since your controller does not yet have add/edit/delete, this is local temporary:
  final RxList<Map<String, String>> _localMembers = <Map<String, String>>[].obs;

  void _saveMember() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;

    setState(() {
      if (_editingIndex == null) {
        _localMembers.add({'name': name, 'email': email});
      } else {
        _localMembers[_editingIndex!] = {'name': name, 'email': email};
      }
      _resetForm();
    });
  }

  void _editMember(int index) {
    final member = _localMembers[index];
    _nameController.text = member['name'] ?? '';
    _emailController.text = member['email'] ?? '';
    setState(() => _editingIndex = index);
  }

  void _deleteMember(int index) {
    setState(() => _localMembers.removeAt(index));
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
                          'សមាជិក',
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

              const SizedBox(height: 24),

              // Member List (API loaded)
              Obx(() {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final members = controller.groupMembers.value ?? [];
                if (members.isEmpty && _localMembers.isEmpty) {
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
                    itemCount: members.length + _localMembers.length,
                    // separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      if (index < members.length) {
                        final member = members[index];
                        final role = member.role ?? member.userDetail?.role ?? 'Unknown';
                        final roleColor = _roleColor(role);

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.pinkAccent, Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Text(
                                getInitials(member.userDetail?.fullName ?? ''),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              member.userDetail?.fullName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyBaseFont',
                                color: Colors.white,
                                fontSize: 16,
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
                      } else {
                        final localIndex = index - members.length;
                        final member = _localMembers[localIndex];
                        final role = member['role'] ?? 'User';
                        final roleColor = _roleColor(role);

                        return Dismissible(
                          key: ValueKey(localIndex),
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
                                content: const Text("តើអ្នកប្រាកដជាចង់លុបសមាជិកនេះមែនទេ?", style: TextStyle(fontFamily: 'MyBaseFont')),
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
                          onDismissed: (direction) => _deleteMember(localIndex),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.pinkAccent, Colors.blueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white24,
                                child: Text(
                                  getInitials(member['name'] ?? ''),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                member['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MyBaseFont',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                member['email'] ?? '',
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
                              onTap: () => _editMember(localIndex),
                            ),
                          ),
                        );
                      }
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
    // Only one name, take first letter only
    return parts[0][0].toUpperCase();
  }
  final first = parts.first[0];
  final last = parts.last[0];
  return (first + last).toUpperCase();
}
