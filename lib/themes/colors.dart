import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF007ACC);
  static const Color secondary = Color(0xFF0095FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF0F0F0);
  static const Color darkGrey = Color(0xFF333333);

  // Gradient untuk primary dan secondary
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primary,
      secondary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
