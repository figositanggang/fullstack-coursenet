class ProductModel {
  final int id;
  final String name;
  final int quantity;
  final int categoryId;
  final String image;
  final String createdAt;
  final String updatedAt;
  final int createdBy;
  final int updatedBy;

  ProductModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.categoryId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"],
      name: map["name"],
      quantity: map["qty"],
      categoryId: map["categoryId"],
      image: map["image"].replaceAll("uploads/", ""),
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
      createdBy: map["createdBy"],
      updatedBy: map["updatedBy"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "qty": quantity,
      "categoryId": categoryId,
      "image": image,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
    };
  }
}
