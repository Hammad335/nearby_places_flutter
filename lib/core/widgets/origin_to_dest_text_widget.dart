import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class OriginToDestTextWidget extends StatelessWidget {
  final HomeController controller;

  const OriginToDestTextWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchTextWidget(
          controller: controller,
          hintText: 'Origin',
          searchSinglePlace: false,
        ),
        SearchTextWidget(
          controller: controller,
          hintText: 'Destination',
          searchSinglePlace: false,
          destTextController:
              controller.searchController.destTextController.value,
          paddingTop: 10,
        ),
      ],
    );
  }
}
