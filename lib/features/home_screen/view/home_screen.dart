import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/constants/constants.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import '../../../core/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _controller = Get.find<HomeController>();

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
                    height: _controller.size.height - 28,
                    child: Obx(
                      () => GoogleMap(
                        mapType: MapType.normal,
                        markers: _controller.markers.value,
                        initialCameraPosition: Constants.initialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.mapController.value.complete(controller);
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => _controller.searchToggle.value
                        ? SearchTextWidget(controller: _controller)
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => !_controller.isLoading.value
                        ? _controller.showResult.value
                            ? _controller.places.isNotEmpty
                                ? PlacesList(controller: _controller)
                                : ResultsNotFoundWidget(controller: _controller)
                            : const SizedBox.shrink()
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
