import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/utils/common_util.dart';
import 'package:smart_life_assistant/core/value/colors.dart';
import 'package:smart_life_assistant/pages/assistant/assistant_controller.dart';
import 'package:smart_life_assistant/route/app_pages.dart';

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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              '菜单',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text('主题设置'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.themeSettings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('关于应用'),
            onTap: () {
              Navigator.pop(context);
              // 这里可以添加关于页面的导航
            },
          ),
        ],
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
        title: Text(i18n('app.title')),
        centerTitle: true,
        leading: Builder(
          builder: (ctx) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            );
          },
        ),
      ),
      drawer: _buildDrawer(context),
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
                      i18n('app.features'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.cloud_outlined,
                      title: i18n('app.weather'),
                      description: i18n('app.weatherDescription'),
                      color: AppColors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.video_library_outlined,
                      title: i18n('app.tiktok'),
                      description: i18n('app.tiktokDescription'),
                      color: AppColors.pink,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 用户输入区域
            TextField(
              controller: controller.inputController,
              decoration: InputDecoration(
                labelText: i18n('app.inputLabel'),
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
                                  i18n('app.resultTitle'),
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
