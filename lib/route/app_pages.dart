import 'package:get/get.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_binding.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.assistant,
      page: () => AssistantPage(),
      binding: AssistantBinding(),
    ),
  ];
}
