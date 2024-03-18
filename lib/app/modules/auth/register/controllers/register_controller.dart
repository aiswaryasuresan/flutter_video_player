import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userImageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  void signup() {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String userImage = userImageController.text;
      String email = emailController.text;
      String dob = dobController.text;

      print('Name: $name');
      print('User Image: $userImage');
      print('Email: $email');
      print('DOB: $dob');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    userImageController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
