import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/repository/place_autocomplete_repo.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/nearby_places_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlacesPageViewController());
    Get.put(PlaceAutocompleteRepo());
    Get.put(SearchController());
    Get.put(NearbyPlacesController());
    Get.put(HomeController());
  }
}
