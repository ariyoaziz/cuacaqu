import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cuacaqu/controllers/home_controller.dart'; // Import Controller yang sudah dibuat

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
        () => HomeController()); // Inisialisasi controller
  }
}
