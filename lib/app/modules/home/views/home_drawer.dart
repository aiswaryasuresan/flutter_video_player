import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/controllers/auth_controller.dart';
import 'package:flutter_video_player/app/modules/widgets/profile_image_widget.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GetBuilder<AuthController>(builder: (authController) {
        return authController.isLoggedIn
            ? ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.userName.toUpperCase(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              authController.email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        ProfileImageWidget(
                          imageUrl: authController.profileImageUrl,
                          size: 60,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    onTap: () => Get.toNamed(Routes.PROFILE),
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () => Get.toNamed(Routes.SETTINGS),
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () => authController.logout(),
                  ),
                ],
              )
            : ListTile(
                title: const Text('Login'),
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
              );
      }),
    );
    ;
  }
}
