import 'package:catalogo_app/src/features/core/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../authentication/controllers/signup_controller.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  final bool isDark;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: tPrimaryColor,
      titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      title: const Text(tAppName),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 7, bottom: 7),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: GestureDetector(
            onTap: () => Get.to(ProfileScreen()),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/catalog-movil-app.appspot.com/o/default_profile_photo.png?alt=media&token=f3ff6aaa-c43b-47fa-a2b3-aa6c0786fcea"),
              ),
          ),
          ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(55);
}
