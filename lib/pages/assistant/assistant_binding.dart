import 'package:get/get.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_controller.dart';

class AssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssistantController>(() => AssistantController());
  }
}
