// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:client/src/models/image_model.dart';
import 'package:client/src/models/user_model.dart';
import 'package:client/src/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProductHelper {
  // ! Get products
  static Future getProducts() async {
    final response = jsonDecode(
        await http.get(Uri.parse("$BASE_URL/")).then((value) => value.body));

    return response;
  }

  // ! Get products by category
  static Future getProductsByCategory(int categoryId) async {
    final response = jsonDecode(await http
        .get(
          Uri.parse("$BASE_URL/products/category/$categoryId"),
        )
        .then((value) => value.body));

    return response;
  }

  // ! Get a product
  static Future getProduct(int id) async {
    final response = jsonDecode(await http
        .get(
          Uri.parse("$BASE_URL/products/$id"),
        )
        .then((value) => value.body));

    return response;
  }

  // ! Upload image
  static Future<Map<String, dynamic>> uploadImage(File image) async {
    final uri = Uri.parse("$BASE_URL/upload-product-image");
    final request = http.MultipartRequest("POST", uri);

    final multipartFile = await http.MultipartFile.fromPath(
      "product-image",
      image.path,
      filename: basename(image.path),
    );

    request.files.add(multipartFile);

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    return jsonDecode(response.body);
  }

  // ! Upload product
  static Future uploadProduct(
    File image, {
    required UserModel user,
    required String name,
    required int quantity,
    required int categoryId,
  }) async {
    final uploadResponse = await uploadImage(image);

    if (uploadResponse["status"] != "SUCCESS") {
      return null;
    }

    final uploadedImage = ImageModel.fromMap(uploadResponse["body"]);

    final response = jsonDecode(
      await http.post(
        Uri.parse("$BASE_URL/products/create"),
        body: {
          "name": name.toString(),
          "qty": quantity.toString(),
          "image": uploadedImage.path.toString(),
          "categoryId": categoryId.toString(),
          "createdBy": user.id.toString(),
          "updatedBy": user.id.toString(),
        },
      ).then((value) => value.body),
    );

    return response;
  }

  // ! Update product
  static Future updateProduct({
    required UserModel user,
    required int id,
    required String name,
    required int quantity,
    required int categoryId,
  }) async {
    final response = jsonDecode(
      await http.put(
        Uri.parse("$BASE_URL/products/$id"),
        body: {
          "name": name.toString(),
          "qty": quantity.toString(),
          "categoryId": categoryId.toString(),
          "updatedBy": user.id.toString(),
        },
      ).then((value) => value.body),
    );

    return response;
  }

  // ! Delete image
  static Future deleteImage(String path) async {
    final response = jsonDecode(await http.delete(
      Uri.parse("$BASE_URL/delete-image"),
      body: {"path": path},
    ).then((value) => value.body));

    return response;
  }

  // ! Delete product
  static Future deleteProduct({
    required int id,
    required String imageUrl,
  }) async {
    final deleteImageResponse = await deleteImage(imageUrl);

    if (deleteImageResponse["status"] != "SUCCESS") {
      return null;
    }

    final response = jsonDecode(await http
        .delete(
          Uri.parse("$BASE_URL/products/delete/$id"),
        )
        .then((value) => value.body));

    return response;
  }
}
