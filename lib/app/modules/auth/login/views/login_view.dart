import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/modules/auth/login/controllers/login_controller.dart';
import 'package:flutter_video_player/app/modules/auth/login/views/login_mobile_view.dart';
import 'package:flutter_video_player/app/modules/auth/login/views/login_otp_view.dart';
import 'package:flutter_video_player/app/modules/widgets/loading_widget.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: GetBuilder<LoginController>(builder: (controller) {
        return controller.isLoading
            ? const LoadingWidget()
            : controller.isSendOtp
                ? const LoginOtpView()
                : const LoginMobileView();
      }),
    );
  }
}
