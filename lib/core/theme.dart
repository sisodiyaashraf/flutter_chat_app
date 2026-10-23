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

// ----------------------------------------------------------------------
// Gradient and texture definitions used throughout the chat UI
// ----------------------------------------------------------------------
class AppTheme {
  // Background gradient for the chat screen
  static const LinearGradient chatBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3A1C71), // deep purple
      Color(0xFFd76d77), // soft pink‑red
      Color(0xFFffaf7b), // warm orange
    ],
  );

  // Text styles
  static const TextStyle typingStatus = TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.italic,
  );

  // Bubble decorations – customize colors as you wish
  static const BoxDecoration incomingBubbleDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF5A3F78), Color(0xFF2C2A4A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );

  static const BoxDecoration outgoingBubbleDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF4DA0B0), Color(0xFFD39D38)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );
}
