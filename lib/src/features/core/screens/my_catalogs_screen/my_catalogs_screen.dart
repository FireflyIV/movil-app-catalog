import 'package:catalogo_app/src/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catalogo_app/src/features/core/screens/my_catalogs_screen/catalog.dart';

class MyCatalogsScreen extends StatefulWidget {
  const MyCatalogsScreen({Key? key}) : super(key: key);

  @override
  State<MyCatalogsScreen> createState() => _MyCatalogsScreenState();
}

class _MyCatalogsScreenState extends State<MyCatalogsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _catalogNameController = TextEditingController();
  List<String> catalogsNames = [];

  // DB


  @override
  void dispose() {
    _catalogNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: StreamBuilder(
            stream: firestore.collection("catalogs/${user.uid}/MyCatalogs").snapshots(),
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
                          "Aún no has creado un catálogo\n ¡Comienza creando uno!",
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
                              MaterialPageRoute(builder: (context) => Catalog(name: snapshot.data!.docs[index].id)),
                            );
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                snapshot.data!.docs[index].id,
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

        floatingActionButton: FloatingActionButton(
          onPressed: () => _dialogBuilder(context),
          backgroundColor: tAccentColor,
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
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                label: Text("Nombre del catálogo"),
                prefixIcon: Icon(Icons.book)),
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
                _catalogNameController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future _add() async{
    final userCollection = FirebaseFirestore.instance.collection("catalogs/${user.uid}/MyCatalogs");
    final docRef = userCollection.doc(_catalogNameController.text);
    await docRef.set({});
  }
}
