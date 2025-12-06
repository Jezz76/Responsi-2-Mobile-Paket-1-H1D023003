import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8000/api'; // ✅ Backend ready!
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String logoutEndpoint = '/logout';
  static const String inventarisEndpoint = '/inventaris';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // App Info
  static const String appName = 'Inventaris Komputer Jeskris';
  static const String appVersion = '1.0.0';

  // Colors - Gray Theme
  static const Color primaryColor = Color(0xFF757575); // Gray
  static const Color primaryDarkColor = Color(0xFF424242); // Dark Gray
  static const Color primaryLightColor = Color(0xFFBDBDBD); // Light Gray
  static const Color accentColor = Color(0xFF616161); // Medium Gray
  static const Color backgroundColor = Color(0xFFF5F5F5); // Very Light Gray
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);

  // Padding & Margins
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
}
