import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_player/firebase_options.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

abstract class Initializer {
  static void init(VoidCallback runApp) {
    WidgetsFlutterBinding.ensureInitialized();
    runZonedGuarded(() async {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      runApp();
    }, (error, stack) {
      Get.printInfo(info: 'runZonedGuarded ERROR: ${error.toString()}');
      Get.printInfo(info: 'runZonedGuarded STACK: ${stack.toString()}');
    });
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
