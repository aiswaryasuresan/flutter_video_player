import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_video_player/app/controllers/auth_controller.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  bool isRegistrationComplete = false;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  void onInit() {
    _checkLogin();
    super.onInit();
  }

  _checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final AuthController auth = Get.find();
    if (auth.isLoggedIn) {
      DocumentSnapshot userSnapshot = await _fireStore.collection("users").doc(auth.uid).get();
      if (userSnapshot.exists) {
        Get.toNamed(Routes.HOME);
      } else {
        Get.offNamed(Routes.REGISTER);
      }
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }

  _checkRegistrations() {}
}
