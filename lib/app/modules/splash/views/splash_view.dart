import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter_video_player/app/modules/widgets/loading_widget.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        centerTitle: true,
      ),
      body: const LoadingWidget(),
    );
  }
}
