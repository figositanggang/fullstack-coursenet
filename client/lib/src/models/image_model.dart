class ImageModel {
  final String originalName;
  final String fileName;
  final String path;
  final num size;

  ImageModel({
    required this.originalName,
    required this.fileName,
    required this.path,
    required this.size,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      originalName: map["originalname"],
      fileName: map["filename"],
      path: map["path"],
      size: map["size"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "originalname": originalName,
      "filename": fileName,
      "path": path,
      "size": size,
    };
  }
}
