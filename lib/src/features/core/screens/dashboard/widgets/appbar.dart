import 'package:catalogo_app/src/features/core/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
      titleTextStyle: Theme.of(context).textTheme.headline4,
      title: const Text(tAppName),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 7, bottom: 7),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: GestureDetector(
            onTap: () => Get.to(ProfileScreen()),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.photoURL.toString()),

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
