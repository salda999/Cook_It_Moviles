import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'screens/welcome/welcome_screen.dart';

void main() {
  runApp(const CookItApp());
}

class CookItApp extends StatelessWidget {
  const CookItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


