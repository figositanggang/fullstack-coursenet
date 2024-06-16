import 'package:client/src/pages/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

late Database database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = await openDatabase(
    join(await getDatabasesPath(), "user_database.db"),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT, image TEXT, createdAt TEXT, updatedAt TEXT)",
      );
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEEBC00),
          primary: const Color(0xFFEEBC00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AuthState(),
    );
  }
}
