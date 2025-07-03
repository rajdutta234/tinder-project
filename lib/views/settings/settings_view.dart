import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/auth_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController settingsController = Get.find<SettingsController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        children: [
          ListTile(
            leading: Icon(Icons.person_outline, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            title: Text('Edit Profile', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            onTap: () => Get.toNamed(AppRoutes.editProfile),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            title: Text('Change Password', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            onTap: () => _showChangePasswordDialog(context),
          ),
          SwitchListTile(
            secondary: Icon(Icons.notifications_active_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            title: Text('Enable Notifications', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            value: settingsController.notificationsEnabled.value,
            onChanged: (val) => settingsController.setNotificationsEnabled(val),
          ),
          SwitchListTile(
            secondary: Icon(Icons.visibility_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            title: Text('Show Online Status', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            value: settingsController.showOnlineStatus.value,
            onChanged: (val) => settingsController.setShowOnlineStatus(val),
          ),
          SwitchListTile(
            secondary: Icon(Icons.dark_mode_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            title: Text('Dark Mode', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            value: settingsController.isDarkMode.value,
            onChanged: (val) => settingsController.toggleTheme(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: () => authController.signOut(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: const Text('Delete Account', style: TextStyle(color: AppColors.error)),
            onTap: () => _showDeleteDialog(context),
          ),
        ],
      )),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authController.deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController oldPass = TextEditingController();
        final TextEditingController newPass = TextEditingController();
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPass,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current Password'),
              ),
              TextField(
                controller: newPass,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement real change password logic
                Navigator.of(context).pop();
                Get.snackbar('Coming Soon', 'Change password feature will be available soon!', snackPosition: SnackPosition.BOTTOM);
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }
} 