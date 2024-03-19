import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/utils/utils.dart';
import 'package:flutter_video_player/app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String dob = "";
  String profileImageUrl = "";
  File? userImageFile;
  bool isLoading = true;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late AuthController authController;

  @override
  void onInit() {
    authController = Get.find();
    _setUserData();
    super.onInit();
  }

  _setLoadingState(bool s) {
    isLoading = s;
    update();
  }

  void _setUserData() {
    _fireStore.collection('users').doc(authController.uid).get().then((value) {
      if (value.exists) {
        Map<String, dynamic> docData = value.data() as Map<String, dynamic>;
        nameController.text = docData['username'].toString();
        dob = docData['dob'].toString();
        DateTime dobDate = DateFormat.yMd().parse(dob);
        dobController.text = DateFormat('MMMM d, yyyy').format(dobDate);
        emailController.text = docData['email'].toString();
        profileImageUrl = docData['profileImageUrl'].toString();
      }
      _setLoadingState(false);
    }).onError((error, stackTrace) {
      printInfo(info: "Error fetching data ERROR : $error");
      printInfo(info: "Error fetching data STACK : $stackTrace");
      _setLoadingState(false);
      Get.snackbar("Error!", "Network error occurred");
    });
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

  void _registerUserWithImage(String downloadURL) async {
    String name = nameController.text;
    String email = emailController.text;

    await _fireStore.collection("users").doc(authController.uid).set({
      'username': name,
      'email': email,
      'dob': dob,
      'profileImageUrl': downloadURL, // Example profile image URL
    });
    Get.snackbar("Updated", "Profile details has been updated");
  }

  Future<void> selectDob(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      print('Selected date: $pickedDate');
      final formattedDate = DateFormat('MMMM d, yyyy').format(pickedDate);
      dob = DateFormat.yMd().format(pickedDate);
      dobController.text = formattedDate;
    }
  }

  void updateProfile() async {
    if (formKey.currentState!.validate()) {
      _setLoadingState(true);
      if (userImageFile != null) {
        String? url = await _uploadImageAndGetUrl();
        if (url != null) {
          profileImageUrl = url;
        }
      }
      await _fireStore.collection("users").doc(authController.uid).update({
        'username': nameController.text,
        'email': emailController.text,
        'dob': dob,
        'profileImageUrl': profileImageUrl,
      });
      userImageFile = null;
      _setLoadingState(false);
      authController.refreshUserData();
    }
  }

  Future<String?> _uploadImageAndGetUrl() async {
    try {
      String extension = userImageFile!.path.substring(userImageFile!.path.lastIndexOf('.') + 1);
      String imageNewName = "${Utils.generateRandomText(36)}.$extension";
      Reference storageRef = _storage.ref().child('images').child(imageNewName);
      await storageRef.putFile(userImageFile!);
      return storageRef.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return null;
  }
}
