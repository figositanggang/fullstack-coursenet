import 'dart:convert';

import 'package:client/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class CategoryHelper {
  // ! Get categories
  static Future getCategories() async {
    final response = jsonDecode(await http
        .get(Uri.parse("$BASE_URL/categories"))
        .then((value) => value.body));

    return response;
  }

  // ! Get a category
  static Future getCategory(int id) async {
    final response = jsonDecode(await http
        .get(
          Uri.parse("$BASE_URL/categories/$id"),
        )
        .then((value) => value.body));

    return response;
  }
}
