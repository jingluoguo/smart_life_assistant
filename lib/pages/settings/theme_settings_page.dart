import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_life_assistant/core/controller/theme_controller.dart';
import 'package:smart_life_assistant/core/utils/common_util.dart';
import 'package:smart_life_assistant/core/value/colors.dart';
import 'package:smart_life_assistant/core/value/theme_model.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n('themeSettings.title')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n('settings.selectTheme'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildThemeOptions(themeController),
            const SizedBox(height: 32),
            _buildThemePreview(themeController),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptions(ThemeController themeController) {
    return Obx(
      () => Column(
        children:
            ThemeModel.allThemes.map((theme) {
              final isSelected =
                  themeController.currentTheme.name == theme.name;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isSelected ? 4 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? theme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  title: Text(
                    theme.name == 'default'
                        ? i18n('settings.defaultTheme')
                        : theme.name == 'dark'
                        ? i18n('settings.darkTheme')
                        : theme.name == 'blue'
                        ? i18n('settings.blueTheme')
                        : theme.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    theme.name == 'dark'
                        ? i18n('settings.darkThemeDescription')
                        : theme.name == 'blue'
                        ? i18n('settings.blueThemeDescription')
                        : i18n('settings.defaultThemeDescription'),
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: Radio<String>(
                    value: theme.name,
                    groupValue: themeController.currentTheme.name,
                    onChanged: (value) {
                      if (value != null) {
                        themeController.switchTheme(value);
                      }
                    },
                    activeColor: theme.primary,
                  ),
                  onTap: () {
                    themeController.switchTheme(theme.name);
                  },
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildThemePreview(ThemeController themeController) {
    return Obx(() {
      final theme = themeController.currentTheme;
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.backgroundSecondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n('settings.themePreview'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColorPreview(
                    i18n('settings.primaryColor'),
                    theme.primary,
                  ),
                  _buildColorPreview(
                    i18n('settings.secondaryColor'),
                    theme.secondary,
                  ),
                  _buildColorPreview(
                    i18n('settings.accentColor'),
                    theme.accent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColorPreview(
                    i18n('settings.textColor'),
                    theme.textPrimary,
                  ),
                  _buildColorPreview(
                    i18n('settings.backgroundColor'),
                    theme.background,
                  ),
                  _buildColorPreview(
                    i18n('settings.secondaryBackgroundColor'),
                    theme.backgroundSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildColorPreview(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
