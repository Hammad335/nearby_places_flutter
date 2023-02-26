import 'package:flutter/material.dart';
import 'package:nearby_places_flutter/core/widgets/widgets.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class PlacesList extends StatelessWidget {
  final HomeController controller;

  const PlacesList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      controller: controller,
      child: ListView.builder(
        itemCount: controller.places.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => PlaceItem(
          place: controller.places[index],
          controller: controller,
        ),
      ),
    );
  }
}
