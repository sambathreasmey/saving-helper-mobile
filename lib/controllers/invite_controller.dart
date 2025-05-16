import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InviteController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  String? selectedGroup;

  List<String> groups = ['ក្រុមសន្សំទី 1', 'ក្រុមសន្សំទី 2', 'ក្រុមសន្សំទី 3'];

  void clear() {
    searchController.clear();
    selectedGroup = null;
  }

  bool validate() {
    return searchController.text.trim().isNotEmpty && selectedGroup != null;
  }

  String get username => searchController.text.trim();

  void dispose() {
    searchController.dispose();
  }
}
