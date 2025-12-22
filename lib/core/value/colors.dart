import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/controller/theme_controller.dart';
import 'package:smart_life_assistant/core/value/theme_model.dart';

class AppColors {
  // 获取主题控制器
  static ThemeController get _themeController => Get.find<ThemeController>();

  // 获取当前主题
  static ThemeModel get _currentTheme => _themeController.currentTheme;

  // 主色调
  static Color get primary => _currentTheme.primary;
  static Color get secondary => _currentTheme.secondary;
  static Color get accent => _currentTheme.accent;

  // 文本颜色
  static Color get textPrimary => _currentTheme.textPrimary;
  static Color get textSecondary => _currentTheme.textSecondary;
  static Color get textLight =>
      _currentTheme.textSecondary.withValues(alpha: 0.8);

  // 背景颜色
  static Color get background => _currentTheme.background;
  static Color get backgroundSecondary => _currentTheme.backgroundSecondary;

  // 功能颜色
  static const success = Color(0xFF4CAF50); // 成功-绿色
  static const error = Color(0xFFF44336); // 错误-红色
  static const warning = Color(0xFFFFC107); // 警告-黄色
  static const info = Color(0xFF2196F3); // 信息-蓝色

  // 特殊颜色（这些颜色不随主题变化）
  static const blue = Color(0xFF2196F3);
  static const pink = Color(0xFFE91E63);
  static const grey = Color(0xFF9E9E9E);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
}
