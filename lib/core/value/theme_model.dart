import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color background;
  final Color backgroundSecondary;

  const ThemeModel({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.background,
    required this.backgroundSecondary,
  });

  // 默认主题
  static const defaultTheme = ThemeModel(
    name: 'default',
    primary: Color(0xFF673AB7),
    secondary: Color(0xFF03A9F4),
    accent: Color(0xFFE91E63),
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF757575),
    background: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFF5F5F5),
  );

  // 暗色主题
  static const darkTheme = ThemeModel(
    name: 'dark',
    primary: Color(0xFF9C27B0),
    secondary: Color(0xFF2196F3),
    accent: Color(0xFFFF4081),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB0BEC5),
    background: Color(0xFF121212),
    backgroundSecondary: Color(0xFF1E1E1E),
  );

  // 从主题名称获取主题模型
  static ThemeModel fromName(String name) {
    switch (name) {
      case 'dark':
        return darkTheme;
      default:
        return defaultTheme;
    }
  }

  // 获取所有可用主题
  static List<ThemeModel> get allThemes => [defaultTheme, darkTheme];
}
