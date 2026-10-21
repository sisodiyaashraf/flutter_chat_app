import 'package:flutter/material.dart';

/// Centralized app theme configuration.
/// Uses Material 3 and a seed color to generate a cohesive color scheme.
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF008069), // Teal seed matching existing UI
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  // You can add further theme customizations (e.g., textTheme) here.
);
