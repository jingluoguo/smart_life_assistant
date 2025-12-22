import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';

String i18n(
  String key, {
  BuildContext? context,
  String? fallbackKey,
  Map<String, String>? translationParams,
}) {
  if (Get.context == null) return fallbackKey ?? key;
  return FlutterI18n.translate(
    Get.context!,
    key,
    fallbackKey: fallbackKey ?? key,
    translationParams: translationParams,
  );
}
