import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';

import '../../constants/constants.dart';

class PlacePhotosGallery extends StatelessWidget {
  final PlacesPageViewController controller;
  final List<PlacePhoto> photos;

  const PlacePhotosGallery(
      {super.key, required this.controller, required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      controller.showBlankCard.value = true;
      return const Center(
        child: Text(
          'No Photos',
          style: TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      var maxWidth = photos[controller.photoGalleryIndex.value].width;
      var maxHeight = photos[controller.photoGalleryIndex.value].height;
      return Column(
        children: [
          const SizedBox(height: 10),
          Obx(
            () => Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=${photos[controller.photoGalleryIndex.value].photoReference}&key=${Constants.API_KEY}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.photoGalleryIndex.value != 0) {
                    controller.photoGalleryIndex.value =
                        controller.photoGalleryIndex.value - 1;
                  } else {
                    controller.photoGalleryIndex.value = 0;
                  }
                },
                child: Obx(
                  () => Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: controller.photoGalleryIndex.value != 0
                          ? Colors.green.shade500
                          : Colors.grey.shade500,
                    ),
                    child: const Center(
                      child: Text(
                        'Prev',
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Text(
                  '${controller.photoGalleryIndex.value + 1} / ${photos.length}',
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (controller.photoGalleryIndex.value != photos.length - 1) {
                    controller.photoGalleryIndex.value =
                        controller.photoGalleryIndex.value + 1;
                  } else {
                    controller.photoGalleryIndex.value = photos.length - 1;
                  }
                },
                child: Obx(
                  () => Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: controller.photoGalleryIndex.value !=
                              photos.length - 1
                          ? Colors.green.shade500
                          : Colors.grey.shade500,
                    ),
                    child: const Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontFamily: 'WorkSans',
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }
  }
}
