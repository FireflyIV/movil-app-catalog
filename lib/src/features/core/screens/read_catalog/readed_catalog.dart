import 'package:flutter/cupertino.dart';

class ReadCatalog extends StatefulWidget {
  final String nameCatalog;

   ReadCatalog({Key? key, required this.nameCatalog}) : super(key: key);

  @override
  State<ReadCatalog> createState() => _ReadCatalogState();
}

class _ReadCatalogState extends State<ReadCatalog> {
  @override
  Widget build(BuildContext context) {
    String _catalogName = widget.nameCatalog;
    return Center(
      child: Text(_catalogName),
    );
  }

}