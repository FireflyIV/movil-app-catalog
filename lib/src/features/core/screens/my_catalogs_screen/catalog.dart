import 'package:catalogo_app/src/features/core/models/items_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo_app/src/features/core/models/dashboard/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Catalog extends StatefulWidget {
  final String name;

  const Catalog({Key? key, required this.name}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final user = FirebaseAuth.instance.currentUser!;
  String _uid = "";
  List<Item> items = [];
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  late TextEditingController _itemNameEditController = TextEditingController();
  late TextEditingController _itemPriceEditController = TextEditingController();
  late String _catalogName = "";
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    _catalogName = widget.name;
    _load();
    return Scaffold(
      appBar: AppBar(
        title: Text(_catalogName),
      ),
      body: StreamBuilder(
        stream: firestore.collection('catalogs').doc(user.uid).collection('MyCatalogs').doc(_catalogName).collection('Items').snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const SizedBox();
          }

          if (snapshot.data!.docs.isEmpty) {
            return SizedBox(
              child: Center(
                child:
                  Text("No hay catálogos registrados para${user.displayName}")),
            );
          }

          if (snapshot.hasData) {
            List<ItemModel> items = [];

            for (var doc in snapshot.data!.docs) {
              final item =
              ItemModel.fromJson(doc.data() as Map<String, dynamic>);
              items.add(item);
              print(doc.data());
            }

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    splashColor: Colors.deepPurple,
                    onTap: () => _dialogBuilderEdit(context, items[index]),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            imageUrl: items[index].photoURL ?? "",
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            items[index].name ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          flex: 0,
                          child: Text(
                            "\$${items[index].price ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 10,),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        })
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: () => _dialogBuilder(context),
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nuevo Item"),
          content: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextFormField(
                        controller: _itemNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nombre del Item.',
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextFormField(
                        controller: _itemPriceController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Precio del Item.',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Aceptar'),
              onPressed: () {
                _add();
                _load();
                _itemNameController.clear();
                _itemPriceController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilderEdit(BuildContext context, ItemModel aux) {
    _itemNameEditController.text = aux.name!;
    _itemPriceEditController.text = aux.price!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Item"),
          content: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextFormField(
                        controller: _itemNameEditController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nombre del Item.',
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextFormField(
                        controller: _itemPriceEditController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Precio del Item.',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Aceptar'),
              onPressed: () {
                _edit(aux.id ?? "");
                _itemNameController.clear();
                _itemPriceController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _load() async {
    _uid = user.uid.toString();
    await firestore
        .collection("catalogs/$_uid/MyCatalogs/$_catalogName/Items")
        .get()
        .then((value) => value.docs.forEach((element) {
      Map<String, dynamic> res = element.data();
      Item aux = Item(
          name: res['name'],
          price: res['price'],
          imageUrl: res['imageUrl'],
          type: res['type'],
          uuid: element.id);
      if (items.isNotEmpty) {
        if (items.every((element) => element.uuid != aux.uuid)) {
          setState(() {
            items.add(aux);
            items.sort((a, b) => a.name!.compareTo(b.name!));
          });
        }
      } else {
        setState(() {
          items.add(aux);
          items.sort((a, b) => a.name!.compareTo(b.name!));
        });
      }
    }));
  }

  Future _add() async {
    final userCollection = FirebaseFirestore.instance.collection("catalogs/$_uid/MyCatalogs/$_catalogName/Items");
    final docRef = userCollection.doc(uuid.v1());
    await docRef.set({
      "id" : docRef.id.toString(),
      "name": _itemNameController.text,
      "price": _itemPriceController.text,
      "type": "default",
      "imageUrl":
      "https://firebasestorage.googleapis.com/v0/b/catalogs-app-a65fa.appspot.com/o/llanta.png?alt=media&token=fdc7ff66-b54e-42d0-9a17-df79aa136eaf",
    });

  }

  Future _edit(String id) async {
    final userCollection = FirebaseFirestore.instance.collection("catalogs/$_uid/MyCatalogs/$_catalogName/Items");
    final docRef = userCollection.doc(id);
    await docRef.set({
      "id": docRef.id,
      "name": _itemNameEditController.text,
      "price": _itemPriceEditController.text,
      "type": "default",
      "imageUrl":
      "https://firebasestorage.googleapis.com/v0/b/catalogs-app-a65fa.appspot.com/o/llanta.png?alt=media&token=fdc7ff66-b54e-42d0-9a17-df79aa136eaf",
    });
  }

  _update() {
    items.clear();
    setState(() {
      _load();
    });
  }
}
