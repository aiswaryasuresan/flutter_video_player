import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => SwitchListTile(
              title: const Text('Select Theme'),
              value: controller.isDarkMode.value,
              onChanged: (_) {
                controller.toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 40),
          Obx(
            () => Text(
              controller.isDarkMode.value ? 'Dark Mode' : 'Light Mode',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
