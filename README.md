# Smart Life Assistant 智能生活助手

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.7.2+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

一个基于 Flutter 开发的智能生活助手应用，集成阿里云通义千问大模型 Function Calling 能力，为用户提供天气查询、抖音视频解析等智能服务。

[特性](#-核心特性) • [架构](#️-技术架构) • [快速开始](#-快速开始) • [使用指南](#-使用指南) • [开发文档](#-开发文档)

</div>

---

## 📱 项目简介

Smart Life Assistant 是一个基于 AI 驱动的智能助手应用，通过集成大语言模型和实用功能模块，实现自然语言交互的生活服务。应用采用 **Function Calling** 技术，能够智能识别用户意图并自动调用相应的功能服务。

### 🎯 设计理念

- **AI 驱动**：基于通义千问大模型的智能意图识别
- **模块化设计**：功能模块松耦合，易于扩展
- **跨平台支持**：一套代码，多端运行
- **最佳实践**：遵循 Flutter 和 Dart 开发规范

## ✨ 核心特性

### 🌤️ 天气查询功能

基于和风天气 API，提供全方位的天气信息查询服务：

- **实时天气**：根据经纬度获取当前实时天气信息
- **逐小时预报**：支持 24h / 72h / 168h 逐小时天气预报
- **逐天预报**：支持 3d / 7d / 10d / 15d / 30d 天气预报
- **JWT 认证**：采用 EdDSA 算法的安全认证机制
- **智能解析**：自然语言输入，自动识别地理位置需求

### 📹 抖音视频解析

强大的抖音视频解析能力：

- **分享链接解析**：智能识别抖音分享文本中的链接
- **无水印下载**：获取高清无水印视频下载地址
- **视频信息提取**：自动提取视频标题、ID、描述等元数据
- **自动处理**：处理文件名非法字符，确保可用性

### 🤖 AI Function Calling

核心 AI 交互能力：

- **大模型集成**：通义千问 qwen3-max 模型
- **意图识别**：自动理解用户自然语言输入
- **函数调用**：智能选择并执行相应功能
- **上下文管理**：支持多轮对话和结果反馈

## 🏗️ 技术架构

### 核心技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Flutter | 3.7.2+ | 跨平台 UI 框架 |
| Dart | 3.7.2+ | 编程语言 |
| GetX | 4.6.6 | 状态管理和路由 |
| Dio | 5.2.1+ | 网络请求库 |
| HTTP | 1.5.0 | HTTP 客户端 |
| dart_jsonwebtoken | 2.17.0 | JWT 认证 |
| cryptography | 2.7.0 | 加密算法支持 |

### 项目结构

```
smart_life_assistant/
├── lib/
│   ├── main.dart                          # 应用入口
│   ├── config/
│   │   └── app_config.dart               # 全局配置（API 密钥、URL 等）
│   ├── data/
│   │   ├── core/
│   │   │   └── dio_util.dart             # Dio 网络请求工具类
│   │   ├── function_calling/
│   │   │   ├── weather_function.dart     # 天气功能模块
│   │   │   └── tiktok_function.dart      # 抖音解析功能模块
│   │   └── service/
│   │       └── function_call_service.dart # Function Calling 服务
│   └── utils/
│       └── logger.dart                    # 日志工具类
├── android/                                # Android 平台代码
├── ios/                                    # iOS 平台代码
├── web/                                    # Web 平台代码
├── linux/                                  # Linux 平台代码
├── macos/                                  # macOS 平台代码
├── windows/                                # Windows 平台代码
├── test/                                   # 测试代码
├── pubspec.yaml                            # 依赖配置
└── README.md                               # 项目文档
```

### 架构设计

```mermaid
graph TB
    A[用户输入] --> B[FunctionCallService]
    B --> C[通义千问大模型]
    C --> D{识别意图}
    D -->|天气查询| E[WeatherFunction]
    D -->|视频解析| F[TikTokFunction]
    E --> G[和风天气 API]
    F --> H[抖音解析服务]
    G --> I[返回结果]
    H --> I
    I --> C
    C --> J[AI 处理结果]
    J --> K[展示给用户]
```

### 核心模块说明

#### 1. AppConfig - 配置管理

集中管理应用配置信息，采用**私有构造函数**防止实例化：

- 和风天气 API 配置（Host、Project ID、Credential ID、私钥）
- 通义千问 API 配置（URL、API Key、模型名称）
- 网络超时配置（连接、接收、发送超时时间）
- 抖音请求配置（User-Agent、分享域名）

#### 2. DioUtil - 网络请求工具

基于 Dio 的网络请求封装，提供统一的网络请求能力：

- **单例模式**：全局唯一实例
- **超时配置**：自动应用配置的超时时间
- **请求拦截器**：自动记录请求日志
- **响应拦截器**：自动记录响应日志
- **错误拦截器**：统一错误处理和日志记录
- **取消令牌**：支持请求取消

#### 3. FunctionCallService - Function Calling 服务

核心服务，负责与通义千问大模型交互：

- **工具注册**：集成所有功能模块的工具定义
- **意图识别**：调用大模型理解用户输入
- **函数路由**：根据模型返回的函数名调用对应功能
- **结果处理**：将功能执行结果返回给模型进行二次处理
- **上下文管理**：维护对话历史

#### 4. WeatherFunction - 天气查询模块

提供天气查询相关功能：

- **JWT Token 生成**：使用 EdDSA 算法生成和风天气 API 认证令牌
- **实时天气**：`getRealTimeWeatherInfo(lng, lat)`
- **逐小时预报**：`getNextHoursWeatherInfo(lng, lat, hours)`
- **逐天预报**：`getEveryDayWeatherInfo(lng, lat, days)`
- **工具定义**：提供给大模型的函数描述

#### 5. TikTokFunction - 抖音视频解析模块

提供抖音视频解析功能：

- **URL 提取**：从分享文本中提取链接
- **重定向处理**：获取真实的视频 ID
- **页面解析**：解析视频页面获取元数据
- **无水印链接**：替换水印 URL 为无水印链接
- **信息提取**：返回视频 URL、标题、ID

## 🚀 快速开始

### 环境要求

确保你的开发环境满足以下要求：

| 工具 | 版本要求 | 说明 |
|------|---------|------|
| Flutter SDK | ≥ 3.7.2 | [安装指南](https://flutter.dev/docs/get-started/install) |
| Dart SDK | ≥ 3.7.2 | 随 Flutter 自动安装 |
| IDE | 任意 | Android Studio / VS Code / Qoder IDE |
| Xcode | 最新版 | iOS 开发必需（仅 macOS） |
| Android Studio | 最新版 | Android 开发推荐 |

### 安装步骤

#### 1. 克隆项目

```bash
git clone https://github.com/yourusername/smart_life_assistant.git
cd smart_life_assistant
```

#### 2. 安装依赖

```bash
flutter pub get
```

#### 3. 配置 API 密钥

编辑 `lib/config/app_config.dart` 文件，配置你的 API 密钥：

```dart
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
}
```

**获取 API 密钥：**

- **通义千问 API Key**：访问 [阿里云 DashScope](https://dashscope.aliyun.com/) 获取
- **和风天气 API**：访问 [和风天气开发平台](https://dev.qweather.com/) 注册并获取

#### 4. 运行项目

```bash
# 查看可用设备
flutter devices

# 运行到 Android 设备/模拟器
flutter run

# 运行到 iOS 设备/模拟器（需要 macOS）
flutter run -d ios

# 运行到 Web 浏览器
flutter run -d chrome

# 运行到桌面（macOS/Windows/Linux）
flutter run -d macos
flutter run -d windows
flutter run -d linux
```

#### 5. 构建发布版本

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📖 使用指南

### 天气查询示例

用户可以通过自然语言查询天气，AI 会自动识别意图并调用相应功能：

```text
用户："北京现在的天气怎么样？"
助手：[自动识别位置 → 调用实时天气查询 → 返回当前天气信息]

用户："上海未来 24 小时的天气预报"
助手：[识别上海经纬度 → 调用逐小时天气预报(24h) → 返回详细预报]

用户："深圳未来 7 天的天气情况"
助手：[识别深圳经纬度 → 调用逐天天气预报(7d) → 返回未来 7 天预报]
```

**支持的查询类型：**
- 实时天气查询
- 逐小时预报：24h / 72h / 168h
- 逐天预报：3d / 7d / 10d / 15d / 30d

### 抖音视频解析示例

直接粘贴抖音分享文本即可：

```text
用户："帮我获取这个视频的下载链接 8.92 EUY:/ 07/06 G@v.fB 这个视频不错👍复制打开抖音极速版👀今天吹了一个超级完美的波波头# 小学生# 处女座  https://v.douyin.com/FmNeSgqBlac/"

助手：[提取链接 → 解析视频信息 → 返回无水印下载地址]

返回结果：
{
  "url": "无水印视频下载地址",
  "title": "今天吹了一个超级完美的波波头",
  "video_id": "视频ID"
}
```

### 核心 API 使用

#### Function Calling 服务

```dart
import 'package:smart_life_assistant/data/service/function_call_service.dart';

// 调用 Function Calling 服务
FunctionCallService.getInstance().handleFunctionCall(
  text: '用户输入的自然语言',
);
```

#### 天气查询

```dart
import 'package:smart_life_assistant/data/function_calling/weather_function.dart';

// 获取实时天气
String result = await WeatherFunction.getInstance()
  .getRealTimeWeatherInfo('116.41', '39.90'); // 北京经纬度

// 获取逐小时天气预报
String hourly = await WeatherFunction.getInstance()
  .getNextHoursWeatherInfo('116.41', '39.90', '24h');

// 获取逐天天气预报
String daily = await WeatherFunction.getInstance()
  .getEveryDayWeatherInfo('116.41', '39.90', '7d');
```

#### 抖音视频解析

```dart
import 'package:smart_life_assistant/data/function_calling/tiktok_function.dart';

// 解析抖音分享链接
Map<String, String> result = await TikTokFunction.getInstance()
  .parseTiktokShareUrl('分享文本内容');

// 结果包含：url（视频地址）、title（标题）、video_id（视频ID）
```

## 🔧 开发文档

### 添加新的功能模块

按照以下步骤添加新的功能模块：

#### 1. 创建功能类

在 `lib/data/function_calling/` 目录下创建新的功能类：

```dart
class YourFunction {
  static final YourFunction _instance = YourFunction._();
  
  YourFunction._();
  
  factory YourFunction.getInstance() {
    return _instance;
  }
  
  // 定义工具描述
  final List<Map<String, dynamic>> yourTools = [
    {
      "type": "function",
      "function": {
        "name": "yourFunctionName",
        "description": "功能描述，用于帮助 AI 理解何时调用此功能",
        "parameters": {
          "type": "object",
          "properties": {
            "param1": {
              "type": "string",
              "description": "参数1的描述"
            },
            "param2": {
              "type": "integer",
              "description": "参数2的描述",
              "enum": ["选项1", "选项2"] // 可选的枚举值
            },
          },
        },
        "required": ["param1"], // 必需参数
      },
    },
  ];
  
  // 实现具体功能
  Future<String> yourFunctionName(String param1, String param2) async {
    // 功能实现
    return '执行结果';
  }
}
```

#### 2. 注册工具

在 `FunctionCallService` 中注册工具：

```dart
final List<Map<String, dynamic>> tools = [
  ...WeatherFunction.getInstance().weatherTools,
  ...TikTokFunction.getInstance().tiktokTools,
  ...YourFunction.getInstance().yourTools, // 添加新工具
];
```

#### 3. 添加函数调用逻辑

在 `parseFunctionCall` 方法中添加处理逻辑：

```dart
void parseFunctionCall(Map toolCall, List messages) async {
  var callName = toolCall['name'];
  Response? response;
  
  // ... 现有代码 ...
  
  else if (callName == 'yourFunctionName') {
    var arguments = toolCall['arguments'];
    var args = jsonDecode(arguments);
    var content = await YourFunction.getInstance().yourFunctionName(
      args['param1'],
      args['param2'],
    );
    messages.add({'role': 'tool', 'content': content});
    response = await _commonDashScopeApiCall(messages);
  }
  
  // ...
}
```

### 最佳实践

#### 1. 配置管理

所有配置信息应集中在 `AppConfig` 中管理：

```dart
class AppConfig {
  AppConfig._(); // 私有构造函数，防止实例化
  
  static const String yourApiKey = 'your-api-key';
  static const Duration yourTimeout = Duration(seconds: 30);
}
```

#### 2. 网络请求

使用 `DioUtil` 进行网络请求：

```dart
import 'package:smart_life_assistant/data/core/dio_util.dart';

// GET 请求
Response response = await DioUtil.getInstance().get(
  'https://api.example.com/data',
  headers: {'Authorization': 'Bearer token'},
  queryParameters: {'key': 'value'},
);

// POST 请求
Response response = await DioUtil.getInstance().post(
  'https://api.example.com/data',
  data: {'key': 'value'},
  headers: {'Content-Type': 'application/json'},
);
```

#### 3. 日志记录

使用 `Logger` 工具类记录日志：

```dart
import 'package:smart_life_assistant/utils/logger.dart';

Logger.d('YourClass', 'Debug message');
Logger.i('YourClass', 'Info message');
Logger.w('YourClass', 'Warning message');
Logger.e('YourClass', 'Error message', error, stackTrace);
```

#### 4. 单例模式

功能类应使用单例模式：

```dart
class YourService {
  static final YourService _instance = YourService._();
  
  YourService._();
  
  factory YourService.getInstance() {
    return _instance;
  }
}
```

### 代码规范

项目遵循以下代码规范：

- **命名规范**：
  - 类名：PascalCase（如 `WeatherFunction`）
  - 方法名：camelCase（如 `getRealTimeWeatherInfo`）
  - 常量：lowerCamelCase（如 `dashScopeApiKey`）
  - 私有成员：以下划线开头（如 `_instance`）

- **文件组织**：
  - 一个文件一个类
  - 相关功能组织在同一目录
  - 使用 barrel 文件导出公共 API

- **注释规范**：
  - 类和公共方法必须有文档注释
  - 使用 `///` 进行文档注释
  - 复杂逻辑添加行内注释

## 📦 依赖说明

### 核心依赖

| 依赖包 | 版本 | 用途 | 说明 |
|--------|------|------|------|
| flutter | SDK | Flutter 框架 | 跨平台 UI 框架 |
| cupertino_icons | ^1.0.8 | iOS 图标 | iOS 风格图标库 |
| get | ^4.6.6 | 状态管理 | 轻量级状态管理和路由 |
| dio | ^5.2.1+1 | 网络请求 | 强大的 HTTP 客户端 |
| http | ^1.5.0 | HTTP 请求 | Dart 官方 HTTP 库 |
| dart_jsonwebtoken | ^2.17.0 | JWT 认证 | JWT Token 生成和验证 |
| cryptography | ^2.7.0 | 加密算法 | 提供 EdDSA 等加密算法 |

### 开发依赖

| 依赖包 | 版本 | 用途 |
|--------|------|------|
| flutter_test | SDK | 单元测试 |
| flutter_lints | ^5.0.0 | 代码检查 |

## 🌐 平台支持

| 平台 | 状态 | 说明 |
|------|------|------|
| ✅ Android | 已支持 | API 21+ (Android 5.0+) |
| ✅ iOS | 已支持 | iOS 12.0+ |
| ✅ Web | 已支持 | 现代浏览器 |
| ✅ macOS | 已支持 | macOS 10.14+ |
| ✅ Windows | 已支持 | Windows 10+ |
| ✅ Linux | 已支持 | Ubuntu 20.04+ |

## 🧪 测试

```bash
# 运行所有测试
flutter test

# 运行指定测试文件
flutter test test/widget_test.dart

# 生成测试覆盖率报告
flutter test --coverage
```

## 🐛 常见问题

### 1. JWT Token 生成失败

**问题**：和风天气 API 返回 401 未授权

**解决方案**：检查 `AppConfig` 中的私钥格式是否正确，确保包含完整的 PEM 头尾。

### 2. 网络请求超时

**问题**：请求超时错误

**解决方案**：检查网络连接，或在 `AppConfig` 中调整超时时间。

### 3. 抖音视频解析失败

**问题**：无法解析分享链接

**解决方案**：抖音页面结构可能变化，需要更新解析逻辑。

## 📝 更新日志

### v1.0.0 (2025-10-15)

- ✨ 初始版本发布
- ✅ 集成通义千问 Function Calling
- ✅ 实现天气查询功能
- ✅ 实现抖音视频解析功能
- ✅ 完善网络请求和日志系统

## 🗺️ 路线图

- [ ] 添加更多天气数据（空气质量、生活指数等）
- [ ] 支持更多视频平台解析（B站、YouTube 等）
- [ ] 添加用户界面和交互优化
- [ ] 支持离线缓存
- [ ] 添加多语言支持
- [ ] 集成语音交互功能

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 🤝 贡献指南

欢迎贡献！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 贡献者

感谢所有为本项目做出贡献的开发者！

## 📮 联系方式

- 项目地址：[GitHub](https://github.com/yourusername/smart_life_assistant)
- 问题反馈：[Issues](https://github.com/yourusername/smart_life_assistant/issues)
- 讨论交流：[Discussions](https://github.com/yourusername/smart_life_assistant/discussions)

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 优秀的跨平台框架
- [阿里云 DashScope](https://dashscope.aliyun.com/) - 提供通义千问 API
- [和风天气](https://dev.qweather.com/) - 提供天气数据 API
- 所有开源贡献者

## ⚠️ 免责声明

本项目仅供学习和研究使用，请勿用于商业用途。使用本项目时，请遵守相关 API 服务提供商的使用条款和条件。

---

<div align="center">

**如果这个项目对你有帮助，请给一个 ⭐️ Star 支持一下！**

Made with ❤️ by Flutter developers

</div>
