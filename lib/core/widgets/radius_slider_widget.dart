import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/nearby_places_controller.dart';

class RadiusSliderWidget extends StatelessWidget {
  final NearbyPlacesController nearbyPlacesController;

  const RadiusSliderWidget({super.key, required this.nearbyPlacesController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Container(
        height: 50,
        color: Colors.black.withOpacity(0.3),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => Slider(
                  max: 7000,
                  min: 1000,
                  value: nearbyPlacesController.radius.value,
                  onChanged: (double newValue) =>
                      nearbyPlacesController.changeCircleRadius(newValue),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.near_me,
                // color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
