import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/value/theme_model.dart';
import 'package:smart_life_assistant/data/service/setting_service.dart';

class ThemeController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();
  final Rx<ThemeModel> _currentTheme = ThemeModel.defaultTheme.obs;

  ThemeModel get currentTheme => _currentTheme.value;

  @override
  void onInit() {
    super.onInit();
    // 从设置服务加载当前主题
    _currentTheme.value = _settingsService.getCurrentTheme();
  }

  // 切换到指定主题
  Future<void> switchTheme(String themeName) async {
    final theme = ThemeModel.fromName(themeName);
    _currentTheme.value = theme;
    // 持久化主题设置
    await _settingsService.setAppTheme(themeName);
    update();
  }

  // 获取当前主题的ThemeData
  ThemeData getThemeData() {
    return ThemeData(
      brightness:
          _currentTheme.value.name == 'dark'
              ? Brightness.dark
              : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _currentTheme.value.primary,
        brightness:
            _currentTheme.value.name == 'dark'
                ? Brightness.dark
                : Brightness.light,
      ),
      primaryColor: _currentTheme.value.primary,
      scaffoldBackgroundColor: _currentTheme.value.background,
    );
  }
}
