import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  late RxSet<Polyline> polylines;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  late RxList<Place> places;
  late Timer? _timer;
  RxBool isLoading = false.obs;
  RxBool showResult = false.obs;
  late int markerIdCounter;
  late int polylineIdCounter;

  HomeController() {
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
    mapController = Completer<GoogleMapController>().obs;
    searchTextController = TextEditingController().obs;
    destTextController = TextEditingController().obs;
    markers = <Marker>{}.obs;
    polylines = <Polyline>{}.obs;
    places = RxList<Place>();
    _timer = null;
    markerIdCounter = 1;
    polylineIdCounter = 1;
  }

  init(BuildContext context) {
    this.context = context;
    size = MediaQuery.of(context).size;
  }

  void getDirection() async {
    try {
      isLoading.value = true;
      var directions = await _placeAutocompleteRepo.getDirection(
        searchTextController.value.text,
        destTextController.value.text,
      );
      isLoading.value = false;
      _setPolyline(directions['polyline_decoded']);
      _gotoSearchPlace(
        lat: directions['start_location']['lat'],
        lng: directions['start_location']['lng'],
        destLat: directions['end_location']['lat'],
        destLng: directions['end_location']['lng'],
        boundsNe: directions['bounds_ne'],
        boundsSw: directions['bounds_sw'],
      );
    } catch (exception) {
      print(exception.toString());
    }
  }

  void _setPolyline(List<PointLatLng> latLngPoints) {
    polylines = <Polyline>{}.obs;
    final String polyLineId = 'polyline_$polylineIdCounter';
    polylineIdCounter++;
    polylines.add(
      Polyline(
        polylineId: PolylineId(polyLineId),
        width: 3,
        color: Colors.red,
        points: latLngPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
      ),
    );
  }

  void onTextChanged(String text, bool searchSinglePlace) {
    searchSinglePlace ? _getSingleSearchPlaces(text) : null;
  }

  _getSingleSearchPlaces(String text) {
    if (null != _timer && (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    _timer = Timer(
      const Duration(milliseconds: 700),
      () async {
        if (text.length > 2) {
          isLoading.value = true;
          markers = <Marker>{}.obs;
          await _getSearchPlaces(text);
          isLoading.value = false;
          showResult.value = true;
        }
      },
    );
  }

  void _setMarker({required LatLng latLng}) {
    Marker marker = Marker(
      markerId: MarkerId('marker_$markerIdCounter'),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
    );
    markerIdCounter++;
    markers.add(marker);
    update();
  }

  Future<void> _gotoSearchPlace({
    required double lat,
    required double lng,
    double? destLat,
    double? destLng,
    Map<String, dynamic>? boundsNe,
    Map<String, dynamic>? boundsSw,
  }) async {
    final GoogleMapController controller = await mapController.value.future;
    markers = <Marker>{}.obs;
    if (null == boundsNe &&
        null == boundsSw &&
        null == destLat &&
        null == destLng) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          lat,
          lng,
        ),
        zoom: 18,
      )));
      _setMarker(latLng: LatLng(lat, lng));
    } else {
      _setMarker(latLng: LatLng(destLat!, destLng!));
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(boundsSw!['lat'], boundsSw!['lng']),
              northeast: LatLng(boundsNe!['lat'], boundsNe['lng']),
            ),
            32),
      );
    }
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

  Future<void> _getSearchPlaces(String query) async {
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
    // markers = <Marker>{}.obs;
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
    markers = <Marker>{}.obs;
    polylines = <Polyline>{}.obs;
  }
}
