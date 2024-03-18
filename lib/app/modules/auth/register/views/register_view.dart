import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: GetBuilder<RegisterController>(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: _.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _.nameController,
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
                  controller: _.userImageController,
                  decoration: const InputDecoration(labelText: 'User Image'),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Please enter user image';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                  controller: _.dobController,
                  decoration: const InputDecoration(labelText: 'DOB'),
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
                    _.signup();
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
