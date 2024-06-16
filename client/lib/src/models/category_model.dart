class CategoryModel {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map["id"],
      name: map["name"],
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
