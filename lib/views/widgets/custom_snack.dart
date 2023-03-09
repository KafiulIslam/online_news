import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../utils/color.dart';

class CustomSnack {

  static void successSnack(String message) {
    Get.snackbar(
      'Congratulations!',
      message,
      colorText: Colors.white,
      backgroundColor: black,
      icon: const Icon(Icons.add_alert,color: white,),
    );
  }

  static void warningSnack(String message) {
    Get.snackbar(
      'Warning!',
      message,
      colorText: Colors.white,
      backgroundColor: black,
      icon: const Icon(Icons.add_alert,color: white,),
    );
  }

}

