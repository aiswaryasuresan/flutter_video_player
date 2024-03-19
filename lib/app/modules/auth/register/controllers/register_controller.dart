import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/utils/utils.dart';
import 'package:flutter_video_player/app/controllers/auth_controller.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  File? userImageFile;
  bool isLoading = false;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late AuthController authController;

  @override
  void onInit() {
    authController = Get.find();
    super.onInit();
  }

  _setLoadingState(bool s) {
    isLoading = s;
    update();
  }

  void signup() async {
    if (formKey.currentState!.validate()) {
      if (userImageFile != null) {
        _setLoadingState(true);
        _uploadImage();
      } else {
        Get.snackbar("No image selected", "Please select your profile image");
      }
    }
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'ttf'],
    );
    if (result != null) {
      userImageFile = File(result.files.single.path!);
      update();
    }
  }

  Future<void> _uploadImage() async {
    String extension = userImageFile!.path.substring(userImageFile!.path.lastIndexOf('.') + 1);
    String imageNewName = "${Utils.generateRandomText(36)}.$extension";
    Reference storageRef = _storage.ref().child('images').child(imageNewName);
    storageRef.putFile(userImageFile!).then((value) async {
      String downloadURL = await storageRef.getDownloadURL();
      _registerUserWithImage(downloadURL);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _registerUserWithImage(String downloadURL) async {
    String name = nameController.text;
    String email = emailController.text;
    String dob = dobController.text;

    await _fireStore.collection("users").doc(authController.uid).set({
      'username': name,
      'email': email,
      'dob': dob,
      'profileImageUrl': downloadURL, // Example profile image URL
    });
    Get.offAllNamed(Routes.HOME);
  }
}
