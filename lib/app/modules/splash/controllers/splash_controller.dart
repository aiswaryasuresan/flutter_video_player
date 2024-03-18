import 'package:flutter_video_player/app/controllers/auth_controller.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    _checkLogin();
    super.onInit();
  }

  _checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final AuthController auth = Get.find();
    if (auth.isLoggedIn) {
      Get.toNamed(Routes.HOME);
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
