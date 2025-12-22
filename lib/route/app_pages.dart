import 'package:get/get.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_binding.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_page.dart';
import 'package:smart_life_assistant/pages/settings/theme_settings_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.assistant,
      page: () => AssistantPage(),
      binding: AssistantBinding(),
    ),
    GetPage(name: AppRoutes.themeSettings, page: () => ThemeSettingsPage()),
  ];
}
