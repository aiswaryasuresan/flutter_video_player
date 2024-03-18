import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  @override
  void onInit() {
    _isLoggedIn = FirebaseAuth.instance.currentUser != null;
    _setListeners();
    super.onInit();
  }

  void _setListeners() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _isLoggedIn = user != null;

      // if (user == null) {
      //   _isLoggedIn = false;
      // } else {
      //   _isLoggedIn = true;
      // }
    });
  }
}
