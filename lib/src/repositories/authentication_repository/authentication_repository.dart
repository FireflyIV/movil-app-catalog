
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/dashboard_screen.dart';
import 'package:catalogo_app/src/repositories/authentication_repository/exceptions/login_email_password_failure.dart';
import 'package:catalogo_app/src/repositories/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/core/models/user/user_model.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) :
                    Get.offAll(() => const Dashboard());
  }

  // Email and password
  Future<String> createUserWithEmailAndPassword(String fullName,String email, String password) async {
    String error = "";
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      createUser(userCredential.user!.uid.toString(), fullName, email, tProfileImage);

    } on FirebaseAuthException catch (e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      error = ex.message;
      print('Firebase auth exception -  ${ex.message}');
      //throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      error = ex.message;
      print('Exception - ${ex.message}');
      error = ex.message;
      //throw ex;
    }
    return error;
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    String error = "";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);
      error = ex.message;
      print('Firebase auth login exception -  ${ex.message}');
    } catch(_) {
      const ex = LoginWithEmailAndPasswordFailure();
      print('Exception login - ${ex.message}');
      error = ex.message;
    }
    return error;
  }

  // Google
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final google = await _auth.signInWithCredential(credential);
      createUser(google.user!.uid.toString(), google.user!.displayName.toString(),
          google.user!.email.toString(), google.user!.photoURL.toString());

    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> createUser(String id, String fullName, String email, String photoURL) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    final user = UserModel(
        id,
        fullName,
        email,
        photoURL
    );
    final json = user.toJson();
    await docUser.set(json);
    print("Usuario creado");
  }

  Future<UserModel?> readUser() async {
    User user = firebaseUser as User;
    final docUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    } else{
      return null;
    }
  }
}