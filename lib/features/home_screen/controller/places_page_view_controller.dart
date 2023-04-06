import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/constants/constants.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/nearby_places_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/search_controller.dart';

import '../../../core/models/models.dart';

class PlacesPageViewController extends GetxController {
  late SearchController _searchController;
  late NearbyPlacesController _nearbyPlacesController;
  late HomeController _homeController;

  late PageController pageController;

  RxBool cardTapped = false.obs;
  RxInt prevPage = 0.obs;
  RxInt photoGalleryIndex = 0.obs;
  RxString placeImg = ''.obs;
  RxBool showBlankCard = false.obs;

  PlacesPageViewController() {
    initPageController();
  }

  void initPageController() {
    pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.85,
    )
      ..addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    _searchController = Get.find<SearchController>();
    _nearbyPlacesController = Get.find<NearbyPlacesController>();
    _homeController = Get.find<HomeController>();
  }

  Size get screenSize => _homeController.size;

  void _onScroll() {
    if (pageController.page!.toInt() != prevPage.value) {
      prevPage.value = pageController.page!.toInt();
      cardTapped.value = false;
      photoGalleryIndex.value = 1;
      showBlankCard.value = false;
      goToTappedPlace();
      fetchImage();
    }
  }

  // image to place inside the tile in the pageView at bottom of map
  void fetchImage() async {
    if (null != pageController.page) {
      if (_nearbyPlacesController.nearbyPlaces[pageController.page!.toInt()]
          .photoReference.isNotEmpty) {
        placeImg.value = _nearbyPlacesController
            .nearbyPlaces[pageController.page!.toInt()].photoReference;
      }
    } else {
      placeImg.value = '';
    }
  }

  void goToTappedPlace() async {
    final GoogleMapController controller =
    await _homeController.mapController.value.future;
    _homeController.initMarkers();

    NearbyPlace tappedPlace =
    _nearbyPlacesController.nearbyPlaces[pageController.page!.toInt()];

    // setting single place marker when tapped on any place
    _nearbyPlacesController.setNearbyPlaceSingleMarker(
      tappedPlace.position,
      tappedPlace.types,
    );

    // animating camera to that specific marker
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: tappedPlace.position,
        zoom: 14,
        bearing: 45,
        tilt: 45,
      ),
    ));
  }

  toggleCardTapped() => cardTapped.value = !cardTapped.value;

  String getPlaceImageUrl(int index) {
    if (_nearbyPlacesController.nearbyPlaces[index].photoReference.isNotEmpty) {
      return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=${Constants
          .API_KEY}';
    } else {
      return 'https://pic.onlinewebfonts.com/svg/img_546302.png';
    }
  }

  NearbyPlace getNearbyPlaceByIndex(int index) {
    return _nearbyPlacesController.nearbyPlaces[index];
  }
}
