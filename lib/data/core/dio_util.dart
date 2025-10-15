import 'package:dio/dio.dart';
import 'package:smart_life_assistant/config/app_config.dart';
import 'package:smart_life_assistant/utils/logger.dart';

/// 网络请求工具类
class DioUtil {
  static const String _tag = 'DioUtil';
  static final DioUtil _instance = DioUtil._internal();

  factory DioUtil.getInstance() => _instance;

  late final Dio _dio;

  DioUtil._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // 添加请求拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.d(_tag, 'Request: ${options.method} ${options.uri}');
          Logger.d(_tag, 'Headers: ${options.headers}');
          if (options.data != null) {
            Logger.d(_tag, 'Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.d(
            _tag,
            'Response: ${response.statusCode} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          Logger.e(
            _tag,
            'Error: ${error.type} ${error.requestOptions.uri}',
            error.error,
            error.stackTrace,
          );
          return handler.next(error);
        },
      ),
    );
  }

  /// GET请求
  Future<Response> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      Logger.e(_tag, 'GET request failed: $url', e);
      rethrow;
    }
  }

  /// POST请求
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      Logger.e(_tag, 'POST request failed: $url', e);
      rethrow;
    }
  }

  /// 创建取消令牌
  CancelToken createCancelToken() => CancelToken();
}
