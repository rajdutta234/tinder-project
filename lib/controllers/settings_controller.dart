import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  var isDarkMode = false.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool showOnlineStatus = true.obs;

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = false; // Default to light mode
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode') ?? 'system';
    final notif = prefs.getBool('notifications_enabled') ?? true;
    final online = prefs.getBool('show_online_status') ?? true;
    isDarkMode.value = _themeFromString(theme) == ThemeMode.dark;
    notificationsEnabled.value = notif;
    showOnlineStatus.value = online;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    isDarkMode.value = mode == ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeToString(mode));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
  }

  Future<void> setShowOnlineStatus(bool show) async {
    showOnlineStatus.value = show;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_online_status', show);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(theme);
  }

  ThemeMode _themeFromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
} 