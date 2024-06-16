import 'package:client/src/helpers/user_helper.dart';
import 'package:client/src/utils/methods.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    usernameController.dispose();
    passwordController.dispose();
  }

  void register() async {
    final response = await UserHelper.regiser(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    // ! Show Loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (context) => MyDialog.loading(context),
      );
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
    }

    if (response["status"] == "SUCCESS") {
      if (context.mounted) {
        Methods.showSnackBar(context, content: "Register Success");
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        Methods.showSnackBar(context,
            content: response["body"], isDanger: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 5,
            ),
            const MyText(
              "Register an Account",
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // @ Username Field
                    MyTextField(
                      labelText: "Username",
                      controller: usernameController,
                    ),
                    const SizedBox(height: 20),

                    // @ Password Field
                    MyTextField(
                      labelText: "Password",
                      controller: passwordController,
                      obscureText: obscureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: obscureText
                              ? Colors.black
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // @ Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            register();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const MyText("Register", color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // @ Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          surfaceTintColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        child:
                            const MyText("Back to login", color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
