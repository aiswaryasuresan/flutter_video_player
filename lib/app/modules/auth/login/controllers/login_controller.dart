import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      print('Username: $email');
      print('Password: $password');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void goToRegistration() => Get.toNamed(Routes.REGISTER);
}
