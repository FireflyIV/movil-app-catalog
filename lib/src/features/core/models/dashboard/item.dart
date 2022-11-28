import 'package:cloud_firestore/cloud_firestore.dart';

class Item{
  final String? name;
  final String? type;
  final String? price;
  final String? imageUrl;

  Item({required this.name, required this.type, required this.price, required this.imageUrl});

  factory Item.fromSnapshot(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Item(
      name: snapshot['name'],
      type: snapshot['type'],
      price: snapshot['price'],
      imageUrl: snapshot['imageUrl'],
    );
  }

}