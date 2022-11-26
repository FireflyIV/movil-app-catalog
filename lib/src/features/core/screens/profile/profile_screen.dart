import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/core/controllers/profile_controller.dart';
import 'package:catalogo_app/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:catalogo_app/src/features/core/screens/profile/widgets/profile_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../authentication/controllers/signup_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {

    final profileController = Get.put(ProfileController());
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final db = FirebaseFirestore.instance;
    final formController = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();

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
              leading: IconButton(onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
              title: Text(tProfile, style: Theme.of(context).textTheme.headline4),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(isDark? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Stack(
                  children: [
                    Column(
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
                        const SizedBox(height: 10),
                        Text(userDocument["name"], style: Theme.of(context).textTheme.headline4),
                        Text(userDocument["email"], style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () => Get.to(() =>  UpdateProfileScreen()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: tAccentColor, side: BorderSide.none, shape: const StadiumBorder()
                            ),
                            child: const Text(tEditProfile, style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(title: "Leer QR", icon: LineAwesomeIcons.qrcode, onPress: (){}),
                        ProfileMenuWidget(title: "Información", icon: LineAwesomeIcons.info, onPress: (){}),
                        ProfileMenuWidget(title: "Cerrar Sesión", icon: LineAwesomeIcons.alternate_sign_out,
                            textColor: Colors.redAccent,
                            endIcon: false,
                            onPress: () => profileController.logout()),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );


  }

  Future<String> getData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;

    String data = "";
    var collection = db.collection('users');
    var docSnapshot = await collection.doc(user.uid).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data?['name']);
      return data?['name'];
    }
    return data;
  }


}

