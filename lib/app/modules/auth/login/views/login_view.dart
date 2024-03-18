import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/modules/auth/login/controllers/login_controller.dart';
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
      body: GetBuilder<LoginController>(builder: (_) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: _.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _.passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _.login();
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const Center(child: Text('Don\'t have account?,')),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () => _.goToRegistration(),
                  child: const Text('Signup'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
