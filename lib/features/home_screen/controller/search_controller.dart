import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class SearchController extends GetxController {
  late Rx<TextEditingController> originTextController;
  late Rx<TextEditingController> destTextController;
  late HomeController _controller;
  RxBool searchToggle = false.obs;
  RxBool radiusSlider = false.obs;
  RxBool cardTapped = false.obs;
  RxBool pressedNear = false.obs;
  RxBool getDirections = false.obs;
  RxBool showResult = false.obs;

  SearchController() {
    originTextController = TextEditingController().obs;
    destTextController = TextEditingController().obs;
  }

  @override
  void onReady() {
    super.onReady();
    _controller = Get.find<HomeController>();
  }

  void toggleGetDirections() {
    getDirections.value = !getDirections.value;
    originTextController.value.text = '';
    destTextController.value.text = '';
    showResult.value = false;
    radiusSlider.value = false;
    cardTapped.value = false;
    pressedNear.value = false;
    searchToggle.value = false;
    _controller.markers = <Marker>{}.obs;
    _controller.polylines = <Polyline>{}.obs;
    _controller.update();
  }

  void toggleSearch() {
    searchToggle.value = !searchToggle.value;
    originTextController.value.text = '';
    showResult.value = false;
    radiusSlider.value = false;
    cardTapped.value = false;
    pressedNear.value = false;
    getDirections.value = false;
    _controller.markers = <Marker>{}.obs;
    _controller.update();
  }
}
