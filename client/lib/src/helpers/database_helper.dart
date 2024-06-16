import 'package:client/main.dart';
import 'package:client/src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // ! Get User
  static Future<UserModel?> getUser() async {
    try {
      final response = await database.query("users");

      return UserModel.fromMap(response.first);
    } catch (e) {
      return null;
    }
  }

  // ! Insert User
  static Future insertUser(UserModel userModel) async {
    try {
      await database.insert(
        "users",
        conflictAlgorithm: ConflictAlgorithm.replace,
        UserModel(
          id: userModel.id,
          username: userModel.username,
          password: userModel.password,
          image: userModel.image,
          createdAt: userModel.createdAt,
          updatedAt: userModel.updatedAt,
        ).toMap(),
      );

      print("USER INSERTED SUCCESSFULLY");
    } catch (e) {
      print("FAILED INSERT USER: $e");
    }
  }

  // ! Update User
  static Future updateUser(UserModel userModel) async {
    try {
      await database.update(
        "users",
        UserModel(
          id: userModel.id,
          username: userModel.username,
          password: userModel.password,
          image: userModel.image,
          createdAt: userModel.createdAt,
          updatedAt: userModel.updatedAt,
        ).toMap(),
        where: "id = ?",
        whereArgs: [userModel.id],
      );

      print("USER UPDATED SUCCESSFULLY");
    } catch (e) {
      print("ERROR UPDATING USER: $e");
    }
  }

  // ! Delete User
  static Future deleteUser(int id) async {
    try {
      await database.delete(
        "users",
        where: "id = ?",
        whereArgs: [id],
      );

      print("USER DELETED SUCCESSFULLY");
    } catch (e) {
      print("ERROR DELETING USER: $e");
    }
  }
}
