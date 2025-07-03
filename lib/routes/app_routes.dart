import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/main/main_view.dart';
import '../views/swipe/swipe_view.dart';
import '../views/main/matches/matches_view.dart';
import '../views/main/matches/chat_view.dart';
import '../views/profile/profile_view.dart';
import '../views/profile/edit_profile_view.dart';
import '../views/settings/settings_view.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String swipe = '/swipe';
  static const String matches = '/matches';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  
  static final routes = [
    GetPage(
      name: auth,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => const SignupView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: main,
      page: () => const MainView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: swipe,
      page: () => const SwipeView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: matches,
      page: () => const MatchesView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chat,
      page: () => const ChatView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsView(),
      transition: Transition.rightToLeft,
    ),
  ];
} 