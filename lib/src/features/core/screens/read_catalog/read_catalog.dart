import 'package:catalogo_app/src/features/core/controllers/read_catalog_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadCatalogScreen extends GetView<ReadCatalogController> {
  const ReadCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Read Catalog Screen", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}