import 'dart:convert';
import 'dart:ffi';

import 'package:saving_helper/models/ThemeData.dart';
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

  Future<void> saveTheme(ThemeDataModel theme) async {
    final prefs = await SharedPreferences.getInstance();
    final themeJson = jsonEncode(theme.toJson());
    await prefs.setString('theme_path', themeJson);
  }

  Future<ThemeDataModel?> getTheme() async {
   try{
     final prefs = await SharedPreferences.getInstance();
     final themeJson = prefs.getString('theme_path');
     if (themeJson == null) return null;
     final Map<String, dynamic> themeMap = jsonDecode(themeJson);
     return ThemeDataModel.fromJson(themeMap);
   } catch (e) {
     print('SMEY ______________________ ' + e.toString());
     return null;
   }
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

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////// CURRENT_GROUP_NAME ///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> removeGroupName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('group_name');
  }

  Future<void> saveGroupName(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('group_name', groupId);
  }

  Future<String?> getGroupName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('group_name');
  }

}