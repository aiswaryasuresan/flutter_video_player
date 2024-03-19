import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_player/app/modules/auth/login/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginOtpView extends GetView<LoginController> {
  const LoginOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: controller.otpController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'OTP'),
              validator: (value) {
                if ((value ?? '').length != 6) {
                  return 'Please enter 6 digit otp code';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.verifyOtp();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Center(
              child: Obx(() {
                return RichText(
                  text: TextSpan(
                    children: [
                      if (controller.countdown.value > 0)
                        TextSpan(
                          text: 'Resend OTP in ${controller.countdown.value} seconds',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      if (controller.countdown.value == 0)
                        TextSpan(
                          text: ' Resend',
                          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              controller.verifyPhone();
                            },
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}
