
class ItemModel {
  String id;
  final String name;
  final String price;
  final String photoURL;

  ItemModel(this.id, this.name, this.price, this.photoURL);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'photoURL': photoURL
  };

  static ItemModel fromJson(Map<String, dynamic> json) => ItemModel(
      json['id'],
      json['name'],
      json['price'],
      json['imageUrl'])
  ;
}