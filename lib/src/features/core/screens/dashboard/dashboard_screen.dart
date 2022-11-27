import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/features/core/controllers/dashboard_controller.dart';
import 'package:catalogo_app/src/features/core/screens/my_catalogs_screen/my_catalogs_screen.dart';
import 'package:catalogo_app/src/features/core/screens/read_catalog/read_catalog.dart';
import 'package:catalogo_app/src/features/core/screens/saved_catalogs_screen/saved_catalogs_screen.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/banners.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/search.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/top_courses.dart';
import 'package:get/get.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark; //Dark mode

    return GetBuilder<DashboardController>(
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              appBar: DashboardAppBar(isDark: isDark,),
              body:  IndexedStack(
                index: controller.tabIndex,
                children: const [
                  SavedCatalogsScreen(),
                  ReadCatalogScreen(),
                  MyCatalogsScreen()
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(

                backgroundColor: tPrimaryColor,
                unselectedItemColor: Colors.white38,
                selectedItemColor: tWhiteColor,
                onTap: controller.changeTabIndex,
                currentIndex: controller.tabIndex,
                items: [
                  _bottomNavigationBarItem(Icons.save, "Guardados"),
                  _bottomNavigationBarItem(Icons.qr_code, "Leer Catálogo"),
                  _bottomNavigationBarItem(Icons.library_books, "Mis Catálogos"),
                ],),
            ),
          );
        }
    );
  }

  _bottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
        icon: Icon(icon),
        label: label);
  }
}






