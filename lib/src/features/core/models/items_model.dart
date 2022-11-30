
class ItemModel {
  String id;
  final String name;
  final String price;
  final String photoURL;
  final String categoryID;

  ItemModel(this.id, this.name, this.price, this.photoURL, this.categoryID);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'photoURL': photoURL,
    'category' : categoryID
  };

  static ItemModel fromJson(Map<String, dynamic> json) => ItemModel(
      json['id'],
      json['name'],
      json['price'],
      json['imageUrl'],
      json['category'])
  ;
}