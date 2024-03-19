import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_player/app/modules/auth/login/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginMobileView extends GetView<LoginController> {
  const LoginMobileView({super.key});

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
              controller: controller.mobileNumberController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
              decoration: const InputDecoration(labelText: 'Phone Number', prefix: Text("+91 ")),
              validator: (value) {
                if ((value ?? '').length != 10) {
                  return 'Please enter your 10 digit mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.login();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}
