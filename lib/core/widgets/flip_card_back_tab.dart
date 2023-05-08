import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';

class FlipCardBackTab extends StatelessWidget {
  final PlacesPageViewController controller;
  final String label;
  final VoidCallback onPressed;
  final bool isReviewTab;

  const FlipCardBackTab({
    super.key,
    required this.controller,
    required this.label,
    required this.onPressed,
    required this.isReviewTab,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeIn,
          padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isReviewTab
                ? controller.isReviewsTabSelected.value
                    ? Colors.green.shade300
                    : Colors.white
                : controller.isPhotosTabSelected.value
                    ? Colors.green.shade300
                    : Colors.white,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isReviewTab
                  ? controller.isReviewsTabSelected.value
                      ? Colors.white
                      : Colors.black87
                  : controller.isPhotosTabSelected.value
                      ? Colors.white
                      : Colors.black87,
              fontFamily: 'WorkSans',
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
