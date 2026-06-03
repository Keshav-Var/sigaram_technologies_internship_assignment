import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/helper_widgets.dart';
import 'package:sigaram_technologies_internship_assignment/features/settings/controller/setting_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  static const Map<String, Color> _themeColors = {
    'Sea Green': Color(0xFF2EDFB5),
    'Hot Pink': Color(0xFFFB6EA5),
    'Lavender': Color(0xFFC8B8FF),
    'Lemon Yellow': Color(0xFFF7E24B),
    'Biege (default)': Color(0xFFD6C59F),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Settings',
        subtitle: 'Customize language and theme color',
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12, top: 10),
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.palette, size: 28),
        //       color: Colors.white,
        //     ),
        //   ),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                title: 'Select Language',
                subtitle: 'Choose the app language you prefer',
              ),
              const SizedBox(height: 12),
              _buildLanguageGrid(theme),
              const SizedBox(height: 24),
              _buildSectionHeader(
                title: 'Select Color',
                subtitle: 'Pick a theme color for your app',
              ),
              const SizedBox(height: 12),
              _buildColorGrid(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildLanguageGrid(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.languages.map((language) {
        final bool selected = controller.selectedLanguage.value == language;
        return GestureDetector(
          onTap: () => controller.changeLanguage(language),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                if (!selected)
                  const BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? theme.colorScheme.primary
                        : Colors.grey[800],
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.colors.map((colorName) {
        final bool selected = controller.selectedColor.value == colorName;
        final colorValue = _themeColors[colorName] ?? Colors.grey.shade300;
        final textColor = colorValue.computeLuminance() > 0.55
            ? Colors.black87
            : Colors.white;

        return GestureDetector(
          onTap: () => controller.changeColor(colorName),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 150,
            height: 110,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorValue,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? Colors.black87 : Colors.transparent,
                width: selected ? 3 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  colorName,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: selected ? 1 : 0,
                    child: Icon(Icons.check_circle, color: textColor, size: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
