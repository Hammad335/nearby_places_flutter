import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/search_controller.dart';
import '../../../core/utils/utils.dart';
import 'home_controller.dart';
import 'dart:ui' as ui;

class NearbyPlacesController extends GetxController {
  late HomeController _homeController;
  late SearchController _searchController;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  RxBool radiusSlider = false.obs;
  late RxSet<Circle> circles;
  late Rx<LatLng> tappedPoint;
  RxDouble radius = 3000.0.obs;
  late Timer? _timer;
  late RxList<NearbyPlace> nearbyPlaces;
  RxBool isLoading = false.obs;
  String _tokenKey = '';

  NearbyPlacesController() {
    circles = <Circle>{}.obs;
    _timer = null;
    nearbyPlaces = <NearbyPlace>[].obs;
  }

  @override
  void onReady() {
    super.onReady();
    _homeController = Get.find<HomeController>();
    _searchController = Get.find<SearchController>();
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
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
      markerIcon = await _getBytesFromAsset('assets/icons/places.png', 75);
    }
    return markerIcon;
  }

  void _setNearbyPlacesMarkers() async {
    _homeController.markers = <Marker>{}.obs;
    for (var place in nearbyPlaces) {
      final Uint8List markerIcon = await _getMarkerIcon(place.types);
      _homeController.setMarker(
        latLng: place.position,
        markerIcon: BitmapDescriptor.fromBytes(markerIcon),
      );
    }
  }

  void getNearbyPlaces() {
    isLoading.value = true;
    if (null != _timer && (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    try {
      _timer = Timer(const Duration(seconds: 2), () async {
        var jsonResult = await _placeAutocompleteRepo.getNearbyPlaces(
          tappedPoint.value,
          radius.toInt(),
        );
        nearbyPlaces.value = jsonResult['nearby_places'] as List<NearbyPlace>;
        _tokenKey = jsonResult['token'] ?? 'none'; // for more nearbyPlaces
        isLoading.value = false;
        _setNearbyPlacesMarkers();
      });
    } catch (exception) {
      isLoading.value = false;
      Utils.showSnackBar(exception.toString());
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
    _searchController.getDirections.value = false;
    _searchController.searchToggle.value = false;
    radiusSlider.value = true;
    // _searchController.update();
    _homeController.update();
  }
}
