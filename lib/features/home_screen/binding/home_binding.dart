import 'package:get/get.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
