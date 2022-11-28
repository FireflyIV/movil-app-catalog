import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catalogo_app/src/features/core/screens/my_catalogs_screen/catalog.dart';

class MyCatalogsScreen extends StatefulWidget {
  const MyCatalogsScreen({Key? key}) : super(key: key);

  @override
  State<MyCatalogsScreen> createState() => _MyCatalogsScreenState();
}

class _MyCatalogsScreenState extends State<MyCatalogsScreen> {
  final String _uid = "001";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _catalogNameController = TextEditingController();
  List<String> catalogsNames = [];

  @override
  void dispose() {
    _catalogNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _load();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogos'),
      ),
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
                        title: Text(catalogsNames[position]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Catalog(name: catalogsNames[position])),
                          );
                        },
                      )
                    ],
                  ),
                );
              })
              : const Center(
            child: Text('No hay catálogos aún.'),
          )),
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
          title: const Text('Crear nuevo catálogo'),
          content: TextFormField(
            controller: _catalogNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Platillos de mi restaurante',
            ),
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
                _catalogNameController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _load(){
    firestore.collection("catalogs/$_uid/MyCatalogs").get().then(
          (value) {
        value.docs.forEach((doc) {
          if (catalogsNames.isNotEmpty){
            if(!catalogsNames.contains(doc.id)){
              setState(() {
                catalogsNames.add(doc.id);
                catalogsNames.sort();
              });
            }
          } else {
            setState(() {
              catalogsNames.add(doc.id);
              catalogsNames.sort();
            });
          }
        });
      },
    );
  }

  Future _add() async{
    final userCollection = FirebaseFirestore.instance.collection("catalogs/$_uid/MyCatalogs");
    final docRef = userCollection.doc(_catalogNameController.text);
    await docRef.set({});
  }
}
