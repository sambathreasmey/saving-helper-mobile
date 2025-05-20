import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:saving_helper/models/responses/login_response.dart' as LoginResponse;

class ShareStorage {

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////// USER CREDENTIAL ///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> saveUserCredential(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<String?> getUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> removeUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  // Save User object as JSON string
  Future<void> saveUser(LoginResponse.Data user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user_data', userJson);
  }

// Retrieve User object from JSON string
  Future<LoginResponse.Data?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return LoginResponse.Data.fromJson(userMap);
  }

// Remove stored User object
  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////// TOKEN ////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<void> saveToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////// THEME ////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> removeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme_path');
  }

  Future<void> saveTheme(String themePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_path', themePath);
  }

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme_path');
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////// CURRENT_GROUP_ID ///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> removeGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('group_id');
  }

  Future<void> saveGroupId(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('group_id', groupId);
  }

  Future<String?> getGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('group_id');
  }

}