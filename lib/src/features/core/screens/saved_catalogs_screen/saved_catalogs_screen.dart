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
    _load();
    return Scaffold(
      body: SafeArea(
          child: catalogsNames.isNotEmpty
              ? ListView.builder(
              itemCount: catalogsNames.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _getName(catalogsNames[position]),
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReadCatalog(nameCatalog: catalogsNames[position])),
                          );
                        },
                        trailing: GestureDetector(
                          onTap: (){
                            _delete(catalogsNames[position]);
                            setState(() {
                            });
                          },
                          child: const Icon(
                              Icons.bookmark,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
              : const Center(
            child: Text('No hay catálogos aún.'),
          )),
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
