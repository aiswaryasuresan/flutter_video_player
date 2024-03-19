import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/utils/utils.dart';
import 'package:flutter_video_player/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter_video_player/app/modules/widgets/loading_widget.dart';
import 'package:flutter_video_player/app/modules/widgets/profile_image_widget.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: GetBuilder<ProfileController>(
        builder: (profileController) {
          return profileController.isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Form(
                    key: profileController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Text('Pick profile image'),
                        const SizedBox(height: 20),
                        ProfileImageWidget(
                          localFile: profileController.userImageFile,
                          imageUrl: profileController.profileImageUrl,
                          size: 120,
                          onAddImage: () {
                            profileController.pickImage();
                          },
                          editable: true,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: profileController.nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: profileController.emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!Utils.isValidEmail(value!)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: profileController.dobController,
                          decoration: const InputDecoration(labelText: 'DOB'),
                          onTap: () => profileController.selectDob(context),
                          readOnly: true,
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Please enter your Date of Birth';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            profileController.updateProfile();
                          },
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
