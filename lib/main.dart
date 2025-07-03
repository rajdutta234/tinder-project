import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/app_theme.dart';
import 'routes/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/swipe_controller.dart';
import 'controllers/matches_controller.dart';
import 'controllers/settings_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register controllers
  Get.put(AuthController(), permanent: true);
  Get.put(SwipeController(), permanent: true);
  Get.put(MatchesController(), permanent: true);
  Get.put(SettingsController(), permanent: true);
  runApp(const U2MeApp());
}

class U2MeApp extends StatelessWidget {
  const U2MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U2Me',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsController.theme,
      initialRoute: AppRoutes.auth,
      getPages: AppRoutes.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ));
  }
}
