import 'package:catalogo_app/src/common_widgets/fade_in_animation/animation_design.dart';
import 'package:catalogo_app/src/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:catalogo_app/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/fade_in_animation/fade_in_animation_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startAnimation();

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? tPrimaryColor : tLightPrimaryColor,
      body: Stack(
        children: [
          TFadeInAnimation(
            durationInMs: 1200,
            animate: TAnimatePosition(
              bottomAfter: 0, bottomBefore: -100,
              leftBefore: 0, leftAfter: 0,
              topAfter: 0, topBefore: 0,
              rightBefore: 0, rightAfter: 0
            ),
            child: Container(
              padding: const EdgeInsets.all(tDefaultSize),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(image: const AssetImage(tWelcomeStringImage), height: height * 0.6,),
                  Column(
                    children: [
                      Text(
                        tWelcomeTitle,
                        style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center
                      ),
                      Text(
                        tWelcomeSubtitle,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child : OutlinedButton(
                              onPressed: () => Get.to(() => const LoginScreen()),
                              child: const Text(tLogin)
                          )
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () => Get.to(() => const SignUpScreen()),
                              child: const Text(tSignup)
                          )
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}