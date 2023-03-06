import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/search_controller.dart';
import '../../../core/utils/utils.dart';
import 'home_controller.dart';

class NearbyPlacesController extends GetxController {
  late HomeController _homeController;
  late SearchController _searchController;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  RxBool radiusSlider = false.obs;
  late RxSet<Circle> circles;
  late Rx<LatLng> tappedPoint;
  RxDouble radius = 3000.0.obs;
  late Timer? _timer;
  late RxList allFavoritePlaces;
  String _tokenKey = '';

  NearbyPlacesController() {
    circles = <Circle>{}.obs;
    _timer = null;
    allFavoritePlaces = [].obs;
  }

  @override
  void onReady() {
    super.onReady();
    _homeController = Get.find<HomeController>();
    _searchController = Get.find<SearchController>();
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
  }

  void _setNearbyPlacesMarkers() {
    _homeController.markers = <Marker>{}.obs;
  }

  // void getNearbyPlaces() {
  //   if (null != _timer && (_timer?.isActive ?? false)) {
  //     _timer?.cancel();
  //   }
  //   try {
  //     _timer = Timer(const Duration(seconds: 2), () async {
  //       var jsonResults = await _placeAutocompleteRepo.getNearbyPlaces(
  //         tappedPoint.value,
  //         radius.toInt(),
  //       );
  //       allFavoritePlaces.value = jsonResults['results'] as List;
  //       _tokenKey = jsonResults['next_page_token'] ?? 'none';
  //       _setNearbyPlacesMarkers();
  //     });
  //   } catch (exception) {
  //     Utils.showSnackBar(exception.toString());
  //   }
  // }

  void changeCircleRadius(double newRadiusVal) {
    radius.value = newRadiusVal;
    _searchController.pressedNear.value = false;
    drawCircle(tappedPoint.value);
  }

  void drawCircle(LatLng point) async {
    tappedPoint = point.obs;
    final GoogleMapController mapController =
        await _homeController.mapController.value.future;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12),
      ),
    );
    circles.add(
      Circle(
        circleId: const CircleId('circle_id'),
        center: point,
        fillColor: Colors.blue.withOpacity(0.1),
        radius: radius.value,
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    );
    _searchController.getDirections.value = false;
    _searchController.searchToggle.value = false;
    radiusSlider.value = true;
    // _searchController.update();
    _homeController.update();
  }
}
