// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:client/src/controllers/user_controller.dart';
import 'package:client/src/helpers/database_helper.dart';
import 'package:client/src/helpers/token_helper.dart';
import 'package:client/src/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static Future getJWT() async {
    final token = await TokenHelper.getToken();
    final response =
        jsonDecode(await http.post(Uri.parse("$BASE_URL/token"), body: {
      "token": token,
    }).then((value) => value.body));

    if (response != null) {
      final user = await DatabaseHelper.getUser();

      final checkUser = await getUser(user!.id);

      if (checkUser['status'] == "SUCCESS") {
        final userGet = Get.put(UserController());
        userGet.setCurrentUser(user);
      }
    }

    return response;
  }

  static Future getUser(int id) async {
    final response = jsonDecode(await http
        .get(Uri.parse("$BASE_URL/users/$id"))
        .then((value) => value.body));

    return response;
  }

  // ! Login
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = jsonDecode(await http.post(
      Uri.parse("$BASE_URL/users/login"),
      body: {
        "username": username,
        "password": password,
      },
    ).then((value) => value.body));

    try {
      if (response["status"] == "SUCCESS") {
        await TokenHelper.setToken(response["body"]["token"]);
      }
    } catch (_) {
      print("ERROR LOGIN: $_");
    }

    return response;
  }

  // ! Register
  static Future regiser({
    required String username,
    required String password,
  }) async {
    final response = jsonDecode(await http.post(
      Uri.parse("$BASE_URL/users/register"),
      body: {
        "username": username,
        "password": password,
        "image": "",
      },
    ).then((value) => value.body));

    return response;
  }

  // ! Update user
  static Future<Map<String, dynamic>> updateUser({
    required int id,
    required String username,
    required String password,
    required String image,
  }) async {
    final response = jsonDecode(await http.put(
      Uri.parse("$BASE_URL/users/$id"),
      body: {
        "username": username,
        "password": password,
        "image": image,
      },
    ).then((value) => value.body));

    return response;
  }

  // ! Upload image
  static Future<Map<String, dynamic>> uploadImage(File image) async {
    final uri = Uri.parse("$BASE_URL/upload-profile-picture");
    final request = http.MultipartRequest("POST", uri);

    final multipartFile = await http.MultipartFile.fromPath(
      "profile-picture",
      image.path,
      filename: basename(image.path),
    );

    request.files.add(multipartFile);

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    return jsonDecode(response.body);
  }

  // ! Logout
  static Future<Map<String, dynamic>> logout() async {
    final response = await http.post(Uri.parse("$BASE_URL/users/logout"));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    return jsonDecode(response.body);
  }
}
