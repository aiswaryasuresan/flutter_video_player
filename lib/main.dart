import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/utils/initializer.dart';
import 'package:flutter_video_player/app/core/app_themes.dart';
import 'package:flutter_video_player/app/modules/widgets/loading_widget.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  Initializer.init(() {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Video Player",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
      builder: (_, child) => child ?? const LoadingWidget(),
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: Initializer.getThemeMode(),
    );
  }
}
