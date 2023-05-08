import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/core/widgets/widgets.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';

class PlaceDetailsFlipCard extends StatelessWidget {
  final PlacesPageViewController controller;

  const PlaceDetailsFlipCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    NearbyPlace tappedPlace = controller
        .getNearbyPlaceByIndex(controller.pageController.page!.toInt());
    return Positioned(
      top: 100,
      left: 15,
      child: FlipCard(
        front: Container(
          width: 175,
          height: 250,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 175,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        controller.getPlaceImageUrl(tappedPlace.photoReference),
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                DetailRow(
                  caption: 'Address : ',
                  value: tappedPlace.formattedAddress,
                ),
                DetailRow(
                  caption: 'Contact : ',
                  value: tappedPlace.formattedPhoneNumber,
                ),
              ],
            ),
          ),
        ),
        back: Container(
          height: 300.0,
          width: 225.0,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlipCardBackTab(
                      controller: controller,
                      label: 'Reviews',
                      onPressed: () => controller.toggleReviewsTab(),
                      isReviewTab: true,
                    ),
                    FlipCardBackTab(
                      controller: controller,
                      label: 'Photos',
                      onPressed: () => controller.togglePhotosTab(),
                      isReviewTab: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String caption;
  final String value;

  const DetailRow({super.key, required this.caption, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      width: 175,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}