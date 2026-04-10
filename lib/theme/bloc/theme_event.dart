import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadThemeEvent extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class ChangePrimaryColorEvent extends ThemeEvent {
  final MaterialColor color;
  final String colorName;

  const ChangePrimaryColorEvent({
    required this.color,
    required this.colorName,
  });

  @override
  List<Object?> get props => [color, colorName];
}
