import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static showInfoSnackBar(String message) {
    Get.snackbar(
      '',
      '',
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      titleText: const Text(
        'Info',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  static showErrorSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }
}
