import 'dart:io';

import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/constants/text_strings.dart';
import 'package:catalogo_app/src/features/core/models/items_model.dart';
import 'package:catalogo_app/src/features/core/screens/my_catalogs_screen/widgets/categories_drop_down_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo_app/src/features/core/models/dashboard/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:catalogo_app/src/features/core/screens/my_catalogs_screen/qr.dart';

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
  File? image;
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  late TextEditingController _itemNameEditController = TextEditingController();
  late TextEditingController _itemPriceEditController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();

  late String _catalogName = "";
  var uuid = const Uuid();

  /* category  */
  var setDefaultCategory = true;
  var categoryDefault;
  var categoryUid;

  @override
  Widget build(BuildContext context) {
    _catalogName = widget.name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        title: Text(_catalogName),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRPage(catalog: _catalogName, uuid: user.uid.toString(),))
              )
            },
            icon: Icon(Icons.qr_code),
          ),
        ],
      ),
      body:StatefulBuilder(
          builder: (context, setState) {
            return StreamBuilder(
              stream: firestore.collection('catalogs').doc(user.uid).collection('MyCatalogs').doc(_catalogName).collection('Categories').snapshots(),
              builder: ((context, snapshotCategory) {
                if (!snapshotCategory.hasData) {
                  return const SizedBox(
                    child: Center(
                        child:
                        Text("Tu catálogo se encuentra vació, comienza creando una categoría")),
                  );
                }

                if (setDefaultCategory) {
                  categoryDefault = snapshotCategory.data!.docs[0].get('name');
                  categoryUid = snapshotCategory.data!.docs[0].get('id');
                  setDefaultCategory = false;
                  debugPrint('Set default category: $categoryDefault');
                }

                return StreamBuilder(
                    stream: firestore.collection('catalogs').doc(user.uid).collection('MyCatalogs').doc(_catalogName).collection('Items').where("category", isEqualTo: "$categoryUid").snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshotCategory.hasData) {
                        return const SizedBox(
                          child: Center(
                              child:
                              Text("Tu catálogo se encuentra vació, comienza creando una categoría")),
                        );
                      } else {
                        print("Si hay datos ${snapshotCategory.data!.docs.length}");

                        if (setDefaultCategory) {
                          categoryDefault = snapshotCategory.data!.docs[0].get('name');
                          categoryUid = snapshotCategory.data!.docs[0].get('id');
                          debugPrint('Set default category: $categoryDefault');
                          setDefaultCategory = false;

                        }

                        if (snapshot.data == null) {
                          return const SizedBox();
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return const SizedBox(
                            child: Center(
                                child:
                                Text("Tu catálogo se encuentra vació, comienza agregando items")),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const SizedBox(
                            child: Center(
                                child:
                                Text("Tu catálogo se encuentra vació, comienza agregando un item")),
                          );
                        }

                        List<ItemModel> items = [];

                        for (var doc in snapshot.data!.docs) {
                          final item =
                          ItemModel.fromJson(doc.data() as Map<String, dynamic>);
                          items.add(item);
                          print(doc.data());
                        }

                        // Create list here
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                  height:50,
                                  child: ListView.builder(
                                    itemCount: snapshotCategory.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, position) {
                                      return Card(
                                        color: tSecondaryColor,
                                        elevation: 2,
                                        margin: const EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        child: InkWell(
                                          splashColor: tSecondaryColor,
                                          onTap: () {
                                            setState(() {
                                              print("CAMBIANDO DE CATEGORIA A ${snapshotCategory.data!.docs[position]['id']}");
                                              categoryUid = snapshotCategory.data!.docs[position]['id'];
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text('${snapshotCategory.data!.docs[position]['name']}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold

                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: tLightPrimaryColor,
                                    elevation: 1,
                                    margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0)),
                                    child: InkWell(
                                      splashColor: tAccentColor,
                                      onTap: () => _dialogBuilderEdit(context, items[index]),
                                      child: Row(
                                        textDirection: TextDirection.ltr,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 0,
                                            child: CachedNetworkImage(
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              placeholder: (context, url) => const CircularProgressIndicator(),
                                              imageUrl: items[index].photoURL,
                                              height: 110,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 20),

                                          Expanded(
                                            child: Text(
                                              items[index].name,
                                              style: Theme.of(context).textTheme.headline5,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 5),
                                            child: Text(
                                              "\$${items[index].price}",
                                              style: Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    })
                );
              }),
            );
          }
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: tPrimaryColor,
        spaceBetweenChildren: 10,
        spacing: 12,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Agregar artículo',
            backgroundColor: tAccentColor,
            onTap: () {
              _dialogBuilder(context);
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            label: 'Crear categoría',
            backgroundColor: Colors.green,
            onTap: () {
              _dialogCategoryBuilder(context);
            }
          ),SpeedDialChild(
            child: const Icon(Icons.category_outlined),
            label: 'Modificar categoría',
            backgroundColor: Colors.red,
            onTap: () {}
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        String photoUrl = tProfileImage;

        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  children: const [
                    Text("Agregar artículo"),
                  ],
                ),
                content: Stack(
                  children: <Widget>[

                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                                width: 200,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: image != null ? Image.file(image!) : FlutterLogo(),
                                )
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 125,
                                  height: 45,
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          // Change your radius here
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                    label: const Text('Subir imagen'),
                                    icon: const Icon(Icons.image, size: 18,),
                                    onPressed: () async {
                                      ImagePicker imagePickerGallery = ImagePicker();

                                      final file = await imagePickerGallery.pickImage(source: ImageSource.gallery);
                                      if (file == null) return;
                                      final imageTemporary = File(file.path);

                                      setState(() {
                                        image = imageTemporary;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 45,
                                  width: 125,
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          // Change your radius here
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    label: const Text('Tomar foto'),
                                    icon: const Icon(Icons.camera, size: 18,),
                                    onPressed: () async {
                                      ImagePicker imagePickerGallery = ImagePicker();
                                      final file = await imagePickerGallery.pickImage(source: ImageSource.camera);

                                      setState(() {
                                        print('${file?.path}');
                                        image = file as File?;
                                        photoUrl = image!.path;
                                      });

                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return tValidationMessage;
                                }
                              },
                              controller: _itemNameController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                  label: Text("Nombre del artículo"),
                                  prefixIcon: Icon(Icons.article)),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return tValidationMessage;
                                }
                              },
                              controller: _itemPriceController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                  label: Text("Precio"),
                                  prefixIcon: Icon(Icons.price_change)),
                            ),
                            const DropdownButtonApp(),
                          ],
                        ),
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
                      print("Guardando artículo");
                      _add();
                      _itemNameController.clear();
                      _itemPriceController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Future<void> _dialogBuilderEdit(BuildContext context, ItemModel aux) {
    _itemNameEditController.text = aux.name;
    _itemPriceEditController.text = aux.price;
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
                _edit(aux.id);
                _itemNameEditController.clear();
                _itemPriceEditController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogCategoryBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear nueva categoría'),
          content: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return tValidationMessage;
              }
            },
            controller: _categoryNameController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                label: Text("Nombre de la categoría"),
                prefixIcon: Icon(Icons.category_outlined)),
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
                _addCategory();
                _categoryNameController.clear();
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
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImagesProfile = referenceRoot.child('images-catalog');

    try {
      String name = _itemNameController.text;
      String price = _itemPriceController.text;
      final userCollection = FirebaseFirestore.instance.collection("catalogs/${user.uid}/MyCatalogs/$_catalogName/Items");
      final docRef = userCollection.doc(uuid.v1());
      Reference referenceImageToUpload = referenceDirImagesProfile.child(user.uid).child(_catalogName).child(docRef.id);
      await referenceImageToUpload.putFile(File(image!.path));
      String url = await referenceImageToUpload.getDownloadURL();
      print("NOMBRE: $name");
      print("PRECIO: $price");
      await docRef.set({
        "id" : docRef.id.toString(),
        "name": name,
        "price": price,
        "type": "default",
        "imageUrl": url,
      });

      image = null;

    } catch (e) {

    }

  }

  Future _edit(String id) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImagesProfile = referenceRoot.child('images-catalog');

    Reference referenceImageToUpload = referenceDirImagesProfile.child(user.uid).child(_catalogName);

    try {
      await referenceImageToUpload.putFile(File(image!.path));
      String url = await referenceImageToUpload.getDownloadURL();

      final userCollection = FirebaseFirestore.instance.collection("catalogs/$_uid/MyCatalogs/$_catalogName/Items");
      final docRef = userCollection.doc(id);
      await docRef.set({
        "id": docRef.id,
        "name": _itemNameEditController.text,
        "price": _itemPriceEditController.text,
        "type": "default",
        "imageUrl": url,
      });
    } catch (e) {

    }

    /* CATEGORY PART */



  }

  Future _addCategory() async {
    try {
      String categoryName = _categoryNameController.text;
      final categoryCollection =  FirebaseFirestore.instance.collection("catalogs/${user.uid}/MyCatalogs/$_catalogName/Categories");
      final docRef = categoryCollection.doc();
      print('$categoryName');
      await docRef.set({
        "name" : categoryName
      });
    } catch (e) {

    }
  }
}
