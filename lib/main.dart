import 'dart:async' as runtime;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/ext/widget_ext.dart';
import 'package:smart_life_assistant/core/utils/common_util.dart';
import 'package:smart_life_assistant/route/app_pages.dart';
import 'package:smart_life_assistant/core/controller/theme_controller.dart';
import 'package:smart_life_assistant/data/service/setting_service.dart';

void main() {
  runtime.runZoned(_runMain);
}

void _runMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化设置服务
  await Get.putAsync(() => SettingsService().init());

  // 初始化主题控制器
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: i18n('app.title'),
          localizationsDelegates: [
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(
                basePath: 'assets/i18n',
                useCountryCode: false,
                decodeStrategies: [JsonDecodeStrategy()],
              ),
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('zh')],
          localeResolutionCallback: (locale, supportedLocales) {
            // 尝试匹配用户的首选语言
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            // 如果没有匹配的，使用默认语言
            return supportedLocales.first;
          },
          theme: themeController.getThemeData(),
          initialRoute: AppRoutes.assistant,
          defaultTransition: Transition.cupertino,
          getPages: AppPages.pages,
        ).onTap(() {
          FocusManager.instance.primaryFocus?.unfocus();
        });
      },
    );
  }
}
