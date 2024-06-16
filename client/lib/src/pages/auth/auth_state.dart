import 'package:client/src/helpers/user_helper.dart';
import 'package:client/src/pages/home_page.dart';
import 'package:client/src/pages/auth/login_page.dart';
import 'package:client/src/utils/methods.dart';
import 'package:flutter/material.dart';

class AuthState extends StatefulWidget {
  const AuthState({super.key});

  @override
  State<AuthState> createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserHelper.getJWT(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material();
        }

        if (!snapshot.hasData || snapshot.data["status"] == "FAILED") {
          return LoginPage(
            onLogin: () {
              setState(() {});
            },
          );
        }

        return HomePage(
          onUserEdit: () {
            setState(() {});
          },
          onLogout: () {
            setState(() {});
            Methods.showSnackBar(context, content: "Logout Success");
          },
        );
      },
    );
  }
}
