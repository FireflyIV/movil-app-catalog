import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../welcome/welcome_screen.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// <- Back arrow button
        Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(onTap: () => Get.offAll(() => const WelcomeScreen()),child: const Icon(Icons.keyboard_backspace))
        ),
        Image(
          image: const AssetImage(tWelcomeStringImage),
          height: size.height * 0.2,),
        Text(tLoginTitle, style: Theme.of(context).textTheme.headline1),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}