import 'package:catalogo_app/src/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../read_catalog/readed_catalog.dart';

class SavedCatalogsScreen extends StatefulWidget {
  const SavedCatalogsScreen({Key? key}) : super(key: key);

  @override
  State<SavedCatalogsScreen> createState() => _SavedCatalogsScreenState();
}

class _SavedCatalogsScreenState extends State<SavedCatalogsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> catalogsNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firestore.collection("catalogs/${user.uid}/SavedCatalogs").snapshots(),
          builder: ((context, snapshot) {

            // Verifications
            if (!snapshot.hasData) {
              print("NO HAY DATOS DISPONIBLES");
              return const SizedBox(
                child: Center(
                    child:
                    Text("Vacio")),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Container(
                decoration: const BoxDecoration(
                    color: tLightPrimaryColor
                ),
                child: const Center(
                  child:
                  Text(
                    "Aún no has guardado un catálogo\n ¡Scanea un QR para agregarlo!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            // Information
            _load();
            return Container(
                decoration: const BoxDecoration(
                    color: tLightPrimaryColor
                ),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: tCardBgColor,
                        elevation: 17,
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: InkWell(
                          splashColor: tSecondaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReadCatalog(nameCatalog: snapshot.data!.docs[index]["ruta"], isSaved: false)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              _getName(catalogsNames[index]),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      );
                    }
                )
            );
          })
      ),
    );
  }

  _load(){
    firestore.collection("catalogs/${user.uid}/SavedCatalogs").get().then(
          (value) {
        value.docs.forEach((doc) {
          Map<String, dynamic> res = doc.data();
          if (catalogsNames.isNotEmpty){
            if(!catalogsNames.contains(res['ruta'])){
              setState(() {
                catalogsNames.add(res['ruta']);
                catalogsNames.sort();
              });
            }
          } else {
            setState(() {
              catalogsNames.add(res['ruta']);
              catalogsNames.sort();
            });
          }
        });
      },
    );
  }

  Future _delete(String ruta) async {
    await FirebaseFirestore.instance
        .collection("catalogs/${user.uid}/SavedCatalogs/")
        .get()
        .then((value) => value.docs.forEach((element) {
      Map<String, dynamic> res = element.data();
      if (res['ruta'] == ruta){
        final ref = FirebaseFirestore.instance
            .collection("catalogs/${user.uid}/SavedCatalogs/");
        ref.doc(res['id']).delete();
        catalogsNames.remove(ruta);
      }
    }));
  }
  
  String _getName(String ruta){
    var res = ruta.split('/');
    return res[3];
  }
}
