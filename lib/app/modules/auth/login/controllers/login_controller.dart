import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool isSendOtp = false;
  String _verificationId = '';
  String number = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int? _resendToken;
  var countdown = 120.obs;
  late Timer _timer;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  void login() {
    if (formKey.currentState!.validate()) {
      number = mobileNumberController.text;
      verifyPhone();
    }
  }

  void verifyOtp() {
    if (formKey.currentState!.validate()) {
      String otp = otpController.text;
      _verifyOTP(otp);
    }
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  _setLoadingState(bool s) {
    isLoading = s;
    update();
  }

  void goToRegistration() => Get.toNamed(Routes.REGISTER);

  void goToHome() => Get.toNamed(Routes.HOME);

  Future<void> verifyPhone() async {
    if (number.length != 10 && !number.isNumericOnly) {
      Get.snackbar('Verification Failed', 'Invalid phone number. Please enter a valid mobile number.');
      return;
    }
    _setLoadingState(true);
    _auth.verifyPhoneNumber(
      forceResendingToken: _resendToken,
      phoneNumber: "+91$number",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          _userLoggedIn(userCredential.user!);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.log(e.message ?? 'Error firebase, or network', isError: true);
        String message = '';
        switch (e.code) {
          case 'invalid-phone-number':
            message = 'Invalid phone number. Please enter a valid mobile number.';
            break;
          case 'quota-exceeded':
            message = 'SMS quota exceeded. Please try again later.';
            break;
          case 'too-many-requests':
            message = 'Too many requests. Please try again later.';
            break;
          default:
            message = 'Verification failed. Please try again later.';
            break;
        }
        Get.snackbar('Verification Failed', message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        isSendOtp = true;
        _setLoadingState(false);
        _startOtpResendCountdown();
        Get.snackbar('Success', "An OTP send to your mobile number");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _startOtpResendCountdown() {
    countdown.value = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP(otpCode) async {
    printInfo(info: "Verify OTP code start, ");
    _setLoadingState(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: otpCode);
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        _userLoggedIn(userCredential.user!);
      } else {
        Get.snackbar("Invalid otp", "Please enter the otp code. We send to your mobile number.");
        _setLoadingState(false);
      }
    } catch (e) {
      print(e);
      _setLoadingState(false);
      Get.snackbar("Invalid otp", "Please enter the otp code. We send to your mobile number.");
    }
  }

  _userLoggedIn(User user) async {
    printInfo(info: "Success fully logged in");

    ///logged in
    DocumentSnapshot documentSnapshot = await _fireStore.collection('users').doc(user.uid).get();
    if (documentSnapshot.exists) {
      ///user already registered
      goToHome();
    } else {
      ///user not exist
      ///do register
      goToRegistration();
    }
  }
}
