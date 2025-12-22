import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_life_assistant/core/value/constant.dart';
import 'package:smart_life_assistant/core/value/theme_model.dart';

class SettingsService extends GetxService {
  String? languageCode;
  String? themeName;

  Future<bool?> setAppLanguageKey(String? code) async {
    if (code == null) return false;

    SharedPreferences sp = await SharedPreferences.getInstance();
    bool suc = await sp.setString(Constant.appLanguageKey, code);

    if (suc) {
      languageCode = code;
    }
    await Get.updateLocale(Locale(code));
    return suc;
  }

  Future<bool?> setAppTheme(String? theme) async {
    if (theme == null) return false;

    SharedPreferences sp = await SharedPreferences.getInstance();
    bool suc = await sp.setString(Constant.appThemeKey, theme);

    if (suc) {
      themeName = theme;
    }
    return suc;
  }

  Locale getLanguageLocale() {
    if (languageCode == null) {
      if (Get.context != null) {
        languageCode = FlutterI18n.currentLocale(Get.context!)?.languageCode;
      } else {
        languageCode = Platform.localeName.split('_')[0];
      }
    }
    return Locale(languageCode!);
  }

  ThemeModel getCurrentTheme() {
    return ThemeModel.fromName(themeName ?? 'default');
  }

  Future<SettingsService> init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    languageCode = sp.getString(Constant.appLanguageKey);
    themeName = sp.getString(Constant.appThemeKey);

    if (languageCode == null) {
      if (Get.context != null) {
        languageCode = FlutterI18n.currentLocale(Get.context!)?.languageCode;
      } else {
        languageCode = Platform.localeName.split('_')[0];
      }
      sp.setString(Constant.appLanguageKey, languageCode!);
    }

    if (themeName == null) {
      themeName = 'default';
      sp.setString(Constant.appThemeKey, themeName!);
    }

    return this;
  }
}
