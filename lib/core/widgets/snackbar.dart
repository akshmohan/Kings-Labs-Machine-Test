import 'package:flutter/material.dart';

void showSnackbar(String message, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
}