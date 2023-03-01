import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import '../../../core/models/models.dart';

class HomeController extends GetxController {
  late BuildContext context;
  late Size size;
  late Rx<Completer<GoogleMapController>> mapController;
  RxBool searchToggle = false.obs;
  RxBool radiusSlider = false.obs;
  RxBool cardTapped = false.obs;
  RxBool pressedNear = false.obs;
  RxBool getDirections = false.obs;
  late Rx<TextEditingController> searchTextController;
  late Rx<TextEditingController> destTextController;
  late RxSet<Marker> markers;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  late RxList<Place> places;
  late Timer? _timer;
  RxBool isLoading = false.obs;
  RxBool showResult = false.obs;
  late int markerIdCounter;

  HomeController() {
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
    mapController = Completer<GoogleMapController>().obs;
    searchTextController = TextEditingController().obs;
    destTextController = TextEditingController().obs;
    markers = <Marker>{}.obs;
    places = RxList<Place>();
    _timer = null;
    markerIdCounter = 1;
  }

  init(BuildContext context) {
    this.context = context;
    size = MediaQuery.of(context).size;
  }

  void onTextChanged(String text, bool searchSinglePlace) {
    searchSinglePlace
        ? getSingleSearchPlaces(text)
        : getOriginToDestPlaces(text);
  }

  getSingleSearchPlaces(String text) {
    if (null != _timer && (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    _timer = Timer(
      const Duration(milliseconds: 700),
      () async {
        if (text.length > 2) {
          isLoading.value = true;
          markers = <Marker>{}.obs;
          await getSearchPlaces(text);
          isLoading.value = false;
          showResult.value = true;
        }
      },
    );
  }

  getOriginToDestPlaces(String text) {}

  void _setMarker({required LatLng latLng}) {
    Marker marker = Marker(
      markerId: MarkerId('marker_$markerIdCounter++'),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
    );
    markers.add(marker);
  }

  Future<void> _gotoSearchPlace({
    required double lat,
    required double lng,
  }) async {
    _setMarker(latLng: LatLng(lat, lng));
    final GoogleMapController controller = await mapController.value.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        lat,
        lng,
      ),
      zoom: 12,
    )));
  }

  Future<void> getPlaceById(String placeId) async {
    showResult.value = false;
    try {
      var place = await _placeAutocompleteRepo.getPlace(placeId);
      final placeLatLng = place['geometry']['location'];
      _gotoSearchPlace(
        lat: placeLatLng['lat'],
        lng: placeLatLng['lng'],
      );
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<void> getSearchPlaces(String query) async {
    try {
      final result = await _placeAutocompleteRepo.searchPlaces(query);
      places.value = result;
    } catch (exception) {
      print(exception.toString());
    }
  }

  void toggleSearch() {
    searchToggle.value = !searchToggle.value;
    searchTextController.value.text = '';
    showResult.value = false;
    radiusSlider.value = false;
    cardTapped.value = false;
    pressedNear.value = false;
    getDirections.value = false;
  }

  void toggleGetDirections() {
    getDirections.value = !getDirections.value;
    searchTextController.value.text = '';
    destTextController.value.text = '';
    showResult.value = false;
    radiusSlider.value = false;
    cardTapped.value = false;
    pressedNear.value = false;
    searchToggle.value = false;
  }
}
