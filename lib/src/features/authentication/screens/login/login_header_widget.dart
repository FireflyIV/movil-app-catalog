import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: const AssetImage(tWelcomeStringImage),
          height: size.height * 0.2,),
        Text(tLoginTitle, style: Theme.of(context).textTheme.headline1),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}