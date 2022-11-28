import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo_app/src/features/core/models/dashboard/item.dart';

class Catalog extends StatefulWidget {
  final String name;

  const Catalog({Key? key, required this.name}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  List<Item> items = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SafeArea(
          child: items.isNotEmpty
              ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int position){
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                      Expanded(
                        flex: 0,
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          imageUrl: 'https://picsum.photos/250?image=9',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          items[position].name ?? "",
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
                          "\$${items[position].price ?? ""}",
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
                );
              }
          )
              : const Center(
                  child: Text('No hay items aún.'),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogBuilder(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
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
                      Divider(),
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
                  //_load();
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

  _add(){
    Item aux = Item(name: _itemNameController.text, price: _itemPriceController.text, type: "uno", imageUrl: "uno");
    setState(() {
      items.add(aux);
    });
  }
}
