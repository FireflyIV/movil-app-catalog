
import 'package:catalogo_app/src/repositories/user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repositories/authentication_repository/authentication_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final email = TextEditingController(text: FirebaseAuth.instance.currentUser!.email);
  final password = TextEditingController();
  final fullName = TextEditingController(text: FirebaseAuth.instance.currentUser!.displayName);

  Future<String> updateUser(String fullName, String email, String password) async {
        return  await UserRepository.instance.updateUser(fullName, email, password);

  }

  void logout() {
    AuthenticationRepository.instance.logout();
  }

}