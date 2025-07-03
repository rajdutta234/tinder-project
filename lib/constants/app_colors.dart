import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryLight = Color(0xFFFF8E8E);
  static const Color primaryDark = Color.fromARGB(255, 214, 205, 205);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryLight = Color.fromARGB(255, 134, 190, 186);
  static const Color secondaryDark = Color(0xFF3DB8B0);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFFADB5BD);
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Swipe Colors
  static const Color likeColor = Color(0xFF4ECDC4);
  static const Color nopeColor = Color(0xFFFF6B6B);
  static const Color superLikeColor = Color(0xFF17A2B8);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF181A20);
  static const Color surfaceDark = Color(0xFF23262F);
  static const Color cardBackgroundDark = Color(0xFF23262F);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFB0B3B8);
  static const Color textTertiaryDark = Color(0xFF6C757D);
} 