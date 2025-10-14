# Smart Life Assistant 智能生活助手

一个基于 Flutter 开发的智能生活助手应用，集成了阿里云通义千问大模型的 Function Calling 功能，为用户提供智能的生活服务。

## 📱 项目简介

Smart Life Assistant 是一个功能强大的 AI 助手应用，通过集成大语言模型和多个实用功能，帮助用户轻松获取天气信息、解析抖音视频等。应用采用 Function Calling 技术，能够智能识别用户需求并调用相应的功能服务。

## ✨ 主要特性

### 🌤️ 天气查询功能
- **实时天气查询**：根据经纬度获取当前实时天气信息
- **逐小时预报**：支持 24 小时、72 小时、168 小时的逐小时天气预报
- **逐天预报**：支持 3 天、7 天、10 天、15 天、30 天的天气预报
- 集成和风天气 API，数据准确可靠

### 📹 抖音视频解析
- **分享链接解析**：智能解析抖音分享文本，提取视频信息
- **无水印下载**：获取无水印视频下载链接
- **视频信息提取**：自动提取视频标题、ID 等元数据

### 🤖 AI Function Calling
- 集成通义千问大模型（qwen3-max）
- 智能理解用户意图，自动调用相应功能
- 支持自然语言交互

## 🏗️ 技术架构

### 技术栈
- **Flutter**: 跨平台 UI 框架（SDK 3.7.2+）
- **GetX**: 状态管理和路由管理
- **Dio**: 网络请求库
- **HTTP**: HTTP 客户端
- **Dart JsonWebToken**: JWT 认证支持
- **Cryptography**: 加密算法支持

### 项目结构

```
lib/
├── main.dart                          # 应用入口
├── data/
│   ├── core/
│   │   └── dio_util.dart             # Dio 网络请求工具类
│   ├── function_calling/
│   │   ├── weather_function.dart     # 天气功能实现
│   │   └── tiktok_function.dart      # 抖音解析功能实现
│   └── service/
│       └── function_call_service.dart # Function Calling 服务
```

### 核心模块说明

#### 1. FunctionCallService
负责与通义千问大模型进行交互，处理 Function Calling 流程：
- 接收用户输入
- 调用大模型理解用户意图
- 解析模型返回的函数调用请求
- 执行相应的功能函数
- 将结果返回给大模型进行二次处理

#### 2. WeatherFunction
提供天气查询相关功能：
- 使用和风天气 API
- 支持 JWT 认证
- 提供实时、逐小时、逐天三种查询方式

#### 3. TikTokFunction
提供抖音视频解析功能：
- 从分享文本中提取链接
- 解析视频 ID
- 获取无水印视频下载链接
- 提取视频元信息

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.7.2 或更高版本
- Dart SDK 3.7.2 或更高版本
- Android Studio / VS Code / Qoder IDE
- iOS 开发需要 Xcode（macOS）

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/yourusername/smart_life_assistant.git
cd smart_life_assistant
```

2. **安装依赖**
```bash
flutter pub get
```

3. **配置 API 密钥**

在 `lib/data/service/function_call_service.dart` 中配置通义千问 API Key：
```dart
final apiKey = "your-api-key-here";
```

在 `lib/data/function_calling/weather_function.dart` 中配置和风天气 API 信息：
```dart
final String _qWeatherApiHost = 'your-api-host';
final String _qWeatherProjectId = 'your-project-id';
final String _qWeatherCredentialId = 'your-credential-id';
final String _qWeatherPrivateKey = '''your-private-key''';
```

4. **运行项目**
```bash
# 运行到 Android 设备/模拟器
flutter run

# 运行到 iOS 设备/模拟器（需要 macOS）
flutter run -d ios

# 运行到 Web
flutter run -d chrome
```

## 📖 使用说明

### 天气查询示例

用户可以通过自然语言查询天气，例如：
- "北京现在的天气怎么样？"
- "上海未来 24 小时的天气预报"
- "深圳未来 7 天的天气情况"

应用会自动识别用户意图，调用相应的天气查询功能。

### 抖音视频解析示例

用户可以直接粘贴抖音分享文本，例如：
```
"帮我获取这个视频的下载链接 8.92 EUY:/ 07/06 G@v.fB 这个视频不错👍复制打开抖音极速版👀今天吹了一个超级完美的波波头# 小学生# 处女座  https://v.douyin.com/FmNeSgqBlac/"
```

应用会自动解析分享链接，返回无水印视频下载地址和相关信息。

## 🔧 开发说明

### 添加新的功能模块

1. 在 `lib/data/function_calling/` 目录下创建新的功能类
2. 定义功能的工具描述（tools）
3. 实现具体的功能方法
4. 在 `FunctionCallService` 中注册工具
5. 在 `parseFunctionCall` 方法中添加函数调用逻辑

### 工具定义示例

```dart
final List<Map<String, dynamic>> yourTools = [
  {
    "type": "function",
    "function": {
      "name": "yourFunctionName",
      "description": "功能描述",
      "parameters": {
        "type": "object",
        "properties": {
          "param1": {"type": "string", "description": "参数描述"},
        },
      },
      "required": ["param1"],
    },
  },
];
```

## 📦 依赖说明

| 依赖包 | 版本 | 说明 |
|--------|------|------|
| flutter | SDK | Flutter 框架 |
| cupertino_icons | ^1.0.8 | iOS 风格图标 |
| http | ^1.5.0 | HTTP 请求库 |
| get | ^4.6.6 | 状态管理和路由 |
| dio | ^5.2.1+1 | 强大的网络请求库 |
| cryptography | ^2.7.0 | 加密算法支持 |
| dart_jsonwebtoken | ^2.17.0 | JWT 认证 |

## 🌐 支持平台

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 📝 许可证

本项目仅供学习和研究使用。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📮 联系方式

如有问题或建议，欢迎联系项目维护者。

---

**注意**：使用本项目前，请确保已获取相应的 API 密钥，并遵守各服务提供商的使用条款。
