import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/constants/constants.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import 'package:nearby_places_flutter/core/utils/utils.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/nearby_places_controller.dart';
import '../../../core/models/models.dart';

class PlacesPageViewController extends GetxController {
  late PlaceAutocompleteRepo _placeAutocompleteRepo;
  late NearbyPlacesController _nearbyPlacesController;
  late HomeController _homeController;

  late PageController pageController;

  Rx<NearbyPlace?> tappedPlace = null.obs;
  RxBool cardTapped = false.obs;

  RxInt prevPage = (-1).obs;
  RxInt photoGalleryIndex = 0.obs;
  RxBool showBlankCard = false.obs;

  // RxInt tappedCardIndex = 1.obs;

  RxBool isReviewsTabSelected = true.obs;
  RxBool isPhotosTabSelected = false.obs;

  PlacesPageViewController() {
    initPageController();
  }

  void initPageController() {
    pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.85,
    )..addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    _placeAutocompleteRepo = Get.find<PlaceAutocompleteRepo>();
    _nearbyPlacesController = Get.find<NearbyPlacesController>();
    _homeController = Get.find<HomeController>();
  }

  Size get screenSize => _homeController.size;

  void selectReviewsTab() {
    isReviewsTabSelected.value = true;
    isPhotosTabSelected.value = false;
  }

  void selectPhotosTab() {
    isReviewsTabSelected.value = false;
    isPhotosTabSelected.value = true;
  }

  void _onScroll() {
    if (pageController.page!.toInt() != prevPage.value) {
      prevPage.value = pageController.page!.toInt();
      cardTapped.value = false;
      photoGalleryIndex.value = 0;
      showBlankCard.value = false;
      _goToTappedPlace();
    }
  }

  void _goToTappedPlace() async {
    final GoogleMapController controller =
        await _homeController.mapController.value.future;
    _homeController.initMarkers();

    tappedPlace = getNearbyPlaceByIndex(pageController.page!.toInt()).obs;

    // setting single place marker when place cards/tiles are scrolled to specific place
    _nearbyPlacesController.setNearbyPlaceSingleMarker(
      tappedPlace.value!.position,
      tappedPlace.value!.types,
    );

    // animating camera to that specific marker
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: tappedPlace.value!.position,
        zoom: 14,
        bearing: 45,
        tilt: 45,
      ),
    ));
  }

  toggleCardTapped(int index) async {
    cardTapped.value = !cardTapped.value;
    if (cardTapped.value) {
      if (tappedPlace.value == null) {
        tappedPlace = getNearbyPlaceByIndex(index).obs;
      }
      if (tappedPlace.value!.formattedPhoneNumber.isEmpty &&
          tappedPlace.value!.formattedAddress.isEmpty) {
        try {
          // fetching more details of place like address and contact number by place_id
          var placeDetails = await _placeAutocompleteRepo.getPlaceById(
            getNearbyPlaceByIndex(index).placeId,
            Constants.PLACE_MORE_DETAIL_FIELDS,
          );

          // getting reviews and photos of place
          List<Review> reviews = _getReviews(placeDetails);
          List<PlacePhoto> photos = _getPhotos(placeDetails);

          // reinitializing tapped-place with addiotional details
          tappedPlace.value = NearbyPlace(
            placeId: tappedPlace.value!.placeId,
            position: tappedPlace.value!.position,
            name: tappedPlace.value!.name,
            types: tappedPlace.value!.types,
            businessStatus: tappedPlace.value!.businessStatus,
            formattedAddress: placeDetails['formatted_address'] ?? 'None Given',
            formattedPhoneNumber:
                placeDetails['formatted_phone_number'] ?? 'None Given',
            photoReference: tappedPlace.value!.photoReference,
            rating: tappedPlace.value!.rating,
            reviews: reviews,
            photos: photos,
          );

          // updating nearby-places-list
          _nearbyPlacesController.updatePlaceListItem(
            index,
            tappedPlace.value!,
          );
        } catch (exception) {
          Utils.showErrorSnackBar(exception.toString());
        }
      }
      _moveCameraSlightly();
    }
  }

  List<PlacePhoto> _getPhotos(Map<String, dynamic> placeDetails) {
    List<PlacePhoto> photos = <PlacePhoto>[];
    placeDetails['photos'].forEach((placePhoto) {
      photos.add(
        PlacePhoto(
          width: placePhoto['width'],
          height: placePhoto['height'],
          photoReference: placePhoto['photo_reference'],
        ),
      );
    });
    return photos;
  }

  List<Review> _getReviews(Map<String, dynamic> placeDetails) {
    List<Review> reviews = <Review>[];
    placeDetails['reviews'].forEach((review) {
      reviews.add(
        Review(
          profilePhotoUrl: review['profile_photo_url'] ?? '',
          authorName: review['author_name'] ?? 'No Name',
          rating: review['rating'] ?? 0,
          text: review['text'] ?? '',
        ),
      );
    });
    return reviews;
  }

  Future<void> _moveCameraSlightly() async {
    final GoogleMapController controller =
        await _homeController.mapController.value.future;
    NearbyPlace tappedPlace =
        getNearbyPlaceByIndex(pageController.page!.toInt());
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        tappedPlace.position.latitude + 0.0125,
        tappedPlace.position.longitude + 0.005,
      ),
      zoom: 14,
      bearing: 45,
      tilt: 45,
    )));
  }

  String getPlaceImageUrl(String photoRef) {
    if (photoRef.isNotEmpty) {
      return '${Constants.BASE_IMAGE_URL}$photoRef&key=${Constants.API_KEY}';
    } else {
      return Constants.DEFAULT_IMAGE_URL;
    }
  }

  NearbyPlace getNearbyPlaceByIndex(int index) {
    return _nearbyPlacesController.nearbyPlaces[index];
  }
}
