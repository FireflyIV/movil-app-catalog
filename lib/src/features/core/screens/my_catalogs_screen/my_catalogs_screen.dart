
import 'package:catalogo_app/src/features/core/controllers/my_catalogs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCatalogsScreen extends GetView<MyCatalogsController>{
  const MyCatalogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("My Catalogs", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}