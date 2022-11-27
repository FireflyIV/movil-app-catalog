
import 'package:catalogo_app/src/features/core/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication_repository/exceptions/signup_email_password_failure.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.put(UserRepository());

  late UserModel userModel;
  final user = FirebaseAuth.instance.currentUser!;

  CollectionReference users = FirebaseFirestore.instance.collection('users');



  @override
  void onReady() {

  }

  Future<String> updateUser(String name, String email, String password) async {
    String res = "";
    try {
      user.updateDisplayName(name);
      user.updateEmail(email);
      if (password != "") {
        user.updatePassword(password);
      }
      await users.doc(user.uid).update({
        'name': name,
        'email': email
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      res = ex.message;
      print('Firebase auth exception -  ${ex.message}');
      //throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      res = ex.message;
      print('Exception - ${ex.message}');
      res = ex.message;
    }
    return res;
  }

  Future<void> updatePhoto(String url) async {
    await users.doc(user.uid).update({
      'photoURL' : url
    });
  }

  Future<DocumentSnapshot<Object?>?> getUser() async {
    AsyncSnapshot<DocumentSnapshot<Object?>> snapshot = users.doc(user.uid).snapshots() as AsyncSnapshot<DocumentSnapshot<Object?>>;
    if (snapshot.hasData){
      var userDocument = snapshot.data;
      return userDocument;
    }
    return null;
  }
}