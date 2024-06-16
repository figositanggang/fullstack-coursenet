class UserModel {
  final int id;
  final String username;
  final String password;
  final String image;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      username: map["username"],
      password: map["password"],
      image: map["image"],
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "image": image,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
