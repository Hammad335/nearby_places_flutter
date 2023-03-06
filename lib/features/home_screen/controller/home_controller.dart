import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/nearby_places_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/search_controller.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/utils.dart';

class HomeController extends GetxController {
  late BuildContext context;
  late Size size;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  late SearchController searchController;
  late NearbyPlacesController nearbyPlacesController;
  late Rx<Completer<GoogleMapController>> mapController;
  late RxSet<Marker> markers;
  late RxSet<Polyline> polylines;
  late RxList<Place> places;
  late Timer? _timer;
  RxBool isLoading = false.obs;
  late int markerIdCounter;
  late int polylineIdCounter;

  HomeController() {
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
    searchController = Get.find<SearchController>();
    nearbyPlacesController = Get.find<NearbyPlacesController>();
    mapController = Completer<GoogleMapController>().obs;
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
      var directions = await _placeAutocompleteRepo
          .getDirection(
            searchController.originTextController.value.text,
            searchController.destTextController.value.text,
          )
          .timeout(const Duration(seconds: 5));
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
      isLoading.value = false;
      Utils.showSnackBar(exception.toString());
    }
  }

  void onTextChanged(String text, bool searchSinglePlace) {
    if (searchSinglePlace) {
      if (null != _timer && (_timer?.isActive ?? false)) {
        _timer?.cancel();
      }
      _timer = Timer(
        const Duration(milliseconds: 700),
        () async {
          if (text.length > 2) {
            isLoading.value = true;
            await _getSearchPlaces(text);
            isLoading.value = false;
            searchController.showResult.value = true;
          }
        },
      );
    }
  }

  Future<void> getPlaceById(String placeId) async {
    searchController.showResult.value = false;
    try {
      var place = await _placeAutocompleteRepo.getPlace(placeId);
      final placeLatLng = place['geometry']['location'];
      _gotoSearchPlace(
        lat: placeLatLng['lat'],
        lng: placeLatLng['lng'],
      );
    } catch (exception) {
      Utils.showSnackBar(exception.toString());
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
    _setMarker(latLng: LatLng(lat, lng));
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
    } else {
      _setMarker(latLng: LatLng(destLat!, destLng!));
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(boundsSw!['lat'], boundsSw['lng']),
              northeast: LatLng(boundsNe!['lat'], boundsNe['lng']),
            ),
            32),
      );
    }
  }

  Future<void> _getSearchPlaces(String query) async {
    try {
      final result = await _placeAutocompleteRepo.searchPlaces(query);
      places.value = result;
    } catch (exception) {
      Utils.showSnackBar(exception.toString());
    }
  }
}
