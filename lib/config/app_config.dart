/// 应用配置类
class AppConfig {
  AppConfig._();

  // ==================== 和风天气配置 ====================
  static const String qWeatherApiHost = 'your-api-host.qweatherapi.com';
  static const String qWeatherProjectId = 'YOUR_PROJECT_ID';
  static const String qWeatherCredentialId = 'YOUR_CREDENTIAL_ID';
  static const String qWeatherPrivateKey = '''
-----BEGIN PRIVATE KEY-----
YOUR_PRIVATE_KEY_HERE
-----END PRIVATE KEY-----
''';

  // ==================== 通义千问配置 ====================
  static const String dashScopeApiUrl =
      'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions';
  static const String dashScopeApiKey = 'sk-YOUR_API_KEY_HERE';
  static const String dashScopeModel = 'qwen3-max';

  // ==================== 网络配置 ====================
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ==================== 抖音配置 ====================
  static const mobileHeaders = {
    'User-Agent':
        'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1',
  };
  static const String tiktokShareDomain =
      'https://www.iesdouyin.com/share/video/';
}
