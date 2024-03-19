import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  String uid = '';

  @override
  void onInit() {
    _handleUser(FirebaseAuth.instance.currentUser);
    _setListeners();
    super.onInit();
  }

  void _setListeners() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _handleUser(user);
    });
  }

  _handleUser(User? user) {
    if (user == null) {
      uid = '';
      _isLoggedIn = false;
    } else {
      _isLoggedIn = true;
      uid = user.uid;
    }
  }

  void setUserData() {}
}
