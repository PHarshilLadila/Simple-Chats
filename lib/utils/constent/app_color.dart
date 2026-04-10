import 'package:flutter/material.dart';

class AppColor {
  static Color whiteColor = const Color(0xFFffffff);
  static Color blackColor = const Color(0xFF000000);

  // static const Color mainColor = Color(0xFFF9BE08);

  // Background
  static const Color backgroundColor = Color(0xFFFAF9F6); // Ivory White

  // Dark theme backgrounds
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);

  // Secondary (Soft elements, subtle highlights)
  static const Color secondaryColor = Color(0xFFE5D3A3); // Soft Champagne
  static const Color darkSecondary = Color(0xFF3D3D3D);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Main Text
  static const Color textSecondary = Color(0xFF6B6B6B); // Subtext
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Borders / Dividers
  static const Color borderColor = Color(0xFFE8E6E1);
  static const Color darkBorderColor = Color(0xFF3D3D3D);

  // Card / Surface
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color darkCardSurface = Color(0xFF2D2D2D);

  // Available primary colors
  static final Map<String, MaterialColor> availableColors = {
    'red': Colors.red, // Matched with white
    'pink': Colors.pink, // Matched with white
    'purple': Colors.purple, // Matched with white
    'deepPurple': Colors.deepPurple, // Matched with white
    'indigo': Colors.indigo, // Matched with white
    'blue': Colors.blue, // Matched with white
    'lightBlue': Colors.lightBlue, // Matched with white
    'cyan': Colors.cyan, // Matched with white
    'teal': Colors.teal, // Matched with white
    'green': Colors.green, // Matched with white
    'lightGreen': Colors.lightGreen, // Matched with white
    'lime': Colors.lime, // Matched with black
    'yellow': Colors.yellow, // Matched with black
    'amber': Colors.amber, // Matched with black
    'orange': Colors.orange, // Matched with black
    'deepOrange': Colors.deepOrange, // Matched with black
    'brown': Colors.brown, // Matched with white
    'grey': Colors.grey, // Matched with white
    'blueGrey': Colors.blueGrey, // Matched with white
  };

  // Get color by name
  static MaterialColor getColorByName(String name) {
    return availableColors[name] ?? Colors.amber;
  }

  // Get color name from value
  static String getColorName(MaterialColor color) {
    return availableColors.entries
        .firstWhere(
          (entry) => entry.value == color,
          orElse: () => const MapEntry('amber', Colors.amber),
        )
        .key;
  }
}

Color isColorValidation(BuildContext context) {
  final bool colorValidation = Theme.of(context).primaryColor == Colors.amber ||
      Theme.of(context).primaryColor == Colors.lime ||
      Theme.of(context).primaryColor == Colors.yellow ||
      Theme.of(context).primaryColor == Colors.orange ||
      Theme.of(context).primaryColor == Colors.deepOrange;
  final checkValidation =
      colorValidation == false ? Colors.white : Colors.black;
  return checkValidation;
}
