import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_app/src/features/core/models/items_model.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ReadCatalog extends StatefulWidget {
  final String nameCatalog;

  ReadCatalog({Key? key, required this.nameCatalog}) : super(key: key);

  @override
  State<ReadCatalog> createState() => _ReadCatalogState();
}

class _ReadCatalogState extends State<ReadCatalog> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var uuid = const Uuid();
  String r = "";
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    String _catalogName = widget.nameCatalog;
    final ruta = _catalogName.split('/');
    r = _catalogName;
    return Scaffold(
      appBar: AppBar(
        title: Text(ruta[3]),
        actions: [
          IconButton(
            onPressed: () {
              if (isSaved) {
                _delete();
              } else {
                _add();
              }
              setState(() {
                isSaved = !isSaved;
              });
            },
            icon: !isSaved ? Icon(Icons.bookmark_border) : Icon(Icons.bookmark),
          )
        ],
      ),
      body: StreamBuilder(
          stream: firestore
              .collection('catalogs')
              .doc(ruta[1])
              .collection('MyCatalogs')
              .doc(ruta[3])
              .collection('Items')
              .snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              return const SizedBox();
            }

            if (snapshot.data!.docs.isEmpty) {
              return SizedBox(
                child: Center(child: Text("No hay items registrados.")),
              );
            }

            if (snapshot.hasData) {
              List<ItemModel> items = [];

              for (var doc in snapshot.data!.docs) {
                final item = ItemModel.fromJson(doc.data() as Map<String, dynamic>);
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
                      onTap: () {},
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              imageUrl: items[index].photoURL,
                              height: 100,
                              width: 100,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              items[index].name,
                              style: const TextStyle(
                                fontSize: 20,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 0,
                            child: Text(
                              "\$${items[index].price}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          })),
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
