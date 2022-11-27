import 'dart:io';

import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/authentication/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:catalogo_app/src/repositories/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PickImageScreen {

  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    String imageURL = "";
    final user = FirebaseAuth.instance.currentUser!;

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subir foto",
                style: Theme.of(context).textTheme.headline2),
            Text("Selecciona una de las opciones para subir la foto que deseas.",
                style: Theme.of(context).textTheme.bodyText2),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              onTap: () async {
                Navigator.pop(context);

                ImagePicker imagePickerGallery = ImagePicker();

                final file = await imagePickerGallery.pickImage(source: ImageSource.gallery);
                print('${file?.path}');

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImagesProfile = referenceRoot.child('images_profile');

                Reference referenceImageToUpload = referenceDirImagesProfile.child(user.uid);

                try {
                  await referenceImageToUpload.putFile(File(file!.path));
                  imageURL = await referenceImageToUpload.getDownloadURL();

                  UserRepository.instance.updatePhoto(imageURL);

                } catch (e) {

                }


              },
              title: tGallery,
              subTitle: tGalleryText,
              btnIcon: LineAwesomeIcons.image,
            ),
            const SizedBox(height: 20.0),
            ForgetPasswordBtnWidget(
              onTap: () async {
                Navigator.pop(context);

                ImagePicker imagePickerCamera = ImagePicker();
                XFile? file = await imagePickerCamera.pickImage(source: ImageSource.camera);
                print('${file?.path}');

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImagesProfile = referenceRoot.child('images_profile');

                Reference referenceImageToUpload = referenceDirImagesProfile.child(user.uid);

                try {
                  await referenceImageToUpload.putFile(File(file!.path));
                  imageURL = await referenceImageToUpload.getDownloadURL();
                } catch (e) {

                }

              },
              title: tCamera,
              subTitle: tCameraText,
              btnIcon: LineAwesomeIcons.camera,
            ),
          ],
        ),
      ),
    );
  }
}
