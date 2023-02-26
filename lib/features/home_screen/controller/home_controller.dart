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
  late Rx<TextEditingController> textController;
  late RxSet<Marker> markers;
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  late RxList<Place> places;
  late Timer? _timer;
  RxBool isLoading = false.obs;
  RxBool showResult = false.obs;

  HomeController() {
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
    mapController = Completer<GoogleMapController>().obs;
    textController = TextEditingController().obs;
    markers = <Marker>{}.obs;
    places = RxList<Place>();
    _timer = null;
  }

  init(BuildContext context) {
    this.context = context;
    size = MediaQuery.of(context).size;
  }

  void onTextChanged(String text) {
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
    textController.value.text = '';
    showResult.value = false;
    radiusSlider.value = false;
    cardTapped.value = false;
    pressedNear.value = false;
    getDirections.value = false;
  }
}
