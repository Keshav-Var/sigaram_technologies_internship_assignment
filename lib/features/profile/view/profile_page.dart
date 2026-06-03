import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/helper_widgets.dart';

import '../controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const GradientAppBar(
        title: 'Profile',
        subtitle: 'Manage your personal details',
      ),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withAlpha(220),
                        theme.colorScheme.secondary.withAlpha(220),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                controller.imagePath.value.isNotEmpty
                                ? FileImage(File(controller.imagePath.value))
                                : null,
                            child: controller.imagePath.value.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 64,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 4,
                              child: IconButton(
                                onPressed: controller.pickImage,
                                icon: Icon(
                                  Icons.edit,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        controller.name.value.isNotEmpty
                            ? controller.name.value
                            : 'Guest User',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Keep your profile information up to date.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Personal Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildEditableTile(
                          title: 'Name',
                          subtitle: controller.name.value,
                          icon: Icons.person,
                          onTap: () => _showNameDialog(context),
                        ),
                        const Divider(),
                        _buildEditableTile(
                          title: 'Age',
                          subtitle: controller.age.value.toString(),
                          icon: Icons.calendar_today,
                          onTap: () => _showAgeDialog(context),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Preferences',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.language,
                          label: 'Language',
                          value: controller.selectedLanguage.value,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.color_lens,
                          label: 'Theme Color',
                          value: controller.selectedColor.value,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.update),
                    label: const Text('Refresh Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: controller.loadProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black54),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black54, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  void _showNameDialog(BuildContext context) {
    final textController = TextEditingController(text: controller.name.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Update Name'),

        content: TextField(controller: textController),

        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await controller.updateName(textController.text);

              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAgeDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.age.value.toString(),
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Update Age'),

        content: TextField(
          keyboardType: TextInputType.number,
          controller: textController,
        ),

        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await controller.updateAge(
                int.tryParse(textController.text) ?? 0,
              );

              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
