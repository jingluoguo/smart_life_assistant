import 'package:flutter/foundation.dart';

/// 日志工具类
class Logger {
  static const bool _enableLog = kDebugMode;

  /// 调试日志
  static void d(String tag, String message) {
    if (_enableLog) {
      debugPrint('[$tag] DEBUG: $message');
    }
  }

  /// 信息日志
  static void i(String tag, String message) {
    if (_enableLog) {
      debugPrint('[$tag] INFO: $message');
    }
  }

  /// 警告日志
  static void w(String tag, String message) {
    if (_enableLog) {
      debugPrint('[$tag] WARNING: $message');
    }
  }

  /// 错误日志
  static void e(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (_enableLog) {
      debugPrint('[$tag] ERROR: $message');
      if (error != null) {
        debugPrint('Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}
