import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../../../../constants/variables.dart';
import '../../welcome/welcome_screen.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({Key? key}) : super(key: key);

  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: tPageWithTopIconPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back arrow button
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(onTap: () => Get.offAll(() => const WelcomeScreen()),child: const Icon(Icons.cancel_outlined))
            ),
            Text(
              tOtpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 40.0),
            const Text("$tOtpMessage support@codingwitht.com", textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OTPTextField(
              controller: otpController,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                length: 6,
                onCompleted: (code) => print("OTP is => $code")),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text(tNext)),
            ),
          ],
        ),
      ),
    );
  }
}
