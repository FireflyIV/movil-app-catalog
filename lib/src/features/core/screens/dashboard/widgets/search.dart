import 'package:flutter/material.dart';
import '../../../../../constants/text_strings.dart';

class DashboardSearchBox extends StatelessWidget {
  const DashboardSearchBox({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(left: BorderSide(width: 4))),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tDashboardSearch, style: txtTheme.headline2?.apply(color: Colors.grey.withOpacity(0.5))),
          const Icon(Icons.search, size: 25),
        ],
      ),
    );
  }
}
