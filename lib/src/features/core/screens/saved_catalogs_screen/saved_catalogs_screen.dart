
import 'package:catalogo_app/src/features/core/controllers/saved_catalogs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedCatalogsScreen extends GetView<SavedCatalogsController>{
  const SavedCatalogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: Text("Saved Catalogs", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}