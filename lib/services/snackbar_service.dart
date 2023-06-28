import 'package:flutter/material.dart';

class SnackBarService {
  static void showSnackBar(String text, BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey,
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
