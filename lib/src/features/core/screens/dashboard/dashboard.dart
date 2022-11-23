import 'package:flutter/material.dart';
import 'package:catalogo_app/src/constants/sizes.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/banners.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/categories.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/search.dart';
import 'package:catalogo_app/src/features/core/screens/dashboard/widgets/top_courses.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Variables
    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark; //Dark mode

    return SafeArea(
      child: Scaffold(
        appBar: DashboardAppBar(isDark: isDark,),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDashboardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Heading
                Text(tDashboardTitle, style: txtTheme.bodyText2),
                Text(tDashboardHeading, style: txtTheme.headline2),
                const SizedBox(height: tDashboardPadding),

                //Search Box
                DashboardSearchBox(txtTheme: txtTheme),
                const SizedBox(height: tDashboardPadding),

                //Top Course
                Text(tDashboardTopCourses, style: txtTheme.headline4?.apply(fontSizeFactor: 1.2)),
                DashboardTopCourses(txtTheme: txtTheme, isDark: isDark),

                //Categories
                //DashboardCategories(txtTheme: txtTheme),
                //const SizedBox(height: tDashboardPadding),

                //Banners
                const SizedBox(height: tDashboardPadding),
                DashboardBanners(txtTheme: txtTheme, isDark: isDark),
                const SizedBox(height: tDashboardPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






