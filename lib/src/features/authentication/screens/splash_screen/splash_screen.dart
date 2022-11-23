import 'package:catalogo_app/src/common_widgets/fade_in_animation/animation_design.dart';
import 'package:catalogo_app/src/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/common_widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startSplashAnimation();

    return Scaffold(
      body: Stack(
       children: [
         TFadeInAnimation(
             durationInMs: 1600,
             animate: TAnimatePosition(
               topAfter: 0, topBefore: -30, leftBefore: -30, leftAfter: 0,
             ),
             child: const Image(image: AssetImage(tSplashTopIcon), height: 70,),
         ),
         TFadeInAnimation(
             durationInMs: 1600,
           animate: TAnimatePosition(
             topBefore: 110, topAfter: 110, leftAfter: tDefaultSize, leftBefore: -150
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(tAppName, style: Theme.of(context).textTheme.headline3),
               Text(tAppTagLine, style: Theme.of(context).textTheme.headline2)
             ],
           ),
         ),
         TFadeInAnimation(
           durationInMs: 2400,
           animate: TAnimatePosition(
               bottomBefore: 0, bottomAfter: 120, leftBefore : 30, leftAfter: 30
           ),
           child: const Image(image: AssetImage(tSplashImage))
         ),
         TFadeInAnimation(
           durationInMs: 2400,
           animate: TAnimatePosition(
               bottomBefore: -20, bottomAfter: 40, rightAfter: tDefaultSize, rightBefore: tDefaultSize
           ),
           child: Container(
             width: tSplashContainerSize,
             height: tSplashContainerSize,
             decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: tPrimaryColor,
             ),
           ),
         ),
       ],
     ),
    );
  }
}

