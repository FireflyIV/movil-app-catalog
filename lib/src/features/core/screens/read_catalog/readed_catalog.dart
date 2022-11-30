import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo_app/src/common_widgets/custom_snack_bar/custom_good_snack_bar.dart';
import 'package:catalogo_app/src/constants/colors.dart';
import 'package:catalogo_app/src/features/core/screens/saved_catalogs_screen/saved_catalogs_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_app/src/features/core/models/items_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ReadCatalog extends StatefulWidget {
  final String nameCatalog;
  final bool isSaved;
  const ReadCatalog({Key? key, required this.nameCatalog, required this.isSaved}) : super(key: key);

  @override
  State<ReadCatalog> createState() => _ReadCatalogState();
}

class _ReadCatalogState extends State<ReadCatalog> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var uuid = const Uuid();
  String r = "";


  /* category  */
  var setDefaultCategory = true;
  var categoryDefault = "";
  var categoryUid = "";

  @override
  Widget build(BuildContext context) {
    String _catalogName = widget.nameCatalog;
    bool isSaved = widget.isSaved;
    final ruta = _catalogName.split('/');
    r = _catalogName;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        title: Text(ruta[3], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        actions: <Widget>[
          IconButton(
            onPressed: ()  {
              if (isSaved) {
                print("Guardando catalogo");
                _add();
                isSaved = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomGoodSnackBar(
                      message: "Catálogo agregado correctamente",
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              } else {
                print("Eliminando catalogo");
                _delete();
                isSaved = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomGoodSnackBar(
                      message: "Catálogo eliminado correctamente",
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              }
              /*setState(() {
                isSaved = !isSaved;
              });*/
            },
            icon: isSaved ? const Icon(Icons.bookmark_border) : const Icon(Icons.bookmark),
          ),
        ],
      ),
      body:StatefulBuilder(
          builder: (context, setState) {
            return StreamBuilder(
              stream: firestore.collection('catalogs').doc(ruta[1]).collection('MyCatalogs').doc(ruta[3]).collection('Categories').snapshots(),
              builder: ((context, snapshotCategory) {

                if (!snapshotCategory.hasData) {
                  print("NO HAY DATOS DISPONIBLES");
                  return const SizedBox(
                    child: Center(
                        child:
                        Text("Vacio")),
                  );
                }

                if (snapshotCategory.data!.docs.isEmpty) {
                  return const SizedBox(
                    child: Center(
                        child:
                        Text("Tu catálogo se encuentra vacio\n Comienza creando una categoría",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  );
                }

                if (setDefaultCategory) {
                  print("MyCatalog::SetDefaultCategory");
                  categoryDefault = snapshotCategory.data!.docs[0].get('name');
                  categoryUid = snapshotCategory.data!.docs[0].get('id');
                  setDefaultCategory = false;
                  debugPrint('Set default category: $categoryDefault');
                }

                return StreamBuilder(
                    stream: firestore.collection('catalogs').doc(ruta[1]).collection('MyCatalogs').doc(ruta[3]).collection('Items').where("category", isEqualTo: categoryUid).snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Categories collection is not empty
                      print("Si hay categorías ${snapshotCategory.data!.docs.length}");

                      if (snapshot.data == null) {
                        return const SizedBox();
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        print('ARTICULOS: ${snapshot.data!.docs.length}');
                        return const SizedBox(
                          child: Center(
                              child:
                              Text("Tu catálogo se encuentra vacio\n ¡Agrega un artículo!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                          ),
                        );
                      }
                      // There are some data in item document
                      List<ItemModel> items = [];

                      for (var doc in snapshot.data!.docs) {
                        final item =
                        ItemModel.fromJson(doc.data() as Map<String, dynamic>);
                        items.add(item);
                        print(doc.data());
                      }

                      // Create list here
                      return Container(
                        decoration: const BoxDecoration(
                            color: tLightPrimaryColor
                        ),
                        child: Column(
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
                                    color: tLightPrimaryColor2,
                                    elevation: 2,
                                    margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0)),
                                    child: InkWell(
                                      splashColor: tAccentColor,
                                      onTap: () {},
                                      child: Row(
                                        textDirection: TextDirection.ltr,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 0,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10)),
                                              child: CachedNetworkImage(
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                imageUrl: items[index].photoURL,
                                                height: 110,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
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
                        ),
                      );
                      return const SizedBox();
                    })
                );
              }),
            );
          }
      ),
    );

  }

  Future _add() async {
    final userCollection = FirebaseFirestore.instance.collection("catalogs/${user.uid}/SavedCatalogs/");
    final docRef = userCollection.doc(uuid.v1());
    await docRef.set({
      "ruta": r,
      "id": docRef.id,
    });
  }

  Future _delete() async {
    FirebaseFirestore.instance
        .collection("catalogs/${user.uid}/SavedCatalogs/")
        .get()
        .then((value) => value.docs.forEach((element) {
              Map<String, dynamic> res = element.data();
              if (res['ruta'] == r) {
                final ref = FirebaseFirestore.instance
                    .collection("catalogs/${user.uid}/SavedCatalogs/");
                ref.doc(res['id']).delete();
              }
            }));
  }
}
