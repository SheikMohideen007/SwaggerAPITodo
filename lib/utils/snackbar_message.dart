import 'package:flutter/material.dart';

class SnackBarMessage {
  static showSnackBar(BuildContext context, String message, Color col) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: col,
      ),
    );
  }
}
