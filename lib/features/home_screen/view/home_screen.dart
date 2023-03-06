import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/constants/constants.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import '../../../core/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final _controller = Get.find<HomeController>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FabCircularMenuButton(
        controller: _controller,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: _controller.size.width,
                    height: _controller.size.height - 24,
                    child: GetBuilder<HomeController>(
                        init: _controller,
                        builder: (controller) {
                          return GoogleMap(
                            mapType: MapType.normal,
                            markers: _controller.markers,
                            polylines: _controller.polylines,
                            circles: _controller.nearbyPlacesController.circles,
                            initialCameraPosition:
                                Constants.initialCameraPosition,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.mapController.value
                                  .complete(controller);
                            },
                            onTap: (LatLng point) {
                              _controller.nearbyPlacesController
                                  .drawCircle(point);
                            },
                          );
                        }),
                  ),
                  Obx(
                    () => _controller.searchController.searchToggle.value
                        ? SearchTextWidget(
                            controller: _controller,
                            hintText: 'Search place here',
                            searchSinglePlace: true,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => !_controller.isLoading.value
                        ? _controller.searchController.showResult.value
                            ? _controller.places.isNotEmpty
                                ? PlacesList(controller: _controller)
                                : ResultsNotFoundWidget(controller: _controller)
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => _controller.searchController.getDirections.value
                        ? OriginToDestTextWidget(controller: _controller)
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => _controller.nearbyPlacesController.radiusSlider.value
                        ? RadiusSliderWidget(
                            nearbyPlacesController:
                                _controller.nearbyPlacesController,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
