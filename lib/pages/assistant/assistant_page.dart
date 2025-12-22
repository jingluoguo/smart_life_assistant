import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
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
            color: color.withValues(alpha: .1),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.video_library_outlined,
                      title: FlutterI18n.translate(context, 'app.tiktok'),
                      description: FlutterI18n.translate(
                        context,
                        'app.tiktokDescription',
                      ),
                      color: Colors.pink,
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
                                        children: controller.parseTextWithUrls(
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
