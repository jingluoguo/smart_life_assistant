import 'package:dio/dio.dart';

class DioUtil {
  static final DioUtil _instance = DioUtil._();

  DioUtil._();

  factory DioUtil.getInstance() {
    return _instance;
  }

  final Dio _dio = Dio();

  Future<Response> get(String url, {Map<String, dynamic>? headers}) {
    return _dio.get(url, options: Options(headers: headers));
  }
}