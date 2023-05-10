import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/nearby_places_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';

class SearchController extends GetxController {
  late HomeController _homeController;
  late NearbyPlacesController _nearbyPlacesController;
  late PlacesPageViewController _placesPageViewController;

  late Rx<TextEditingController> originTextController;
  late Rx<TextEditingController> destTextController;

  RxBool searchToggle = false.obs;
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
    _homeController = Get.find<HomeController>();
    _nearbyPlacesController = Get.find<NearbyPlacesController>();
    _placesPageViewController = Get.find<PlacesPageViewController>();
  }

  void toggleGetDirections() {
    searchToggle.value = false;
    getDirections.value = !getDirections.value;
    originTextController.value.text = '';
    destTextController.value.text = '';
    _toggle();
    _homeController.polylines = <Polyline>{}.obs;
    _homeController.update();
  }

  void toggleSearch() {
    getDirections.value = false;
    searchToggle.value = !searchToggle.value;
    originTextController.value.text = '';
    _toggle();
    _homeController.update();
  }

  void hideOtherViews() {
    getDirections.value = false;
    searchToggle.value = false;
    pressedNear.value = false;
  }

  _toggle() {
    showResult.value = false;
    _nearbyPlacesController.radiusSlider.value = false;
    _placesPageViewController.cardTapped.value = false;
    pressedNear.value = false;
    _homeController.initMarkers();
    _nearbyPlacesController.circles.clear();
  }
}
