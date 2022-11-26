
class UserModel {
  String id;
  final String name;
  final String email;
  final String photoURL;

  UserModel(this.id, this.name, this.email, this.photoURL);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoURL': photoURL
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      json['id'],
      json['fullName'],
      json['email'],
      json['photoURL'])
  ;


}