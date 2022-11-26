import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/authentication/screens/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snack_bar/custom_snack_bar.dart';
import '../../controllers/signup_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formController = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: tFormHeight -10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return tValidationMessage;
                  }
                },
                controller: formController.email,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: tEmail,
                  hintText: tEmail,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: tFormHeight - 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return tValidationMessage;
                  }
                },
                controller: formController.password,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: tPassword,
                    hintText: tPassword,
                    border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: tFormHeight - 30),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: const Text(tForgetPassword),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()){
                      SignUpController.instance.signInWithEmailAndPassword(
                          formController.email.text.trim(),
                          formController.password.text.trim()).then((String error) {
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
                            }
                      });
                    }
                  },
                  child: Text(tLogin.toUpperCase()),
                ),
              ),
            ],
          ),
        )
    );
  }
}