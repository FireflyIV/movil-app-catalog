import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSnackBar extends StatelessWidget {
  CustomSnackBar({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Error:",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(errorMessage,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: SvgPicture.asset(
              "assets/error_messages/bubbles.svg",
              height: 48,
              width: 40,
              color: Colors.redAccent,
            ),
          ),
        ),
        /*Positioned(
          top: -20,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                "assets/error_messages/back.svg",
                height: 40,
              ),
              Positioned(
                top: 10,

                child: SvgPicture.asset(
                  "assets/error_messages/failure.svg",
                  height: 16,
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }
}
