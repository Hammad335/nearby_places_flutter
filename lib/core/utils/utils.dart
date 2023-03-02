import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static showSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }
}
