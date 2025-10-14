import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:smart_life_assistant/data/core/dio_util.dart';

class WeatherFunction {
  static const String _tag = "WeatherFunction";

  static final WeatherFunction _instance = WeatherFunction._();

  WeatherFunction._();

  factory WeatherFunction.getInstance() {
    return _instance;
  }

  final List<Map<String, dynamic>> weatherTools = [
    {
      "type": "function",
      "function": {
        "name": "getRealTimeWeatherInfo",
        "description": "根据城市或经纬度获取实时天气信息",
        "parameters": {
          "type": "object",
          "properties": {
            "lng": {"type": "string", "description": "经度"},
            "lat": {"type": "string", "description": "纬度"},
          },
        },
        "required": ["lng", "lat"],
      },
    },
    {
      "type": "function",
      "function": {
        "name": "getNextHoursWeatherInfo",
        "description": "根据城市或经纬度逐小时获取天气信息",
        "parameters": {
          "type": "object",
          "properties": {
            "lng": {"type": "string", "description": "经度"},
            "lat": {"type": "string", "description": "纬度"},
            "hours": {
              "type": "string",
              "description": "获取的预报小时数",
              "enum": ["24h", "72h", "168h"],
            },
          },
        },
        "required": ["lng", "lat", "hours"],
      },
    },
    {
      "type": "function",
      "function": {
        "name": "getEveryDayWeatherInfo",
        "description": "根据城市或经纬度按天获取天气信息",
        "parameters": {
          "type": "object",
          "properties": {
            "lng": {"type": "string", "description": "经度"},
            "lat": {"type": "string", "description": "纬度"},
            "days": {
              "type": "string",
              "description": "预报天数",
              "enum": ["3d", "7d", "10d", "15d", "30d"],
            },
          },
        },
        "required": ["lng", "lat", "hours"],
      },
    },
  ];

  final String _qWeatherApiHost = 'mu52q4jwqd.re.qweatherapi.com';
  final String _qWeatherProjectId = '4DKTM9MVMQ';
  final String _qWeatherCredentialId = 'T6WKR4U3MQ';
  final String _qWeatherPrivateKey = '''
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEINiaaMH4nmvI2Xe7tNUz8814vofZ2c/nq8oRstRFmF8k
-----END PRIVATE KEY-----
    ''';

  String get getJWTToken {
    var header = base64UrlEncode(
      utf8.encode(
        "{\"alg\":\"EdDSA\",\"kid\":\"$_qWeatherCredentialId\",\"typ\":\"JWT\"}",
      ),
    ).replaceAll('=', '');
    var payload = base64UrlEncode(
      utf8.encode(
        "{\"iat\":${DateTime.now().millisecondsSinceEpoch ~/ 1000},\"exp\":${DateTime.now().millisecondsSinceEpoch ~/ 1000 + 60 * 60 * 24},\"sub\":\"$_qWeatherProjectId\"}",
      ),
    ).replaceAll('=', '');

    var key1 = '$header.$payload';
    var signature = base64UrlEncode(
      JWTAlgorithm.EdDSA.sign(
        EdDSAPrivateKey.fromPEM(_qWeatherPrivateKey),
        Uint8List.fromList(utf8.encode(key1)),
      ),
    ).replaceAll('=', '');
    var token = '$header.$payload.$signature';
    return token;
  }

  // 根据城市或经纬度获取实时天气信息
  Future<String> getRealTimeWeatherInfo(String lng, String lat) async {
    try {
      Response response = await DioUtil.getInstance().get(
        'https://$_qWeatherApiHost/v7/weather/now?location=$lng,$lat',
        headers: {'Authorization': 'Bearer $getJWTToken'},
      );
      // 获取天气信息
      return response.data.toString();
    } catch (_) {
      return '操作失败';
    }
  }

  // 根据城市或经纬度按天获取天气信息
  Future<String> getNextHoursWeatherInfo(
    String lng,
    String lat,
    String hours,
  ) async {
    try {
      Response response = await DioUtil.getInstance().get(
        'https://$_qWeatherApiHost/v7/weather/$hours?location=$lng,$lat',
        headers: {'Authorization': 'Bearer $getJWTToken'},
      );
      // 获取天气信息
      return response.data.toString();
    } catch (_) {
      return '操作失败';
    }
  }

  // 根据城市或经纬度逐小时获取天气信息
  Future<String> getEveryDayWeatherInfo(
    String lng,
    String lat,
    String days,
  ) async {
    try {
      Response response = await DioUtil.getInstance().get(
        'https://$_qWeatherApiHost/v7/weather/$days?location=$lng,$lat',
        headers: {'Authorization': 'Bearer $getJWTToken'},
      );
      // 获取天气信息
      return response.data.toString();
    } catch (_) {
      return '操作失败';
    }
  }
}
