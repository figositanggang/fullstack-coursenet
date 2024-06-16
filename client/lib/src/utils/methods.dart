import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';

class Methods {
  // ! Show SnackBar
  static void showSnackBar(
    BuildContext context, {
    required String content,
    bool isDanger = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            isDanger
                ? const Icon(Icons.error, color: Colors.white)
                : const Icon(Icons.check_circle_outline),
            const SizedBox(width: 10),
            MyText(
              content,
              color: isDanger ? Colors.white : Colors.black,
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        duration: const Duration(seconds: 2),
        backgroundColor:
            isDanger ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // ! Navigate To
  static void navigateTo(Widget page, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
