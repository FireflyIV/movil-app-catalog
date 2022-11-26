import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../common_widgets/custom_snack_bar/custom_good_snack_bar.dart';
import '../../../../common_widgets/custom_snack_bar/custom_snack_bar.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/controllers/signup_controller.dart';
import '../../controllers/profile_controller.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  static final _formEditProfileKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final profileController = Get.put(ProfileController());
    final user = FirebaseAuth.instance.currentUser!;

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final db = FirebaseFirestore.instance;

    return StreamBuilder(
        stream: db.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: (CircularProgressIndicator()));
          }
          var userDocument = snapshot.data;
          //return new Text(userDocument["name"]);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
              title: Center(child: Text(tEditProfile, style: Theme.of(context).textTheme.headline4)),

              actions: [
                IconButton(onPressed: () {}, icon: Icon(isDark? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100), child: Image.network(userDocument!["photoURL"]),
                            )
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: tAccentColor),
                            child: const Icon(
                              LineAwesomeIcons.camera,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Form(
                      key: _formEditProfileKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return tValidationMessage;
                              }
                            },
                            controller: profileController.fullName,
                            decoration: const InputDecoration(
                                label: Text(tFullName),
                                prefixIcon: Icon(Icons.person_outline_rounded)),
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return tValidationMessage;
                              }
                              return null;
                            },
                            controller: profileController.email,
                            decoration: const InputDecoration(
                                label: Text(tEmail), prefixIcon: Icon(Icons.email_outlined)),
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          TextFormField(
                            controller: profileController.password,
                            decoration: const InputDecoration(
                                label: Text(tPassword), prefixIcon: Icon(Icons.fingerprint)),
                          ),
                          const SizedBox(height: tFormHeight - 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formEditProfileKey.currentState!.validate()){
                                  ProfileController.instance.updateUser(
                                      profileController.fullName.text.trim(),
                                      profileController.email.text.trim(),
                                      profileController.password.text.trim()).then((String error){
                                    print('SignUpForm::MessageError: $error');
                                    if (error != ''){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: CustomSnackBar(
                                            errorMessage: error.toString(),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: CustomGoodSnackBar(
                                            message: "Datos actualizados correctamente",
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              child: Text(tSave.toUpperCase()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  

}