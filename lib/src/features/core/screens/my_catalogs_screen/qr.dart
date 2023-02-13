import 'dart:io';
import 'package:catalogo_app/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';

class QRPage extends StatefulWidget {
  final String catalog;
  final String uuid;
  const QRPage({Key? key, required this.catalog, required this.uuid}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String id = widget.uuid;
    String catalog = widget.catalog;
    String ruta = "catalogs/$id/MyCatalogs/$catalog/Items";
    return Scaffold(
      appBar: AppBar(

        title: const Text('Compartir QR'),
        backgroundColor: tPrimaryColor,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  color: tLightPrimaryColor
              ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: RepaintBoundary(
              key: _globalKey,
              child: QrImage(
                backgroundColor: Colors.white,
                data: ruta,
                version: QrVersions.auto,
                size: 400,
                gapless: false,
              ),
            )
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              width: 200,
              child: TextButton(
                onPressed: () {
                  _capturePng();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePng() async {
    final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage();
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData?.buffer.asUint8List();

    if (imageBytes != null) {
      const directory = "/storage/emulated/0/Download/";
      print(directory);
      final imagePath = await File('${directory}/container_image.png').create();
      await imagePath.writeAsBytes(imageBytes);
    }
  }
}
