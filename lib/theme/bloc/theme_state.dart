import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final MaterialColor primaryColor;
  final String colorName;

  const ThemeState({
    required this.themeMode,
    required this.primaryColor,
    required this.colorName,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeMode.system,
      primaryColor: Colors.amber,
      colorName: 'amber',
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    MaterialColor? primaryColor,
    String? colorName,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      colorName: colorName ?? this.colorName,
    );
  }

  @override
  List<Object?> get props => [themeMode, primaryColor, colorName];
}
