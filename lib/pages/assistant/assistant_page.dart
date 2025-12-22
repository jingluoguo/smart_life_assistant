import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/controller/theme_controller.dart';
import 'package:smart_life_assistant/core/value/colors.dart';
import 'package:smart_life_assistant/core/value/theme_model.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_controller.dart';

class AssistantPage extends StatelessWidget {
  AssistantPage({super.key});

  final controller = Get.find<AssistantController>();

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
            color: color.withValues(alpha: 0.1),
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
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector() {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            ThemeModel.allThemes.map((theme) {
              final isSelected =
                  themeController.currentTheme.name == theme.name;
              return ElevatedButton.icon(
                onPressed: () {
                  themeController.switchTheme(theme.name);
                },
                icon: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? theme.primary : null,
                ),
                label: Text(
                  theme.name == 'default'
                      ? '默认'
                      : theme.name == 'dark'
                      ? '暗色'
                      : theme.name,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.background,
                  foregroundColor: theme.textPrimary,
                  side: BorderSide(
                    color: theme.primary,
                    width: isSelected ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  List<TextSpan> parseTextWithUrls(String text) {
    final RegExp urlRegex = RegExp(r'https?://[^\s\)]+');
    final List<TextSpan> spans = [];
    int lastIndex = 0;

    urlRegex.allMatches(text).forEach((match) {
      // 添加匹配前的文本
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
        );
      }

      // 添加可点击的URL
      spans.add(
        TextSpan(
          text: match.group(0)!, // 安全调用，因为是匹配项
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () {
                  controller.handleLaunchUrl(match.group(0)!); // 安全调用，因为是匹配项
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
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(FlutterI18n.translate(context, 'app.title')),
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
                    Text(
                      FlutterI18n.translate(context, 'app.features'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.cloud_outlined,
                      title: FlutterI18n.translate(context, 'app.weather'),
                      description: FlutterI18n.translate(
                        context,
                        'app.weatherDescription',
                      ),
                      color: AppColors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.video_library_outlined,
                      title: FlutterI18n.translate(context, 'app.tiktok'),
                      description: FlutterI18n.translate(
                        context,
                        'app.tiktokDescription',
                      ),
                      color: AppColors.pink,
                    ),
                    const SizedBox(height: 20),
                    // 主题切换部分
                    Text(
                      '选择主题',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildThemeSelector(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 用户输入区域
            TextField(
              controller: controller.inputController,
              decoration: InputDecoration(
                labelText: FlutterI18n.translate(context, 'app.inputLabel'),
                border: const OutlineInputBorder(),
                suffixIcon: Obx(
                  () =>
                      controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: controller.handleFunctionCall,
                          ),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // 结果显示区域
            Obx(
              () =>
                  controller.result.value.isNotEmpty
                      ? Expanded(
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FlutterI18n.translate(
                                    context,
                                    'app.resultTitle',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: RichText(
                                      text: TextSpan(
                                        children: parseTextWithUrls(
                                          controller.result.value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
