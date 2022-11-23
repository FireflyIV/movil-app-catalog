import 'package:flutter/material.dart';
import 'package:catalogo_app/src/constants/image_strings.dart';

class DashboardTopCoursesModel{
  final String title;
  final String heading;
  final String subHeading;
  final String image;
  final VoidCallback? onPress;

  DashboardTopCoursesModel(this.title, this.heading, this.subHeading, this.image, this.onPress);

  static List<DashboardTopCoursesModel> list = [
    DashboardTopCoursesModel("Mi fondita", "12 artículos", "Restaurante familiar", tSplashImage, null),
    DashboardTopCoursesModel("La michoacana", "23 artículos", "Restaurante familiar", tSplashImage, null),
    DashboardTopCoursesModel("Ropa y novedades Julia", "36 artículos", "Venta de ropa", tSplashImage, null),
  ];
}