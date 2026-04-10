import 'package:bloc/bloc.dart';
import 'package:chat_app_bloc/theme/bloc/theme_event.dart';
import 'package:chat_app_bloc/theme/bloc/theme_state.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeModeKey = 'theme_mode';
  static const String _primaryColorKey = 'primary_color';

  ThemeBloc() : super(ThemeState.initial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangePrimaryColorEvent>(_onChangePrimaryColor);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
    final themeMode = ThemeMode.values[themeModeIndex];

    // Load primary color
    final colorName = prefs.getString(_primaryColorKey) ?? 'amber';
    final primaryColor = AppColor.availableColors[colorName] ?? Colors.amber;

    emit(ThemeState(
      themeMode: themeMode,
      primaryColor: primaryColor,
      colorName: colorName,
    ));
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, newThemeMode.index);

    emit(state.copyWith(themeMode: newThemeMode));
  }

  Future<void> _onChangePrimaryColor(
    ChangePrimaryColorEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_primaryColorKey, event.colorName);

    emit(state.copyWith(
      primaryColor: event.color,
      colorName: event.colorName,
    ));
  }
}
