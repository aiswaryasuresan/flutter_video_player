import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/utils/utils.dart';
import 'package:flutter_video_player/app/modules/widgets/loading_widget.dart';
import 'package:flutter_video_player/app/modules/widgets/profile_image_widget.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Registration'),
        centerTitle: true,
      ),
      body: GetBuilder<RegisterController>(
        builder: (signupController) {
          return signupController.isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Form(
                    key: signupController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Text('Pick profile image'),
                        const SizedBox(height: 20),
                        ProfileImageWidget(
                          localFile: signupController.userImageFile,
                          size: 120,
                          onAddImage: () {
                            signupController.pickImage();
                          },
                          editable: true,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: signupController.nameController,
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
                          controller: signupController.emailController,
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
                          controller: signupController.dobController,
                          decoration: const InputDecoration(labelText: 'DOB'),
                          onTap: () => signupController.selectDob(context),
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
                            signupController.signup();
                          },
                          child: const Text('Sign Up'),
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
