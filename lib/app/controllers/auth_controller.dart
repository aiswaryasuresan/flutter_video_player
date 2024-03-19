import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_video_player/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool _isLoggedIn = false;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoggedIn => _isLoggedIn;
  String uid = '';
  String userName = '';
  String profileImageUrl = '';
  String email = '';
  String dob = '';

  @override
  void onInit() {
    _handleUser(_auth.currentUser);
    _setListeners();
    super.onInit();
  }

  void _setListeners() {
    _auth.authStateChanges().listen((User? user) {
      _handleUser(user);
    });
  }

  _handleUser(User? user) async {
    if (user == null) {
      uid = '';
      _isLoggedIn = false;
    } else {
      _isLoggedIn = true;
      uid = user.uid;
      update();
      refreshUserData();
    }
  }

  void refreshUserData() {
    _fireStore.collection('users').doc(uid).get().then((value) {
      if (value.exists) {
        Map<String, dynamic> docData = value.data() as Map<String, dynamic>;
        userName = docData['username'].toString();
        dob = docData['dob'].toString();
        email = docData['email'].toString();
        profileImageUrl = docData['profileImageUrl'].toString();
        update();
      }
    });
  }

  logout() {
    _auth.signOut();
    _isLoggedIn = false;
    uid = '';
    userName = '';
    profileImageUrl = '';
    email = '';
    dob = '';
    Get.offAllNamed(Routes.LOGIN);
    update();
  }
}
