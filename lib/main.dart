import 'dart:async' as runtime;
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_life_assistant/data/service/function_call_service.dart';

void main() {
  runtime.runZoned(_runMain);
}

void _runMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '智能生活助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SmartLifeAssistantHome(),
    );
  }
}

class SmartLifeAssistantHome extends StatefulWidget {
  const SmartLifeAssistantHome({super.key});

  @override
  State<SmartLifeAssistantHome> createState() => _SmartLifeAssistantHomeState();
}

class _SmartLifeAssistantHomeState extends State<SmartLifeAssistantHome>
    with WidgetsBindingObserver {
  final TextEditingController _inputController = TextEditingController();
  final FunctionCallService _functionCallService =
      FunctionCallService.getInstance();
  bool _isLoading = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 初始化时也检查一次剪贴板
    _checkClipboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inputController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 应用恢复到前台时检查剪贴板
      _checkClipboard();
    }
  }

  Future<void> _checkClipboard() async {
    try {
      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null && data.text != null) {
        final String clipboardText = data.text!;
        // 检查是否包含抖音链接
        if (clipboardText.contains('v.douyin.com')) {
          setState(() {
            _inputController.text = clipboardText;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('读取剪贴板失败: $e');
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _result = '无法打开链接: $url';
      });
    }
  }

  List<TextSpan> _parseTextWithUrls(String text) {
    final RegExp urlRegex = RegExp(r'https?://[^\s\)]+');
    final List<TextSpan> spans = [];
    int lastIndex = 0;

    urlRegex.allMatches(text).forEach((match) {
      // 添加匹配前的文本
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        );
      }

      // 添加可点击的URL
      spans.add(
        TextSpan(
          text: match.group(0)!, // 安全调用，因为是匹配项
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () {
                  _launchUrl(match.group(0)!); // 安全调用，因为是匹配项
                },
        ),
      );

      lastIndex = match.end;
    });

    // 添加剩余的文本
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }

    return spans;
  }

  void _handleFunctionCall() async {
    // if (_inputController.text.isEmpty) return;
    if (_inputController.text.isEmpty) {
      if (kDebugMode) {
        _inputController.text =
            "我获取这个视频的下载链接 8.92 EUY:/ 07/06 G@v.fB 这个视频不错👍复制打开抖音极速版👀今天吹了一个超级完美的波波头# 小学生# 处女座  https://v.douyin.com/FmNeSgqBlac/";
      } else {
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _result = '正在处理...';
    });

    try {
      final result = await _functionCallService.handleFunctionCall(
        text: _inputController.text,
      );
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = '处理失败：$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('智能生活助手'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 功能介绍卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '可用功能',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.cloud_outlined,
                      title: '天气查询',
                      description: '根据经纬度或者城市查询实时天气、逐小时预报和每日预报',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.video_library_outlined,
                      title: 'TikTok视频解析',
                      description: '从抖音分享链接中提取无水印视频下载地址',
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 用户输入区域
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: '请输入查询内容或分享链接',
                border: const OutlineInputBorder(),
                suffixIcon:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _handleFunctionCall,
                        ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // 结果显示区域
            if (_result.isNotEmpty)
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '处理结果',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: RichText(
                              text: TextSpan(
                                children: _parseTextWithUrls(_result),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
