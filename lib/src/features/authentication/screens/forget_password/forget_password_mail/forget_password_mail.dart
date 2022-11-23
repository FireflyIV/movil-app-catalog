import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/constants/variables.dart';
import 'package:catalogo_app/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import '../../../../../common_widgets/form/form_header_widget.dart';
import '../../welcome/welcome_screen.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Just In-case if you want to replace the Image Color for Dark Theme
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: tPageWithTopIconPadding,
            child: Column(
              children: [
                // Back arrow button
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(onTap: () => Get.offAll(() => const WelcomeScreen()),child: const Icon(Icons.keyboard_backspace))
                ),
                const SizedBox(height: tDefaultSize * 4),
                FormHeaderWidget(
                  imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                  image: tForgetPasswordImage,
                  title: tForgetPassword,
                  subTitle: tForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => OTPScreen());
                              }, child: const Text(tNext))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
