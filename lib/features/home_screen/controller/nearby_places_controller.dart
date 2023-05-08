import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/search_controller.dart';
import '../../../core/utils/utils.dart';
import 'home_controller.dart';
import 'dart:ui' as ui;

class NearbyPlacesController extends GetxController {
  late HomeController _homeController;
  late SearchController _searchController;
  late PlacesPageViewController _placesPageViewController;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;

  late RxSet<Circle> circles;
  late Rx<LatLng> tappedPoint;
  RxBool radiusSlider = false.obs;
  RxDouble radius = 3000.0.obs;

  late RxList<NearbyPlace> nearbyPlaces;
  String _tokenKey = '';

  RxBool isLoading = false.obs;
  late Timer? _timer;

  NearbyPlacesController() {
    _timer = null;
    _initCircles();
    _initNearbyPlaces();
  }

  @override
  void onReady() {
    super.onReady();
    _homeController = Get.find<HomeController>();
    _searchController = Get.find<SearchController>();
    _placesPageViewController = Get.find<PlacesPageViewController>();
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
  }

  void _initNearbyPlaces() {
    nearbyPlaces = <NearbyPlace>[].obs;
  }

  void _initCircles() {
    circles = <Circle>{}.obs;
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> _getMarkerIcon(List<String> types) async {
    final Uint8List markerIcon;
    if (types.contains('restaurants')) {
      markerIcon = await _getBytesFromAsset('assets/icons/restaurants.png', 75);
    } else if (types.contains('food')) {
      markerIcon = await _getBytesFromAsset('assets/icons/food.png', 75);
    } else if (types.contains('school')) {
      markerIcon = await _getBytesFromAsset('assets/icons/schools.png', 75);
    } else if (types.contains('bar')) {
      markerIcon = await _getBytesFromAsset('assets/icons/bars.png', 75);
    } else if (types.contains('lodging')) {
      markerIcon = await _getBytesFromAsset('assets/icons/hotels.png', 75);
    } else if (types.contains('store')) {
      markerIcon =
          await _getBytesFromAsset('assets/icons/retail-stores.png', 75);
    } else if (types.contains('locality')) {
      markerIcon =
          await _getBytesFromAsset('assets/icons/local-services.png', 75);
    } else {
      // show more icons based on different places
      // icons are stored in assets
      markerIcon = await _getBytesFromAsset('assets/icons/places.png', 75);
    }
    return markerIcon;
  }

  void _setNearbyPlacesMarkers(List<NearbyPlace> places) async {
    // _homeController.initMarkers();
    for (var place in places) {
      final Uint8List markerIcon = await _getMarkerIcon(place.types);
      _homeController.setMarker(
        latLng: place.position,
        markerIcon: BitmapDescriptor.fromBytes(markerIcon),
      );
    }
  }

  void setNearbyPlaceSingleMarker(LatLng position, List<String> types) async {
    final Uint8List markerIcon = await _getMarkerIcon(types);
    _homeController.setMarker(
      latLng: position,
      markerIcon: BitmapDescriptor.fromBytes(markerIcon),
    );
  }

  void getNearbyPlaces() {
    isLoading.value = true;
    if (null != _timer && (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    try {
      _timer = Timer(const Duration(seconds: 2), () async {
        if (_searchController.pressedNear.value && 'none' == _tokenKey) {
          // it means all nearby places are fetched and there are no more place left
          isLoading.value = false;
          Utils.showInfoSnackBar('All places are fetched, no more places!');
        } else {
          Map<String, dynamic> jsonResult;
          if (_searchController.pressedNear.value) {
            // showing more  nearby-places, onClicking button again
            jsonResult = await _placeAutocompleteRepo.getNearbyPlaces(
              tokenKey: _tokenKey,
            );
          } else {
            // fetching nearby places for the first time onClick
            jsonResult = await _placeAutocompleteRepo.getNearbyPlaces(
              location: tappedPoint.value,
              radius: radius.toInt(),
            );
          }

          // for showing markers each time to new places only
          List<NearbyPlace> places =
              jsonResult['nearby_places'] as List<NearbyPlace>;

          nearbyPlaces.addAll(places);
          _tokenKey = jsonResult['token'] ?? 'none'; // for more nearbyPlaces
          isLoading.value = false;

          // showing markers to newly fetched places
          _setNearbyPlacesMarkers(places);

          // this shows horizontal pageView at bottom showing cards for each place
          _searchController.pressedNear.value = true;
        }
      });
    } catch (exception) {
      isLoading.value = false;
      Utils.showErrorSnackBar(exception.toString());
    }
  }

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
    _initNearbyPlaces();
    _searchController.hideOtherViews();
    _homeController.initMarkers();
    radiusSlider.value = true;
    _homeController.update();
  }

  void closeSlider() {
    radiusSlider.value = false;
    _searchController.pressedNear.value = false;
    _placesPageViewController.cardTapped.value = false;
    radius.value = 3000;
    _initCircles();
    _homeController.initMarkers();
    _initNearbyPlaces();
    _placesPageViewController.update();
    _homeController.update();
  }
}
