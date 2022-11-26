import 'package:catalogo_app/src/repositories/authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // TextField Controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  // Register function to use in design
  Future<String> registerUser(String email, String password, fullName) async {
    return await AuthenticationRepository.instance.createUserWithEmailAndPassword(fullName, email, password);
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    return await AuthenticationRepository.instance.signInWithEmailAndPassword(email, password);
  }

  void signInWithGoogle(){
    AuthenticationRepository.instance.signInWithGoogle();
  }

  void logout() {
    AuthenticationRepository.instance.logout();
  }
}