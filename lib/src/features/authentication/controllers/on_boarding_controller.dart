
import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/constants/image_strings.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/authentication/models/model_on_boarding.dart';
import 'package:catalogo_app/src/features/authentication/screens/on_boarding/on_boarding_page_widget.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(model : OnBoardingModel(
        image: tOnBoardingImage1,
        title: tOnBoardingTitle1,
        subTitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
        bgColor: tOnBoardingPageColor1,)
    ),

    OnBoardingPageWidget(model : OnBoardingModel(
        image: tOnBoardingImage2,
        title: tOnBoardingTitle2,
        subTitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
        bgColor: tOnBoardingPageColor2)
    ),

    OnBoardingPageWidget(model : OnBoardingModel(
        image: tOnBoardingImage3,
        title: tOnBoardingTitle3,
        subTitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
        bgColor: tOnBoardingPageColor3,)
    ),
  ];

  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;
  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
  skip() => controller.jumpToPage(page: 2);
}