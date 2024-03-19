import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/storage/storage.dart';
import 'package:flutter_video_player/app/common/utils/initializer.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    _getCurrentTheme();
    super.onInit();
  }

  Future<void> _getCurrentTheme() async {
    isDarkMode.value = Initializer.getThemeMode() == ThemeMode.dark;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Storage.saveValueForce("isDark", isDarkMode.value);
    Get.changeThemeMode(Initializer.getThemeMode());
  }
}
