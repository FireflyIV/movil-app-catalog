import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_controller.dart';
import '../welcome/welcome_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formController = Get.put(SignUpController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("O"),
        const SizedBox(height: tFormHeight - 10,),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(image: AssetImage(tGoogleLogoImage), width: 20.0,),
            onPressed: () {
              formController.signInWithGoogle();
            },
            label: const Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(height: tFormHeight - 10,),
        TextButton(
            onPressed: () => Get.offAll(() => const SignUpScreen()),
            child: Text.rich(
                TextSpan(
                    text: tDontHaveAnAccount,
                    style: Theme.of(context).textTheme.bodyText1,
                    children: const [
                      TextSpan(
                        text: tSignup,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ]
                ))),
      ],
    );
  }
}