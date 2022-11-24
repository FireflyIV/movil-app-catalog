import 'package:catalogo_app/src/repositories/authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // TextField Controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  // Register function to use in design
  void registerUser(String email, String password, fullName, phoneNo) {
    AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  void logout() {
    AuthenticationRepository.instance.logout();
  }
}