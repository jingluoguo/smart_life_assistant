import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/utils/common_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_life_assistant/data/service/function_call_service.dart';

class AssistantController extends GetxController with WidgetsBindingObserver {
  final TextEditingController inputController = TextEditingController();
  final FunctionCallService functionCallService =
      FunctionCallService.getInstance();
  RxBool isLoading = false.obs;
  RxString result = ''.obs;

  Future<void> handleLaunchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      result.value = '无法打开链接: $url';
    }
  }

  void handleFunctionCall() async {
    if (inputController.text.isEmpty) {
      if (kDebugMode) {
        inputController.text =
            "我获取这个视频的下载链接 8.92 EUY:/ 07/06 G@v.fB 这个视频不错👍复制打开抖音极速版👀今天吹了一个超级完美的波波头# 小学生# 处女座  https://v.douyin.com/FmNeSgqBlac/";
      } else {
        return;
      }
    }

    isLoading.value = true;
    result.value = FlutterI18n.translate(Get.context!, 'app.loading');

    try {
      final functionResult = await functionCallService.handleFunctionCall(
        text: inputController.text,
      );
      result.value = functionResult;
    } catch (e) {
      result.value = i18n('app.failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkClipboard() async {
    try {
      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null && data.text != null) {
        final String clipboardText = data.text!;
        // 检查是否包含抖音链接
        if (clipboardText.contains('v.douyin.com')) {
          inputController.text = clipboardText;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('读取剪贴板失败: $e');
      }
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    // 初始化时检查一次剪贴板
    _checkClipboard();
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 应用恢复到前台时检查剪贴板
      _checkClipboard();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    inputController.dispose();
    super.onClose();
  }
}
