import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("O"),
        const SizedBox(height: tFormHeight - 10,),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(image: AssetImage(tGoogleLogoImage), width: 20.0,),
            onPressed: () {},
            label: const Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(height: tFormHeight - 10,),
        TextButton(
            onPressed: () {},
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